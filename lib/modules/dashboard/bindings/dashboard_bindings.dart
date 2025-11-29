import 'package:gosharpsharp/core/utils/exports.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<DashboardController>()) {
      Get.put<DashboardController>(DashboardController(), permanent: true);
    }
  }
}
