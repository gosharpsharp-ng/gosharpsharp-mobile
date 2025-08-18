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

    if (token != null && token.isNotEmpty) {
      // Load data and navigate after the current frame
      await _loadData();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(Routes.APP_NAVIGATION);
      });
    } else {
      // Navigate to onboarding after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(Routes.ONBOARDING);
      });
    }
  }

  // Method to initiate calls from the WalletController and ProfileController
  Future<void> _loadData() async {
    Get.put(WalletController());
    Get.put(SettingsController());
    Get.put(DeliveriesController());
  }
}
