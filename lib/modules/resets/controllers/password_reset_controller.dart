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

  togglePasswordVisibility() {
    passwordVisibility = !passwordVisibility;
    update();
  }

  bool confirmPasswordVisibility = false;

  toggleConfirmPasswordVisibility() {
    confirmPasswordVisibility = !confirmPasswordVisibility;
    update();
  }

  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  sendPasswordResetOTP() async {
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
  setIsResendingOTPState(bool val) {
    isResendingOtp = val;
    update();
  }

  resendPasswordResetOTP() async {
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

  validDateOtpField() {
    if (restPasswordOtpFormKey.currentState!.validate()) {
      Get.toNamed(Routes.RESET_PASSWORD_NEW_PASSWORD_SCREEN);
    }
  }

  bool useEmail = true;

  toggleSignInWithEmail() {
    useEmail = !useEmail;
    loginController.clear();
    update();
  }

  TextEditingController loginController = TextEditingController();
  PhoneNumber? filledPhoneNumber;
  setPhoneNumber(PhoneNumber num) {
    loginController.text = filledPhoneNumber!.completeNumber;
    update();
  }

  resetPassword() async {
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
