import 'package:gosharpsharp/core/utils/exports.dart';

class AppNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AppNavigationController(),
    );
    Get.put(
      DashboardController(),
    );
    Get.put(
      DeliveriesController(),
    );
    Get.put(
      WalletController(),
    );
    Get.put(
      SettingsController(),
    );
    Get.put(
      NotificationsController(),
    );
  }
}
