import 'package:gosharpsharp/core/utils/exports.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

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
                    // Hero Image Section
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.sp,
                        vertical: 10.sp,
                      ),
                      child: Column(
                        children: [
                          // Circular Hero Image with Rotation
                          RotationTransition(
                            turns: _rotationController,
                            child: Container(
                              height: 180.sp,
                              width: 180.sp,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.2,
                                  ),
                                  width: 3,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90.r),
                                child: Image.asset(
                                  'assets/imgs/login_hero.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.sp),
                        ],
                      ),
                    ),

                    // Login Form Section
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
                          if (signInController.loginErrorMessage != null)
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.sp),
                              margin: EdgeInsets.only(bottom: 15.h),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: customText(
                                      signInController.loginErrorMessage!,
                                      color: Colors.red,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
