import 'package:gosharpsharp/core/utils/exports.dart';

class SignUpBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}