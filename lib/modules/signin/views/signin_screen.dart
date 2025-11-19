import 'package:gosharpsharp/core/utils/exports.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      builder: (signInController) {
        return Form(
          key: signInController.signInFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              implyLeading: !NavigationHelper.isCurrentRouteLastInStack(),
              title: "",
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.sp,
                        vertical: 0.sp,
                      ),
                      margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                      width: 1.sw,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            "Login",
                            color: AppColors.blackColor,
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 5.sp),
                          customText(
                            "Welcome back",
                            color: AppColors.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,
                          ),
                          SizedBox(height: 25.sp),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.sp,
                        vertical: 10.sp,
                      ),
                      margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomRoundedInputField(
                            title: "Email",
                            label: "meterme@gmail.com",
                            showLabel: true,
                            isRequired: true,
                            useCustomValidator: true,
                            hasTitle: true,
                            keyboardType: TextInputType.emailAddress,
                            controller: signInController.loginController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an email';
                              } else if (!validateEmail(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.sp),
                          CustomRoundedInputField(
                            title: "Password",
                            label: "Enter your password",
                            showLabel: true,
                            isRequired: true,
                            useCustomValidator: true,
                            obscureText:
                                !signInController.signInPasswordVisibility,
                            hasTitle: true,
                            controller: signInController.passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            suffixWidget: IconButton(
                              onPressed: () {
                                signInController.togglePasswordVisibility();
                              },
                              icon: Icon(
                                !signInController.signInPasswordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                  Routes.RESET_PASSWORD_EMAIL_ENTRY_SCREEN,
                                );
                              },
                              child: customText(
                                "Forgot your password?",
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          CustomButton(
                            onPressed: () {
                              signInController.signIn();
                              // Get.to(AppNavigationScreen());
                            },
                            isBusy: signInController.isLoading,
                            title: "Log in",
                            width: 1.sw,
                            backgroundColor: AppColors.primaryColor,
                            fontColor: AppColors.whiteColor,
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customText(
                                "Don't have an account?",
                                color: AppColors.obscureTextColor,
                                fontSize: 15.sp,
                              ),
                              SizedBox(width: 12.w),
                              InkWell(
                                onTap: () {
                                  Get.offAndToNamed(Routes.SIGNUP_SCREEN);
                                },
                                child: customText(
                                  "Create an account",
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
