import 'package:gosharpsharp/core/utils/exports.dart';

class SignInController extends GetxController {
  final authService = serviceLocator<AuthenticationService>();
  final signInFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  bool signInPasswordVisibility = false;

  togglePasswordVisibility() {
    signInPasswordVisibility = !signInPasswordVisibility;
    update();
  }

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  signIn() async {
    if (signInFormKey.currentState!.validate()) {
      setLoadingState(true);
      try {
        dynamic data = {
          'login': loginController.text,
          'password': passwordController.text,
        };
        APIResponse response = await authService.login(data);

        if (response.status.toLowerCase() == "success") {
          loginController.clear();
          passwordController.clear();
          update();
          final getStorage = GetStorage();
          getStorage.write("token", response.data['auth_token']);
          Get.put(WalletController());
          Get.put(SettingsController());
          Get.put(DeliveriesController());

          // Check if location is set up
          final hasLocationSetup = await _checkLocationSetup();
          if (hasLocationSetup) {
            Get.toNamed(Routes.APP_NAVIGATION);
          } else {
            Get.toNamed(Routes.LOCATION_PERMISSION_SCREEN);
          }
        }
      } catch (e) {
        print("Error during sign in: $e");
        showToast(
            message: "An unexpected error occurred. Please try again.",
            isError: true);
      } finally {
        // Always reset loading state, even if an error occurs
        setLoadingState(false);
      }
    }
  }

  Future<bool> _checkLocationSetup() async {
    final box = GetStorage();

    // Check if user has already set up location
    final savedLocation = box.read('selected_location');

    // If location is saved, return true
    if (savedLocation != null && savedLocation.isNotEmpty) {
      return true;
    }

    // Check if location services are enabled and permission granted
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error checking location: $e');
    }

    return false;
  }
}

