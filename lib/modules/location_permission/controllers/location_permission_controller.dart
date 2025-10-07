import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gosharpsharp/core/controllers/location_controller.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class LocationPermissionController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString selectedLocation = ''.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);

  @override
  void onInit() {
    super.onInit();
    // Initialize LocationController
    Get.put(LocationController());
    checkLocationStatus();
  }

  Future<void> checkLocationStatus() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      debugPrint('📍 Location service enabled: $serviceEnabled');
      debugPrint('📍 Location permission: $permission');

      if (serviceEnabled &&
          (permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse)) {
        // Location is already enabled, get current location automatically
        debugPrint('✅ Location already enabled - Getting current location...');
        await getCurrentLocation();
        // Navigate after getting location
        Future.delayed(const Duration(milliseconds: 500), () {
          navigateToNextScreen();
        });
      } else {
        debugPrint('❌ Location not enabled - Showing permission screen');
      }
    } catch (e) {
      debugPrint('❌ Error checking location status: $e');
    }
  }

  Future<void> requestLocationPermission() async {
    try {
      isLoading.value = true;

      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        // Show dialog to enable location service
        Get.dialog(
          AlertDialog(
            title: customText(
              'Location Service Disabled',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            content: customText(
              'Please enable location services in your device settings.',
              fontSize: 14.sp,
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: customText(
                  'Cancel',
                  fontSize: 14.sp,
                  color: AppColors.obscureTextColor,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await Geolocator.openLocationSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: customText(
                  'Open Settings',
                  fontSize: 14.sp,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        );
        isLoading.value = false;
        return;
      }

      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // Permission granted, get location
        await getCurrentLocation();
        navigateToNextScreen();
      } else if (permission == LocationPermission.deniedForever) {
        // Show dialog to open app settings
        Get.dialog(
          AlertDialog(
            title: customText(
              'Location Permission Required',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            content: customText(
              'Location permission is permanently denied. Please enable it in app settings.',
              fontSize: 14.sp,
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: customText(
                  'Cancel',
                  fontSize: 14.sp,
                  color: AppColors.obscureTextColor,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await openAppSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: customText(
                  'Open Settings',
                  fontSize: 14.sp,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        );
      } else {
        showToast(message: 'Location permission denied');
      }
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
      showToast(message:'Failed to get location permission');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;

      showToast(message: 'Getting your location...');

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = position;

      debugPrint('📍 Got GPS coordinates: ${position.latitude}, ${position.longitude}');

      // Get address from coordinates using reverse geocoding
      String address = 'Current Location';
      try {
        final url =
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Secret.apiKey}';

        final res = await Dio().get(url);
        final decodedData = json.decode(json.encode(res.data));

        if (res.statusCode == 200 &&
            decodedData['results'] != null &&
            decodedData['results'].isNotEmpty) {
          address = decodedData['results'][0]['formatted_address'];
          debugPrint('📍 Geocoded address: $address');
        }
      } catch (e) {
        debugPrint('Error geocoding location: $e');
        // Continue with 'Current Location' if geocoding fails
      }

      selectedLocation.value = address;

      // Save to local storage using LocationController
      final locationController = Get.find<LocationController>();
      await locationController.updateLocation(
        address,
        lat: position.latitude,
        lng: position.longitude,
      );

      debugPrint('📍 Location saved: $address');
      showToast(message: 'Location updated successfully');
    } catch (e) {
      debugPrint('❌ Error getting current location: $e');
      showToast(message:'Failed to get current location',isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void selectLocationManually() {
    // Navigate to location selection screen
    Get.toNamed(Routes.SELECT_LOCATION_SCREEN);
  }

  void skipForNow() {
    // Set a default location or allow app to continue without location
    selectedLocation.value = 'Location not set';
    navigateToNextScreen();
  }

  void navigateToNextScreen() {
    // Navigate to app navigation screen
    Get.offAllNamed(Routes.APP_NAVIGATION);
  }
}