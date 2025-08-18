import 'package:gosharpsharp/core/utils/exports.dart';


class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
          () => SettingsController(),
    );
  }
}
