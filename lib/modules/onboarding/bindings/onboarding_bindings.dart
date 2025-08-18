import 'package:gosharpsharp/core/utils/exports.dart';


class OnboardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
          () => OnboardingController(),
    );
  }
}
