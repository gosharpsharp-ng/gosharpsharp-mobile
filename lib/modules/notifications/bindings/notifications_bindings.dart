import 'package:gosharpsharp/core/utils/exports.dart';

class NotificationsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
      fenix: true, // Recreates controller when page is revisited
    );
  }
}
