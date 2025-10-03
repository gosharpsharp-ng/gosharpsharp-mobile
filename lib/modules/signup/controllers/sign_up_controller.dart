import 'dart:async';

import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignUpController extends GetxController {
  late Timer _otpResendTimer;
  int resendOTPAfter = 120;
  String remainingTime = "";

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

  final authService = serviceLocator<AuthenticationService>();
  final signUpFormKey = GlobalKey<FormState>();
  final signOTPFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  setLoadingState(bool val) {
    isLoading = val;
    update();
  }

  bool isResendingOtp = false;
  setIsResendingOTPState(bool val) {
    isResendingOtp = val;
    update();
  }

  bool signUpPasswordVisibility = false;

  togglePasswordVisibility() {
    signUpPasswordVisibility = !signUpPasswordVisibility;
    update();
  }

  bool signUpConfirmPasswordVisibility = false;

  toggleConfirmPasswordVisibility() {
    signUpConfirmPasswordVisibility = !signUpConfirmPasswordVisibility;
    update();
  }

  TextEditingController otpController = TextEditingController();
  verifyOtp() async {
    if (signOTPFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'otp': otpController.text,
        'email': emailController.text,
        // 'phone': filledPhoneNumber?.completeNumber??"",
      };
      APIResponse response = await authService.verifyEmailOtp(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {
        Get.offAllNamed(Routes.SIGN_IN);
      }
    }
  }

  sendOtp() async {
    setIsResendingOTPState(true);
    dynamic data = {
      'login': emailController.text,
    };
    APIResponse response = await authService.sendOtp(data);
    showToast(message: response.message, isError: response.status != "success");
    setIsResendingOTPState(false);
    if (response.status == "success") {
      _startOtpResendTimer();
    }
  }

  setPhoneNumber(val) {
    phoneNumberController.text = val;
    update();
  }

  PhoneNumber? filledPhoneNumber;
  setFilledPhoneNumber(PhoneNumber num) {
    filledPhoneNumber = num;
    update();
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  signUp() async {
    if (signUpFormKey.currentState!.validate() &&
        phoneNumberController.text.isNotEmpty) {
      setLoadingState(true);
      dynamic data = {
        'fname': firstNameController.text,
        'lname': lastNameController.text,
        'email': emailController.text,
        'phone': filledPhoneNumber?.completeNumber ?? '',
        'password': passwordController.text,
      };
      APIResponse response = await authService.signup(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {
        _startOtpResendTimer();
        Get.offAndToNamed(Routes.SIGNUP_OTP_SCREEN);
      }
    }
  }
}
