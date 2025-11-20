import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio_pack;
import 'package:dio/dio.dart';
import 'package:gosharpsharp/core/routing/app_pages.dart' show Routes;
import 'package:gosharpsharp/core/utils/exports.dart';

class CoreService extends GetConnect {
  final _dio = dio_pack.Dio();
  bool _hasUnauthorizedErrorOccurred = false; // Instance-level flag to track 401 errors
  bool _isHandlingUnauthorized = false; // Flag to prevent multiple redirects

  CoreService() {
    // _dio.options.baseUrl = dotenv.env['BASE_URL']!;
    _dio.options.baseUrl = "https://staging.gosharpsharp.com/api/v1";
    setConfig();
  }
  final getStorage = GetStorage();

  Map<String, String> multipartHeaders = {};

  void setConfig() {

    _dio.interceptors.add(
      dio_pack.InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_hasUnauthorizedErrorOccurred) {
            // If a 401 error has occurred, cancel this request
            return handler.reject(
              dio_pack.DioException(
                requestOptions: options,
                type: dio_pack.DioExceptionType.cancel,
                error: 'Request cancelled due to previous 401 error',
              ),
            );
          }

          var token = getStorage.read('token');
          options.headers['Content-Type'] = 'application/json';
          if (token != null) {
            options.headers['Authorization'] = "Bearer $token";
          }

          // Log API Request
          log(
            '\n╔══════════════════════════════════════════════════════════════════════════════╗',
          );
          log('║ 🚀 API REQUEST');
          log(
            '╠══════════════════════════════════════════════════════════════════════════════╣',
          );
          log('║ Method: ${options.method}');
          log('║ URL: ${options.uri}');
          log(
            '╠══════════════════════════════════════════════════════════════════════════════╣',
          );
          log('║ Headers:');
          options.headers.forEach((key, value) {
            if (key.toLowerCase() != 'authorization') {
              log('║   $key: $value');
            } else {
              log('║   $key: ${value.toString().substring(0, 20)}...');
            }
          });
          if (options.queryParameters.isNotEmpty) {
            log(
              '╠══════════════════════════════════════════════════════════════════════════════╣',
            );
            log('║ Query Parameters:');
            options.queryParameters.forEach((key, value) {
              log('║   $key: $value');
            });
          }
          if (options.data != null) {
            log(
              '╠══════════════════════════════════════════════════════════════════════════════╣',
            );
            log('║ Request Body:');
            log('║ ${options.data}');
          }
          log(
            '╚══════════════════════════════════════════════════════════════════════════════╝\n',
          );

          return handler.next(options); // Continue with the request
        },
        onResponse: (response, handler) {
          // Log API Response
          log(
            '\n╔══════════════════════════════════════════════════════════════════════════════╗',
          );
          log('║ ✅ API RESPONSE');
          log(
            '╠══════════════════════════════════════════════════════════════════════════════╣',
          );
          log('║ Method: ${response.requestOptions.method}');
          log('║ URL: ${response.requestOptions.uri}');
          log('║ Status Code: ${response.statusCode}');
          log(
            '╠══════════════════════════════════════════════════════════════════════════════╣',
          );
          log('║ Response Body:');
          log('║ ${response.data}');
          log(
            '╚══════════════════════════════════════════════════════════════════════════════╝\n',
          );

          return handler.next(response); // Handle the response
        },
        onError: (DioException error, handler) {
          // Log API Error
          log(
            '\n╔══════════════════════════════════════════════════════════════════════════════╗',
          );
          log('║ ❌ API ERROR');
          log(
            '╠══════════════════════════════════════════════════════════════════════════════╣',
          );
          log('║ Method: ${error.requestOptions.method}');
          log('║ URL: ${error.requestOptions.uri}');
          log('║ Error Type: ${error.type}');
          if (error.response != null) {
            log('║ Status Code: ${error.response?.statusCode}');
            log(
              '╠══════════════════════════════════════════════════════════════════════════════╣',
            );
            log('║ Error Response:');
            log('║ ${error.response?.data}');
          } else {
            log(
              '╠══════════════════════════════════════════════════════════════════════════════╣',
            );
            log('║ Error Message: ${error.message}');
          }
          log(
            '╚══════════════════════════════════════════════════════════════════════════════╝\n',
          );

          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            return handler.resolve(
              dio_pack.Response(
                requestOptions: error.requestOptions,
                data: {
                  'status': 'error',
                  'data': 'Error',
                  'message': 'Request timeout',
                },
                statusCode: 408, // Standard HTTP code for timeout
              ),
            );
          }
          if (error.response?.statusCode == 401) {
            // Set flag to cancel all subsequent requests
            _hasUnauthorizedErrorOccurred = true;

            // Only handle unauthorized access once
            if (!_isHandlingUnauthorized && Get.currentRoute != Routes.SIGN_IN) {
              _isHandlingUnauthorized = true;
              handleUnauthorizedAccess();
            }

            // Cancel this error to prevent it from propagating
            return handler.reject(
              dio_pack.DioException(
                requestOptions: error.requestOptions,
                type: dio_pack.DioExceptionType.cancel,
                error: 'Session expired',
              ),
            );
          }
          return handler.next(error); // Continue handling other errors
        },
      ),
    );
  }

  void handleUnauthorizedAccess() {
    getStorage.remove('token'); // Clear token
    customDebugPrint("Session expired - redirecting to login");

    // Use a slight delay to ensure all pending requests are cancelled
    Future.delayed(Duration(milliseconds: 100), () {
      if (Get.currentRoute != Routes.SIGN_IN) {
        Get.offAllNamed(Routes.SIGN_IN);
      }
    });
  }

  /// Helper method to safely parse API response data
  /// Handles cases where response data might be a String instead of Map
  APIResponse _parseResponse(dynamic responseData) {
    try {
      if (responseData is String) {
        return APIResponse(
          status: "error",
          data: "Error",
          message: responseData.isNotEmpty ? responseData : "Something went wrong",
        );
      }
      return APIResponse.fromMap(responseData);
    } catch (parseError) {
      log("Error parsing response: $parseError");
      return APIResponse(
        status: "error",
        data: "Error",
        message: "Invalid response format from server",
      );
    }
  }

  // login post
  Future<APIResponse> sendLogin(String url, payload) async {
    try {
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        await getStorage.write("id", payload['id']);
        await getStorage.write("password", payload['password']);
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong ",
        );
      }
    } catch (e) {
      log("Unexpected error in sendLogin: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }
    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // general post
  Future<APIResponse> send(String url, payload) async {
    try {
      // Debug: Print payload before sending
      print("CoreService.send - payload type: ${payload.runtimeType}");
      print("CoreService.send - payload: $payload");

      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong ",
        );
      }
    } catch (e) {
      log("Unexpected error in send: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }
    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // general upload
  Future<APIResponse> upload(String url, String path) async {
    try {
      dio_pack.MultipartFile file = await dio_pack.MultipartFile.fromFile(path);
      dio_pack.FormData payload = dio_pack.FormData.fromMap({
        'attach_file': file,
      });
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
    } catch (e) {
      log("Unexpected error in upload: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }
    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // general get
  Future<APIResponse> fetch(String url) async {
    try {
      final res = await _dio.get(url);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
    } catch (e) {
      log("Unexpected error in fetch: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }
    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // general get by params
  Future<APIResponse> fetchByParams(
    String url,
    Map<String, dynamic> params,
  ) async {
    try {
      final res = await _dio.get(url, queryParameters: params);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
    } catch (e) {
      log("Unexpected error in fetchByParams: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }
    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // general put
  Future<APIResponse> update(String url, data) async {
    try {
      final res = await _dio.put(url, data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
    } catch (e) {
      log("Unexpected error in update: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }
    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // general patch
  Future<APIResponse> generalPatch(String url, data) async {
    try {
      final res = await _dio.patch(url, data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
    } catch (e) {
      log("Unexpected error in generalPatch: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }
    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // form put
  Future<APIResponse> formUpdate(String url, Map<String, dynamic> data) async {
    try {
      // Build the FormData payload dynamically
      final Map<String, dynamic> formDataMap = {};

      for (var entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value != null) {
          // If the value is a file path, convert it to MultipartFile
          if (key == 'avatar' && value is File) {
            formDataMap[key] = await dio_pack.MultipartFile.fromFile(
              value.path,
            );
          } else {
            formDataMap[key] = value;
          }
        }
      }

      dio_pack.FormData payload = dio_pack.FormData.fromMap(formDataMap);
      // Perform the PUT request
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
    } catch (e) {
      log("Unexpected error in formUpdate: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }

    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // form put
  Future<APIResponse> formPost(String url, Map<String, dynamic> data) async {
    try {
      // Build the FormData payload dynamically
      // final Map<String, dynamic> formDataMap = {};
      //
      // for (var entry in data.entries) {
      //   final key = entry.key;
      //   final value = entry.value;
      //
      //   if (value != null) {
      //     // If the value is a file path, convert it to MultipartFile
      //     if (key == 'image' && value is File) {
      //       formDataMap[key] =
      //       await dio_pack.MultipartFile.fromFile(value.path);
      //     } else {
      //       formDataMap[key] = value;
      //     }
      //   }
      // }
      final Map<String, dynamic> formDataMap = {};

      // Process the receiver information
      formDataMap['receiver'] = {
        "name": data['receiver']['name'],
        "address": data['receiver']['address'],
        "phone_number": data['receiver']['phone_number'],
        "email": data['receiver']['email'],
      };

      // Process origin location
      formDataMap['origin_location'] = {
        "name": data['origin_location']['name'],
        "latitude": data['origin_location']['latitude'],
        "longitude": data['origin_location']['longitude'],
      };

      // Process destination location
      formDataMap['destination_location'] = {
        "name": data['destination_location']['name'],
        "latitude": data['destination_location']['latitude'],
        "longitude": data['destination_location']['longitude'],
      };

      // Process items with potential image files
      List<dynamic> itemsWithImages = [];
      for (var itemJson in data['items']) {
        // Check if there's an image file to upload
        if (itemJson.containsKey('image') && itemJson['image'] is File) {
          itemJson['image'] = await dio_pack.MultipartFile.fromFile(
            itemJson['image'].path,
          );
        }

        itemsWithImages.add(itemJson);
      }

      formDataMap['items'] = itemsWithImages;

      dio_pack.FormData payload = dio_pack.FormData.fromMap(formDataMap);

      // Perform the PUT request
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
    } catch (e) {
      log("Unexpected error in formPost: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }

    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }

  // general delete
  Future<APIResponse> remove(String url) async {
    try {
      final res = await _dio.delete(url);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return _parseResponse(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return _parseResponse(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
    } catch (e) {
      log("Unexpected error in remove: $e");
      return APIResponse(
          status: "error", data: "Error", message: "An unexpected error occurred");
    }
    return APIResponse(
      status: "error",
      data: "Error",
      message: "Something went wrong",
    );
  }
}
