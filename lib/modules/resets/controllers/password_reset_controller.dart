import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class PasswordResetController extends GetxController {
  late Timer _otpResendTimer;
  int resendOTPAfter = 120;
  String remainingTime = "";
  final authService = serviceLocator<AuthenticationService>();
  final resetPasswordRequestFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();
  final restPasswordOtpFormKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _startOtpResendTimer() {
    resendOTPAfter = 120;
    const oneSec = Duration(seconds: 1);
    _otpResendTimer = Timer.periodic(oneSec, (Timer timer) {
      update();
      if (resendOTPAfter > 0) {
        resendOTPAfter--;
        remainingTime = getFormattedResendOTPTime(resendOTPAfter);
        update();
      } else {
        update();
        _otpResendTimer.cancel();
        update();
      }
    });
  }

  bool passwordVisibility = false;

  void togglePasswordVisibility() {
    passwordVisibility = !passwordVisibility;
    update();
  }

  bool confirmPasswordVisibility = false;

  void toggleConfirmPasswordVisibility() {
    confirmPasswordVisibility = !confirmPasswordVisibility;
    update();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  Future<void> sendPasswordResetOTP() async {
    if (resetPasswordRequestFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'identifier': loginController.text,
      };
      APIResponse response = await authService.sendOtp(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {
        _startOtpResendTimer();
        Get.toNamed(Routes.RESET_PASSWORD_OTP_SCREEN);
      }
    }
  }

  bool isResendingOtp = false;
  void setIsResendingOTPState(bool val) {
    isResendingOtp = val;
    update();
  }

  Future<void> resendPasswordResetOTP() async {
    setIsResendingOTPState(true);
    dynamic data = {
      'identifier': loginController.text,
    };
    APIResponse response = await authService.sendOtp(data);
    showToast(message: response.message, isError: response.status != "success");
    setIsResendingOTPState(false);
    if (response.status == "success") {
      _startOtpResendTimer();
    }
  }

  void validDateOtpField() {
    if (restPasswordOtpFormKey.currentState!.validate()) {
      Get.toNamed(Routes.RESET_PASSWORD_NEW_PASSWORD_SCREEN);
    }
  }

  bool useEmail = true;

  void toggleSignInWithEmail() {
    useEmail = !useEmail;
    loginController.clear();
    update();
  }

  TextEditingController loginController = TextEditingController();
  PhoneNumber? filledPhoneNumber;
  void setPhoneNumber(PhoneNumber num) {
    loginController.text = filledPhoneNumber!.completeNumber;
    update();
  }

  Future<void> resetPassword() async {
    if (resetPasswordFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'otp': otpController.text,
        'identifier': loginController.text,
        'password': newPasswordController.text,
      };
      APIResponse response = await authService.resetPassword(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {
        otpController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        loginController.clear();
        Get.offAllNamed(Routes.SIGN_IN);
      }
    }
  }
}
