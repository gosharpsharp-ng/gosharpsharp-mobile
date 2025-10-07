import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/controllers/location_controller.dart';

class LocationDisplayWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Color textColor;
  final Color iconColor;
  final double fontSize;

  const LocationDisplayWidget({
    super.key,
    this.onTap,
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller if not already initialized
    final locationController = Get.put(LocationController());

    return Obx(() => GestureDetector(
      onTap: onTap ?? () => _showLocationOptions(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: AppColors.primaryColor,
              size: (fontSize + 4).sp,
            ),
            SizedBox(width: 6.w),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200.w),
              child: customText(
                locationController.selectedLocation.value,
                fontSize: fontSize.sp,
                fontWeight: FontWeight.w500,
                color: textColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down,
              color: iconColor.withOpacity(0.6),
              size: (fontSize + 2).sp,
            ),
          ],
        ),
      ),
    ));
  }

  void _showLocationOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            SizedBox(height: 20.h),

            // Title
            customText(
              'Select your Location to continue',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),

            SizedBox(height: 20.h),

            // Use current location option
            _buildLocationOption(
              context: context,
              icon: Icons.my_location,
              title: 'Use Current Location',
              subtitle: 'Enable GPS to find your location',
              onTap: () async {
                Navigator.pop(context);
                await _requestCurrentLocation(context);
              },
            ),

            SizedBox(height: 12.h),

            Divider(height: 1.h),

            SizedBox(height: 12.h),

            // Select manually option
            _buildLocationOption(
              context: context,
              icon: Icons.search,
              title: 'Select Manually',
              subtitle: 'Choose location from map',
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectLocation(),
                  ),
                );

                if (result != null && result is ItemLocation) {
                  final locationController = Get.find<LocationController>();
                  await locationController.updateLocation(
                    result.formattedAddress ?? 'Selected Location',
                    lat: result.latitude,
                    lng: result.longitude,
                  );

                  // Refresh the UI
                  if (context.mounted) {
                    showToast(message: 'Location updated');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    title,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 4.h),
                  customText(
                    subtitle,
                    fontSize: 12.sp,
                    color: AppColors.obscureTextColor,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.obscureTextColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestCurrentLocation(BuildContext context) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (context.mounted) {
          showToast(
            isError: true,
            message: 'Please enable location services',
          );
        }
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            showToast(
              isError: true,
              message: 'Location permission denied',
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          showToast(
            isError: true,
            message: 'Please enable location permission in settings',
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Secret.apiKey}';

      final res = await Dio().get(url);
      final decodedData = json.decode(json.encode(res.data));

      if (res.statusCode == 200 && decodedData['results'] != null) {
        final address = decodedData['results'][0]['formatted_address'];

        final locationController = Get.find<LocationController>();
        await locationController.updateLocation(
          address,
          lat: position.latitude,
          lng: position.longitude,
        );

        if (context.mounted) {
          showToast(message: 'Location updated');
        }
      }
    } catch (e) {
      debugPrint('Error getting current location: $e');
      if (context.mounted) {
        showToast(
          isError: true,
          message: 'Failed to get current location',
        );
      }
    }
  }
}