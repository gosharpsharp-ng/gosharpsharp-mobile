import 'package:gosharpsharp/core/utils/exports.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkToken();
  }

  void _checkToken() async {
    // Get token from storage
    final box = GetStorage();
    String? token = box.read('token');

    debugPrint('🔑 Token check: ${token != null ? 'Token exists' : 'No token'}');

    if (token != null && token.isNotEmpty) {
      // Load data
      await _loadData();

      // Check if location permission has been handled
      final hasLocationSetup = await _checkLocationSetup();

      debugPrint('📍 Location setup check: $hasLocationSetup');

      // Navigate after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (hasLocationSetup) {
          debugPrint('🚀 Navigating to APP_NAVIGATION');
          Get.offNamed(Routes.APP_NAVIGATION);
        } else {
          debugPrint('🚀 Navigating to LOCATION_PERMISSION_SCREEN');
          Get.offNamed(Routes.LOCATION_PERMISSION_SCREEN);
        }
      });
    } else {
      // Navigate to onboarding after the current frame
      debugPrint('🚀 Navigating to ONBOARDING');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(Routes.ONBOARDING);
      });
    }
  }

  Future<bool> _checkLocationSetup() async {
    final box = GetStorage();

    // Check if user has already set up location (either via permission or manual selection)
    final savedLocation = box.read('selected_location');

    debugPrint('📍 Saved location: $savedLocation');

    // If location is saved, return true
    if (savedLocation != null && savedLocation.isNotEmpty) {
      debugPrint('✅ Location already saved');
      return true;
    }

    // Check if location services are enabled and permission granted
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      debugPrint('📍 Location service enabled: $serviceEnabled');

      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        debugPrint('📍 Location permission: $permission');

        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          debugPrint('✅ Location permission granted');
          return true;
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking location: $e');
    }

    debugPrint('❌ No location setup found');
    return false;
  }

  // Method to initiate calls from the WalletController and ProfileController
  Future<void> _loadData() async {
    Get.put(WalletController());
    Get.put(SettingsController());
    Get.put(DeliveriesController());
  }
}
