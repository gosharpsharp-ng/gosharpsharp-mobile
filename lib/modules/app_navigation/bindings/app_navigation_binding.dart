import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';

class AppNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppNavigationController());
    Get.put(DashboardController());
    Get.put(DeliveriesController());
    Get.put(WalletController());
    Get.put(SettingsController());
    Get.put(NotificationsController());
    Get.put(CartController());
  }
}
