import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
customDebugPrint(dynamic message){
  print("*****************************************************************************************************************");
  log(message.toString());
  print("*****************************************************************************************************************");

}
showAnyBottomSheet({required Widget child, bool isControlled = true}) {
  Get.bottomSheet(
    Wrap(children: [child]),
    isScrollControlled: isControlled,
    backgroundColor: AppColors.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.r),
        topRight: Radius.circular(25.r),
      ),
    ),
  );
}

String formatDate(String inputDate) {
  try {
    // Parse the input date string to a DateTime object
    DateTime parsedDate = DateTime.parse(inputDate);

    // Format the date to the desired format
    String formattedDate = DateFormat('EEE d MMM, yyyy').format(parsedDate);

    return formattedDate;
  } catch (e) {
    // Handle any parsing or formatting errors
    return 'Invalid date';
  }
}

String formatTime(String inputDate) {
  try {
    // Parse the input date string to a DateTime object
    DateTime parsedDate = DateTime.parse(inputDate);

    // Format the time to 12-hour format
    return DateFormat('hh:mm a').format(parsedDate);
  } catch (e) {
    // Handle any parsing or formatting errors
    return 'Invalid time';
  }
}

class InvertedPlateClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0); // Start at the top-left corner
    path.quadraticBezierTo(size.width / 2, 100, size.width,
        0); // Create an outward bulge at the top
    path.lineTo(size.width, size.height); // Right side
    path.lineTo(0, size.height); // Bottom side
    path.close(); // Left side to complete the shape
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DottedDivider extends StatelessWidget {
  final double dotSize;
  final double spacing;
  final Color color;
  final Axis axis;
  final double length;

  const DottedDivider({
    Key? key,
    this.dotSize = 8.0,
    this.spacing = 2.0,
    this.color = AppColors.primaryColor,
    this.axis = Axis.vertical, // Default to horizontal
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int dotCount = (length / (dotSize + spacing)).floor();

    return Container(
      height: axis == Axis.horizontal ? 2 : length + 2,
      width: axis == Axis.horizontal ? length : 2.sp,
      child: axis == Axis.horizontal
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dotCount,
                    itemBuilder: (context, index) {
                      return Container(
                        width: dotSize,
                        height: dotSize,
                        margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                        decoration: BoxDecoration(
                          color: color,
                          // shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: dotCount,
                    itemBuilder: (context, index) {
                      return Container(
                        width: dotSize,
                        height: dotSize,
                        margin: EdgeInsets.symmetric(vertical: spacing / 2),
                        decoration: BoxDecoration(
                          color: color,
                          // shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

detailHorizontalItem({required String title, required String detail}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.sp),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(title, fontSize: 12.sp, color: AppColors.obscureTextColor),
        SizedBox(
          width: 3.sp,
        ),
        Expanded(
            child: customText(detail,
                fontSize: 12.sp,
                color: AppColors.obscureTextColor,
                overflow: TextOverflow.visible)),
      ],
    ),
  );
}

detailVerticalItem({required String title, required String detail}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.sp),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(title,
            fontSize: 16.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w500),
        SizedBox(
          height: 2.sp,
        ),
        customText(
          detail,
          fontSize: 12.sp,
          color: AppColors.obscureTextColor,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.justify,
        ),
      ],
    ),
  );
}

detailHeader({required String header}) {
  return Container(
    margin: EdgeInsets.only(top: 12.sp, bottom: 8.sp),
    child: customText(header, fontSize: 14.sp, fontWeight: FontWeight.w500),
  );
}

class UserVerticalStatsItem extends StatelessWidget {
  final String metric;
  final String value;
  const UserVerticalStatsItem(
      {super.key, required this.metric, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          value,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(
          height: 5.sp,
        ),
        customText(
          metric,
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.obscureTextColor,
        ),
      ],
    );
  }
}

class EditIcon extends StatelessWidget {
  final Function onPressed;
  final bool isLoading;
  final String title;
  const EditIcon(
      {super.key,
      required this.onPressed,
      this.isLoading = false,
      this.title = "Edit"});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      onTap: () {
        isLoading ? null : onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.r)),
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
        margin: EdgeInsets.symmetric(vertical: 5.sp),
        child: isLoading
            ? SizedBox(
                height: 12.sp,
                width: 12.sp,
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 1.0.sp,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  customText(title,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                  SizedBox(
                    width: 8.sp,
                  ),
                  SvgPicture.asset(
                    SvgAssets.editIcon,
                    color: AppColors.primaryColor,
                    height: 14.sp,
                  ),
                ],
              ),
      ),
    );
  }
}

class SaveIcon extends StatelessWidget {
  final Function onPressed;
  final bool isLoading;
  final String title;
  const SaveIcon(
      {super.key,
      required this.onPressed,
      this.isLoading = false,
      this.title = "Save"});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      onTap: () {
        isLoading ? null : onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.r)),
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
        margin: EdgeInsets.symmetric(vertical: 5.sp),
        child: isLoading
            ? SizedBox(
                height: 12.sp,
                width: 12.sp,
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 1.0.sp,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  customText(title,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                  SizedBox(
                    width: 8.sp,
                  ),
                  SvgPicture.asset(
                    SvgAssets.saveIcon,
                    color: AppColors.primaryColor,
                    height: 14.sp,
                  ),
                ],
              ),
      ),
    );
  }
}

showToast({String message = "", bool isError = false}) {
  Get.snackbar(
    "",
    "",
    titleText: customText(isError ? "Error!" : "Success!",
        color: isError ? Colors.red : AppColors.primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 15.sp),
    messageText: customText(message.trim(),
        color: isError ? Colors.red : AppColors.primaryColor,
        overflow: TextOverflow.visible,
        fontSize: 12.sp),
    snackPosition: SnackPosition.TOP,
    backgroundColor: CupertinoColors.systemGrey5,
    colorText: isError ? Colors.red : AppColors.primaryColor,
    maxWidth: 1.sw * 0.7,
    icon: Container(
      // padding: EdgeInsets.only(left: 8.0.sp),
      margin: EdgeInsets.symmetric(horizontal: 5.0.sp),
      child: SvgPicture.asset(
        isError ? SvgAssets.errorIcon : SvgAssets.successIcon,
        height: 15.sp,
        width: 15.sp,
      ),
    ),
    borderRadius: 10.r,
    margin: EdgeInsets.only(left: 12.sp, top: 14.sp),
    duration: const Duration(seconds: 3),
  );
}

Future<CroppedFile> cropImage(XFile image) async {
  final croppedImageFile =
      await ImageCropper().cropImage(sourcePath: image.path, uiSettings: [
    AndroidUiSettings(
        toolbarColor: AppColors.primaryColor,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: false),
    IOSUiSettings(title: "Crop Image")
  ]);
  return croppedImageFile!;
}

Future<String?> uploadImageToCloudinary({
  required File file,
  required String folderName,
}) async {
  const String cloudName = 'dnp0rvouv';
  const String apiKey = '347923482662651';
  const String apiSecret = '_Af_uRnU0SivpG59mPeak5I74oo';
  final cloudinary = Cloudinary.signedConfig(
    apiKey: apiKey,
    apiSecret: apiSecret,
    cloudName: cloudName,
  );
  try {
    final response = await cloudinary.upload(
        file: file.path,
        fileBytes: file.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: folderName,
        progressCallback: (count, total) {
          print('Uploading image from file with progress: $count/$total');
        });
    if (response.isSuccessful) {
      return response.secureUrl;
    } else {
      return null;
    }
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

String formatRideDate(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  return "${_getWeekday(dateTime.weekday)}, ${dateTime.day}${_getDaySuffix(dateTime.day)} ${_getMonth(dateTime.month)}, ${dateTime.year}";
}

String _getWeekday(int weekday) {
  const weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  return weekdays[weekday - 1];
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}

String _getMonth(int month) {
  const months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return months[month - 1];
}

String formatRideTime(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  String period = hour >= 12 ? "PM" : "AM";
  hour = hour % 12;
  if (hour == 0) hour = 12;

  String minuteStr = minute.toString().padLeft(2, '0');
  return "$hour:$minuteStr $period";
}

String formatToCurrency(num number) {
  NumberFormat format = NumberFormat.currency(locale: 'en_US', symbol: '₦');
  return format.format(number);
}

formatNumber(dynamic value, {String locale = 'en_NG'}) {
  final cFormat = NumberFormat("#,##0", locale);
  if (value == null) return '₦${cFormat.format('0')}';
  return cFormat.format(value);
}

String computeAgeRange(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return '';
  }

  try {
    // Parse the date string
    final birthDate = DateTime.parse(dateString);
    final now = DateTime.now();

    // Calculate the age in years
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    // Determine the age range
    if (age < 18) {
      return 'Under 18';
    } else if (age < 30) {
      return '18-29';
    } else if (age < 40) {
      return '30-39';
    } else if (age < 50) {
      return '40-49';
    } else {
      return '50 and above';
    }
  } catch (e) {
    // Handle invalid date format
    return '';
  }
}

class PartialViewHeader extends StatelessWidget {
  final String title;
  final Function onPressed;
  const PartialViewHeader(
      {super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      child: Row(
        children: [
          Expanded(
              child: customText(title,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: AppColors.blackColor)),
          InkWell(
            onTap: () {
              onPressed();
            },
            child: Row(
              children: [
                customText("View all",
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: AppColors.primaryColor),
                SizedBox(
                  width: 8.w,
                ),
                SvgPicture.asset(
                  SvgAssets.rightChevronIcon,
                  color: AppColors.primaryColor,
                  height: 12.sp,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          customText(title,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              color: AppColors.blackColor),
        ],
      ),
    );
  }
}

class TitleSectionBox extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget> children;
  const TitleSectionBox(
      {super.key,
      required this.title,
      required this.children,
      this.backgroundColor = AppColors.whiteColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
      margin: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
      width: 1.sw,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r), color: backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(title,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: AppColors.blackColor,
              overflow: TextOverflow.visible),
          SizedBox(
            height: 5.h,
          ),
          ...children
        ],
      ),
    );
  }
}

class SectionBox extends StatelessWidget {
  final Color backgroundColor;
  CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;
  SectionBox(
      {super.key,
      required this.children,
      this.backgroundColor = AppColors.whiteColor,
      this.crossAxisAlignment = CrossAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
      margin: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
      width: 1.sw,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r), color: backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment,
        children: [...children],
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.obscureTextColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 3.0;
    const double dashSpace = 3.0;
    double startX = 0;
    final path = Path();

    while (startX < size.width) {
      path.moveTo(startX, 0); // Top border
      path.lineTo(startX + dashWidth, 0);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    while (startX < size.height) {
      path.moveTo(0, startX); // Left border
      path.lineTo(0, startX + dashWidth);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, size.height); // Bottom border
      path.lineTo(startX + dashWidth, size.height);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    while (startX < size.height) {
      path.moveTo(size.width, startX); // Right border
      path.lineTo(size.width, startX + dashWidth);
      startX += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String capitalizeText(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

bool validateEmail(String email) {
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}

bool validatePhoneNumber(String phoneNumber) {
  String pattern =
      r'^[1-9]\d{9}$'; // Starts with a digit 1-9 followed by exactly 9 digits
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(phoneNumber);
}

String getFormattedResendOTPTime(int remainingTime) {
  int minutes = remainingTime ~/ 60;
  int seconds = remainingTime % 60;

  if (remainingTime >= 60) {
    if (seconds == 0) {
      return '$minutes m';
    } else {
      return '$minutes m $seconds s';
    }
  } else {
    return '$seconds s';
  }
}

WebViewController createWebViewController({required Function successCallback}) {
  final WebViewController controller = WebViewController();

  controller
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(onPageFinished: (String url) {
        // Inject JavaScript to focus on an input field
        controller.runJavaScript('document.querySelector("input").focus();');
        if (url.contains("https://www.youtube.com")) {
          Get.back();
        }
      }, onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        if (request.url.startsWith('https://www.youtube.com')) {
          Get.back();
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      }, onUrlChange: (UrlChange? urlChange) {
        if (urlChange!.url != null &&
            urlChange.url!.contains("https://logistics.gosharpsharp.com")) {
          successCallback();
        }
      }),
    );

  return controller;
}

void showWebViewDialog(
  BuildContext context, {
  required WebViewController controller,
  required String url,
  String title = "WebView Dialog",
  VoidCallback? onDialogClosed,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      controller.loadRequest(Uri.parse(url));
      return WillPopScope(
        onWillPop: () async {
          if (onDialogClosed != null) {
            onDialogClosed();
          }
          onDialogClosed!();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: customText(title),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
                if (onDialogClosed != null) {
                  onDialogClosed();
                }
              },
            ),
          ),
          body: WebViewWidget(
            controller: controller,
          ),
        ),
      );
    },
  );
}

void showWebViewScreen(
  BuildContext context, {
  required WebViewController controller,
  required String url,
  String title = "WebView",
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) {
        controller.loadRequest(Uri.parse(url));
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: WebViewWidget(
            controller: controller,
          ),
        );
      },
    ),
  );
}

double stripCurrencyFormat(String formattedAmount) {
  if (formattedAmount.isEmpty) {
    return 1.0;
  }
  String cleanedString =
      formattedAmount.replaceAll('₦', '').replaceAll(RegExp(r'[^0-9.]'), '');

  return double.parse(cleanedString);
}

String formatTextFieldAmountToCurrency(String value) {
  // Remove any non-numeric characters except the decimal point
  String newValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

  // Return empty if the input is empty or consists of zeros only
  if (newValue.isEmpty || newValue == '0') {
    return '';
  }

  // If the value has a decimal point, ensure it's parsed as a double
  double parsedValue = double.parse(newValue);

  // Format as currency in NGN locale
  String formattedValue = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2, // Use 2 decimal places for consistency
  ).format(parsedValue);

  return formattedValue;
}

// Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(
//     LatLng originPosition, LatLng destinationPosition) async {
//   // Construct OSRM API URL
//   String osrmUrl =
//       "https://router.project-osrm.org/route/v1/driving/${originPosition.longitude},${originPosition.latitude};${destinationPosition.longitude},${destinationPosition.latitude}?overview=full&geometries=polyline";
//
//   try {
//     // Make the HTTP request
//     var osrmResponse = await Dio().get(osrmUrl);
//
//     if (osrmResponse.statusCode == 200) {
//       var data = osrmResponse.data;
//       if (data['routes'] != null && data['routes'].isNotEmpty) {
//         // Extract route details
//         var route = data['routes'][0];
//         var distance = route['distance']; // Distance in meters
//         var duration = route['duration']; // Duration in seconds
//         var geometry = route['geometry']; // Polyline points
//         // Convert to DirectionDetailsInfo
//         return DirectionDetailsInfo(
//           distance_value: distance.toInt(),
//           duration_value: duration.toInt(),
//           distance_text: "${(distance / 1000).toStringAsFixed(2)} km",
//           duration_text: "${(duration / 60).toStringAsFixed(0)} mins",
//           e_points: geometry,
//         );
//       }
//     }
//   } catch (e) {
//     print("Error fetching directions: $e");
//   }
//   return DirectionDetailsInfo();
// }
Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(
    LatLng originPosition, LatLng destinationPosition) async {
  // Construct Google Maps API URL
  String googleMapsUrl =
      "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&mode=driving&key=${Secret.apiKey}";

  try {
    // Make the HTTP request
    var response = await Dio().get(googleMapsUrl);

    if (response.statusCode == 200) {
      var data = response.data;
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        // Extract route details
        var route = data['routes'][0];
        var distance =
            route['legs'][0]['distance']['value']; // Distance in meters
        var duration =
            route['legs'][0]['duration']['value']; // Duration in seconds
        var geometry = route['overview_polyline']['points'];

        // Convert to DirectionDetailsInfo
        return DirectionDetailsInfo(
          distance_value: distance,
          duration_value: duration,
          distance_text: "${(distance / 1000).toStringAsFixed(1)} km",
          duration_text: formatRideDuration(duration),
          e_points: geometry,
        );
      }
    }
  } catch (e) {
    print("Error fetching directions: $e");
  }

  return DirectionDetailsInfo();
}

String formatRideDuration(int durationInSeconds) {
  int totalMinutes = (durationInSeconds / 60).round();
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return "$hours hr${hours > 1 ? 's' : ''} $minutes min${minutes > 1 ? 's' : ''}";
  } else if (hours > 0) {
    return "$hours hr${hours > 1 ? 's' : ''}";
  } else {
    return "$minutes min${minutes > 1 ? 's' : ''}";
  }
}

double calculateLocationDegrees(LatLng startPoint, LatLng endPoint) {
  final double startLat = toRadians(startPoint.latitude);
  final double startLng = toRadians(startPoint.longitude);
  final double endLat = toRadians(endPoint.latitude);
  final double endLng = toRadians(endPoint.longitude);

  final double deltaLng = endLng - startLng;

  final double y = math.sin(deltaLng) * math.cos(endLat);
  final double x = math.cos(startLat) * math.sin(endLat) -
      math.sin(startLat) * math.cos(endLat) * math.cos(deltaLng);

  final double bearing = math.atan2(y, x);
  return (toDegrees(bearing) + 360) % 360;
}

double toRadians(double degrees) {
  return degrees * (math.pi / 180.0);
}

double toDegrees(double radians) {
  return radians * (180.0 / math.pi);
}

Color getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case "pending":
      return AppColors.lightRedColor;
    case "confirmed":
      return AppColors.lightAmberColor;
    case "paid":
      return AppColors.lightGreenColor;
    case "assigned":
      return AppColors.lightBlueColor;
    case "enroute":
      return AppColors.lightPurpleColor;
    case "collected":
      return AppColors.lightTealColor;
    case "transit":
      return AppColors.lightOrangeColor;
    case "delivered":
      return AppColors.lightGreenColor;
    case "approved":
      return AppColors.greenColor; // ✅ Approved status color
    case "canceled":
      return AppColors.lightGreyColor;
    default:
      return AppColors.lightGreyColor;
  }
}

Color getStatusTextColor(String? status) {
  switch (status?.toLowerCase()) {
    case "pending":
      return AppColors.redColor;
    case "confirmed":
      return AppColors.amberColor;
    case "paid":
      return AppColors.greenColor;
    case "assigned":
      return AppColors.blueColor;
    case "enroute":
      return AppColors.purpleColor;
    case "collected":
      return AppColors.tealColor;
    case "transit":
      return AppColors.orangeColor;
    case "delivered":
      return AppColors.greenColor;
    case "approved":
      return AppColors.greenColor;
    case "canceled":
      return AppColors.greyColor;
    default:
      return AppColors.greyColor;
  }
}


Future<String> convertImageToBase64(String imagePath) async {
  File imageFile = File(imagePath);
  Uint8List imageBytes = await imageFile.readAsBytes();
  String base64String = base64Encode(imageBytes);
  return base64String;
}

void showRiderAndDeliveryStatusDialog(
    {required BuildContext context,
    required String title,
    required String message,
    required DeliveryModel delivery}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child:
            GetBuilder<DeliveriesController>(builder: (deliveriesController) {
          return AlertDialog(
            backgroundColor: AppColors.primaryColor,
            titlePadding: EdgeInsets.zero,
            title: customText("",
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
                overflow: TextOverflow.visible),
            content: Container(
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(title,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                      overflow: TextOverflow.visible),
                  SizedBox(
                    height: 10.h,
                  ),
                  customText(message,
                      fontSize: 16.sp,
                      color: AppColors.whiteColor,
                      overflow: TextOverflow.visible),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.r,
                        backgroundImage: delivery.rider?.avatar != null
                            ? CachedNetworkImageProvider(
                                delivery.rider!.avatar!)
                            : null,
                        backgroundColor: AppColors.backgroundColor,
                        child: delivery.rider?.avatar == null
                            ? customText(
                                "${delivery.rider?.firstName?[0] ?? ""}${delivery.rider?.lastName?[0] ?? ""}",
                                fontSize: 8.sp,
                                color: AppColors.blackColor)
                            : null,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              "${delivery.rider?.firstName ?? ""} ${delivery.rider?.lastName ?? ""}",
                              color: AppColors.whiteColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.visible,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            customText(
                              "Rider",
                              color: AppColors.whiteColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.normal,
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  deliveriesController.statusDialogIsOpened = false;
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: customText("OK",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.whiteColor),
              ),
            ],
          );
        }),
      );
    },
  );
}

void showRiderAndDeliveryStatusToast({
  required String title,
  required String message,
  required DeliveryModel delivery,
}) {
  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.backgroundColor,
    colorText: AppColors.blackColor,
    duration: Duration(seconds: 3),
    icon: CircleAvatar(
      radius: 20.r,
      backgroundImage: delivery.rider?.avatar != null
          ? CachedNetworkImageProvider(delivery.rider!.avatar!)
          : null,
      backgroundColor: AppColors.backgroundColor,
      child: delivery.rider?.avatar == null
          ? customText(
              "${delivery.rider?.firstName?[0] ?? ""}${delivery.rider?.lastName?[0] ?? ""}",
              fontSize: 12.sp,
              color: AppColors.blackColor,
            )
          : null,
    ),
    margin: EdgeInsets.all(10.w),
    borderRadius: 10.r,
  );
}

Future<bool> showLocationPermissionDialog() async {
  bool isGranted = false;

  await Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: customText("Enable Location",
          fontWeight: FontWeight.bold, fontSize: 18.sp),
      content: customText(
        "To go online, please enable location services and allow permissions.",
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        fontSize: 16.sp,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                isGranted = false;
                Get.back();
              },
              child: customText("Cancel",
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: AppColors.obscureTextColor),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              onPressed: () async {
                // Request location permission
                LocationPermission permission =
                    await Geolocator.requestPermission();

                if (permission == LocationPermission.deniedForever) {
                  // Open settings if permanently denied
                  await Geolocator.openAppSettings();
                } else if (permission == LocationPermission.denied) {
                  isGranted = false;
                } else {
                  // Check if location is enabled
                  bool isLocationEnabled =
                      await Geolocator.isLocationServiceEnabled();
                  if (!isLocationEnabled) {
                    await Geolocator.openLocationSettings();
                  }

                  // Wait and recheck if location is now enabled
                  await Future.delayed(Duration(seconds: 3));
                  isLocationEnabled =
                      await Geolocator.isLocationServiceEnabled();

                  if (isLocationEnabled) {
                    isGranted = true;
                  }
                }

                Get.back(); // Close dialog
              },
              child: customText("Enable", color: AppColors.whiteColor),
            ),
          ],
        ),
      ],
    ),
  );

  return isGranted;
}

void makePhoneCall(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    print('Could not launch $url');
  }
}



String getOpeningHours(RestaurantModel restaurant) {
  if (restaurant.schedules == null || restaurant.schedules!.isEmpty) {
    return "No schedule available";
  }

  final today = DateTime.now().weekday;
  final dayNames = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];
  final currentDay = dayNames[today - 1];

  final todaySchedule = restaurant.schedules!.firstWhere(
        (schedule) => schedule.dayOfWeek.toLowerCase() == currentDay,
    orElse: () => restaurant.schedules!.first,
  );

  final openTime = DateTime.parse(todaySchedule.openTime);
  final closeTime = DateTime.parse(todaySchedule.closeTime);

  return "${formatTimeToPmAm(openTime)} - ${formatTimeToPmAm(closeTime)}";
}

bool isRestaurantOpen(RestaurantModel restaurant) {
  if (restaurant.schedules == null || restaurant.schedules!.isEmpty) {
    return false;
  }

  final now = DateTime.now();
  final today = now.weekday;
  final dayNames = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];
  final currentDay = dayNames[today - 1];

  final todaySchedule = restaurant.schedules!.where(
    (schedule) => schedule.dayOfWeek.toLowerCase() == currentDay,
  );

  if (todaySchedule.isEmpty) {
    return false;
  }

  for (final schedule in todaySchedule) {
    try {
      final openTime = DateTime.parse(schedule.openTime);
      final closeTime = DateTime.parse(schedule.closeTime);

      final currentTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      );

      final todayOpenTime = DateTime(
        now.year,
        now.month,
        now.day,
        openTime.hour,
        openTime.minute,
      );

      final todayCloseTime = DateTime(
        now.year,
        now.month,
        now.day,
        closeTime.hour,
        closeTime.minute,
      );

      // Handle cases where close time is on the next day (e.g., opens at 9 PM, closes at 2 AM)
      if (todayCloseTime.isBefore(todayOpenTime)) {
        todayCloseTime.add(Duration(days: 1));
      }

      if (currentTime.isAfter(todayOpenTime) && currentTime.isBefore(todayCloseTime)) {
        return true;
      }
    } catch (e) {
      print("Error parsing schedule time: $e");
    }
  }

  return false;
}

String getNextOpeningTime(RestaurantModel restaurant) {
  if (restaurant.schedules == null || restaurant.schedules!.isEmpty) {
    return "Schedule unavailable";
  }

  final now = DateTime.now();
  final today = now.weekday;
  final dayNames = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  // First check if restaurant opens later today
  final currentDay = dayNames[today - 1];
  final todaySchedule = restaurant.schedules!.where(
    (schedule) => schedule.dayOfWeek.toLowerCase() == currentDay,
  );

  for (final schedule in todaySchedule) {
    try {
      final openTime = DateTime.parse(schedule.openTime);
      final todayOpenTime = DateTime(
        now.year,
        now.month,
        now.day,
        openTime.hour,
        openTime.minute,
      );

      if (todayOpenTime.isAfter(now)) {
        return "Opens at ${formatTimeToPmAm(openTime)}";
      }
    } catch (e) {
      print("Error parsing schedule time: $e");
    }
  }

  // If not opening today, check the next 6 days
  for (int i = 1; i <= 6; i++) {
    final nextDayIndex = (today + i - 1) % 7;
    final nextDay = dayNames[nextDayIndex];

    final nextDaySchedule = restaurant.schedules!.where(
      (schedule) => schedule.dayOfWeek.toLowerCase() == nextDay,
    );

    if (nextDaySchedule.isNotEmpty) {
      try {
        final schedule = nextDaySchedule.first;
        final openTime = DateTime.parse(schedule.openTime);
        final dayName = nextDay[0].toUpperCase() + nextDay.substring(1);

        if (i == 1) {
          return "Opens tomorrow at ${formatTimeToPmAm(openTime)}";
        } else {
          return "Opens $dayName at ${formatTimeToPmAm(openTime)}";
        }
      } catch (e) {
        print("Error parsing schedule time: $e");
      }
    }
  }

  return "Opening hours unavailable";
}

String formatTimeToPmAm(DateTime time) {
  final hour = time.hour;
  final minute = time.minute;
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
  return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
}

Color getRestaurantStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'active':
    case 'approved':
      return AppColors.primaryColor;
    case 'pending':
      return AppColors.orangeColor;
    case 'inactive':
      return AppColors.redColor;
    default:
      return Colors.grey;
  }
}

class NavigationHelper {
  // Method 1: Check if current route is the last one in stack
  static bool isCurrentRouteLastInStack() {
    final navigator = Get.key.currentState as NavigatorState?;
    if (navigator == null) return true;

    // Check if we can pop (if we can't pop, we're at the root/last screen)
    return !navigator.canPop();
  }

  // Method 2: Using GetX's routing system
  static bool isLastRoute() {
    return Get.routing.previous.isEmpty;
  }

  // Method 3: Check specific route name
  static bool isCurrentRoute(String routeName) {
    return Get.currentRoute == routeName;
  }

  // Method 4: Get current route info
  static String getCurrentRoute() {
    return Get.currentRoute;
  }

  // Method 5: Check if specific route is the last one
  static bool isRouteLastInStack(String routeName) {
    return Get.currentRoute == routeName && isCurrentRouteLastInStack();
  }
}