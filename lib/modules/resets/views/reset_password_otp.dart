import 'package:gosharpsharp/core/utils/exports.dart';

class ResetPasswordOtpScreen extends StatelessWidget {
  ResetPasswordOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordResetController>(
        builder: (passwordResetController) {
      return Form(
        key: passwordResetController.restPasswordOtpFormKey,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
              title: "Verify OTP", bgColor: AppColors.backgroundColor),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 20.sp),
              child: TitleSectionBox(
                title:
                    "Enter your OTP which has been sent to ${passwordResetController.useEmail} and verify your account",
                backgroundColor: AppColors.whiteColor,
                children: [
                  SizedBox(
                    height: 25.sp,
                  ),
                  CustomPinInput(
                    maxLength: 4,
                    controller: passwordResetController.otpController,
                    onDone: (value) {
                      passwordResetController.validDateOtpField();
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "OTP is required";
                      } else if (val.length < 4) {
                        return "OTP is not complete";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 30.sp,
                  ),

                  InkWell(
                    onTap: () {
                      (passwordResetController.isResendingOtp ||
                          passwordResetController.resendOTPAfter > 1)
                          ? null
                          : passwordResetController.resendPasswordResetOTP();
                    },
                    child: customText(
                      passwordResetController.isResendingOtp
                          ? 'Loading...'
                          : (passwordResetController.resendOTPAfter > 1)
                          ? "Resend OTP in ${passwordResetController.remainingTime}"
                          : "Resend OTP",
                      color: AppColors.primaryColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 50.sp,
                  ),
                  CustomButton(
                    onPressed: () {
                      passwordResetController.validDateOtpField();
                    },
                    backgroundColor: AppColors.primaryColor,
                    title: "Continue",
                    fontColor: AppColors.whiteColor,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 30.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
