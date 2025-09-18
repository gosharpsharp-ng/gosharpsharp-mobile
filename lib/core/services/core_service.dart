import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio_pack;
import 'package:dio/dio.dart';
import 'package:gosharpsharp/core/routing/app_pages.dart' show Routes;
import 'package:gosharpsharp/core/utils/exports.dart';

class CoreService extends GetConnect {
  final _dio = dio_pack.Dio();

  CoreService() {
    // _dio.options.baseUrl = dotenv.env['BASE_URL']!;
    _dio.options.baseUrl = "https://staging.gosharpsharp.com/api/v1";
    setConfig();
  }
  final getStorage = GetStorage();

  Map<String, String> multipartHeaders = {};

  void setConfig() {
    bool hasUnauthorizedErrorOccurred = false; // Flag to track 401 errors

    _dio.interceptors.add(
      dio_pack.InterceptorsWrapper(
        onRequest: (options, handler) {
          if (hasUnauthorizedErrorOccurred) {
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
          options.headers['content-Type'] = 'application/json';
          if (token != null) {
            options.headers['Authorization'] = "Bearer $token";
          }
          return handler.next(options); // Continue with the request
        },
        onResponse: (response, handler) {
          return handler.next(response); // Handle the response
        },
        onError: (DioException error, handler) {
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
            if (Get.currentRoute != Routes.SIGN_IN) {
              handleUnauthorizedAccess();
            }
            // Cancel this error
            return handler.reject(
              dio_pack.DioException(
                requestOptions: error.requestOptions,
                type: dio_pack.DioExceptionType.cancel,
                error: 'Request cancelled due to 401 error',
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
    showToast(
        isError: true,
        message: "Your session has expired. Please log in again.");
    Get.offAllNamed(Routes.SIGN_IN);
  }

  // login post
  Future<APIResponse> sendLogin(
    String url,
    payload,
  ) async {
    try {
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        await getStorage.write("id", payload['id']);
        await getStorage.write("password", payload['password']);
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong ");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general post
  Future<APIResponse> send(
    String url,
    payload,
  ) async {
    try {
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong ");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general upload
  Future<APIResponse> upload(String url, String path) async {
    try {
      dio_pack.MultipartFile file = await dio_pack.MultipartFile.fromFile(path);
      dio_pack.FormData payload =
          dio_pack.FormData.fromMap({'attach_file': file});
      final res = await _dio.post(
        url,
        data: payload,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general get
  Future<APIResponse> fetch(String url) async {
    try {
      final res = await _dio.get(url);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general get by params
  Future<APIResponse> fetchByParams(
      String url, Map<String, dynamic> params) async {
    try {
      final res = await _dio.get(url, queryParameters: params);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general put
  Future<APIResponse> update(String url, data) async {
    try {
      final res = await _dio.put(url, data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }

  // general patch
  Future<APIResponse> generalPatch(String url, data) async {
    try {
      final res = await _dio.patch(url, data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
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
            formDataMap[key] =
                await dio_pack.MultipartFile.fromFile(value.path);
          } else {
            formDataMap[key] = value;
          }
        }
      }

      dio_pack.FormData payload = dio_pack.FormData.fromMap(formDataMap);
      // Perform the PUT request
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
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
          itemJson['image'] =
              await dio_pack.MultipartFile.fromFile(itemJson['image'].path);
        }

        itemsWithImages.add(itemJson);
      }

      formDataMap['items'] = itemsWithImages;

      dio_pack.FormData payload = dio_pack.FormData.fromMap(formDataMap);

      // Perform the PUT request
      final res = await _dio.post(url, data: payload);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
          status: "error",
          data: "Error",
          message: "Something went wrong",
        );
      }
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
        return APIResponse.fromMap(res.data);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return APIResponse.fromMap(e.response?.data);
      } else {
        return APIResponse(
            status: "error", data: "Error", message: "Something went wrong");
      }
    }
    return APIResponse(
        status: "error", data: "Error", message: "Something went wrong");
  }
}
