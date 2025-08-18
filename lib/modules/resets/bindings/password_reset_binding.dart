import 'package:gosharpsharp/core/utils/exports.dart';


class PasswordResetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordResetController>(
          () => PasswordResetController(),
    );
  }
}
