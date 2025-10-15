import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';
import 'package:gosharpsharp/modules/orders/controllers/orders_controller.dart';

class AppNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize SettingsController first as other controllers depend on it
    Get.put(SettingsController());

    Get.put(AppNavigationController());
    Get.put(DashboardController());
    Get.put(DeliveriesController());
    Get.put(WalletController());
    Get.put(NotificationsController());
    Get.put(CartController());
    Get.put(OrdersController());
  }
}
