import 'package:gosharpsharp/core/utils/exports.dart';

class SignUpOtpScreen extends StatelessWidget {
  SignUpOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(builder: (signUpController) {
      return Form(
        key: signUpController.signOTPFormKey,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
              title: "Verify your email", bgColor: AppColors.backgroundColor),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 20.sp),
              child: TitleSectionBox(
                title: "",
                backgroundColor: AppColors.whiteColor,
                children: [
                  Container(
                    width: 1.sw,
                    child: Row(
                      children: [
                        customText(
                            "Enter the 4 digit OTP code sent to\n${signUpController.emailController.text} ",
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: AppColors.blackColor,
                            overflow: TextOverflow.visible),
                        // customText(
                        //     signUpController.filledPhoneNumber?.completeNumber ??
                        //         "",
                        //     fontWeight: FontWeight.w600,
                        //     fontSize: 16.sp,
                        //     color: AppColors.primaryColor,
                        //     overflow: TextOverflow.visible),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.sp,
                  ),
                  CustomPinInput(
                    maxLength: 4,
                    controller: signUpController.otpController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "OTP is required";
                      } else if (val.length < 4) {
                        return "OTP is not complete";
                      } else {
                        return null;
                      }
                    },
                    onDone: (val){
                      signUpController.verifyOtp();
                    },
                  ),
                  SizedBox(
                    height: 30.sp,
                  ),
                  InkWell(
                    onTap: () {
                      (signUpController.isResendingOtp ||
                              signUpController.resendOTPAfter > 1)
                          ? null
                          : signUpController.sendOtp();
                    },
                    child: customText(
                      signUpController.isResendingOtp
                          ? 'Loading...'
                          : (signUpController.resendOTPAfter > 1)
                              ? "Resend OTP in ${signUpController.remainingTime}"
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
                      signUpController.verifyOtp();
                    },
                    isBusy: signUpController.isLoading,
                    backgroundColor: AppColors.primaryColor,
                    title: "Verify",
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
