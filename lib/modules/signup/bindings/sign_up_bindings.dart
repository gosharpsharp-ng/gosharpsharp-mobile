import 'package:gosharpsharp/core/utils/exports.dart';

class SignUpBindings implements Bindings {
  @override
  void dependencies() {
    // Use Get.put instead of lazyPut to ensure controller stays alive
    // throughout the signup -> OTP verification flow
    Get.put<SignUpController>(SignUpController(), permanent: true);
  }
}