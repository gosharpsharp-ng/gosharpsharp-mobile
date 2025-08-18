import 'dart:math';

import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(builder: (signInController) {
      return Form(
        key: signInController.signInFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
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
                        horizontal: 10.sp, vertical: 0.sp),
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText("Login",
                            color: AppColors.blackColor,
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w600),
                        SizedBox(
                          height: 5.sp,
                        ),
                        customText(
                            "Welcome back",
                            color: AppColors.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal),
                        SizedBox(
                          height: 5.sp,
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        SizedBox(
                          width: 1.sw,
                          child: Row(
                            children: [
                              Expanded(
                                child: LoginTypeSelector(
                                  title: "Login with Email",
                                  onSelected: () {
                                    if (!signInController.signInWithEmail) {
                                      signInController.toggleSignInWithEmail();
                                    }
                                  },
                                  isSelected: signInController.signInWithEmail,
                                ),
                              ),
                              Expanded(
                                child: LoginTypeSelector(
                                  title: "Login with Phone",
                                  onSelected: () {
                                    if (signInController.signInWithEmail) {
                                      signInController.toggleSignInWithEmail();
                                    }
                                  },
                                  isSelected: !signInController.signInWithEmail,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25.sp,
                        ),
                      ],
                    ),

                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 10.sp),
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: 5.sp,
                        // ),
                        // customText(
                        //   "Welcome back to the app",
                        //   color: AppColors.obscureTextColor,
                        //   fontWeight: FontWeight.w500,
                        //   fontSize: 16.sp,
                        // ),

                        signInController.signInWithEmail
                            ? CustomRoundedInputField(
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
                              )
                            : CustomRoundedPhoneInputField(
                                title: "Phone number",
                                label: "7061032122",
                                onChanged: (PhoneNumber phone) {
                                  if (phone.number.isNotEmpty &&
                                      phone.number.startsWith('0')) {
                                    final updatedNumber = phone.number
                                        .replaceFirst(RegExp(r'^0'), '');
                                    signInController.loginController.value =
                                        TextEditingValue(
                                      text: updatedNumber,
                                      selection: TextSelection.collapsed(
                                          offset: updatedNumber.length),
                                    );
                                    signInController.setPhoneNumber(PhoneNumber(
                                      countryISOCode: phone.countryISOCode,
                                      countryCode: phone.countryCode,
                                      number: updatedNumber,
                                    ));
                                    signInController
                                        .setFilledPhoneNumber(PhoneNumber(
                                      countryISOCode: phone.countryISOCode,
                                      countryCode: phone.countryCode,
                                      number: updatedNumber,
                                    ));
                                  } else {
                                    signInController
                                        .setFilledPhoneNumber(phone);
                                  }
                                },
                                keyboardType: TextInputType.phone,
                                validator: (phone) {
                                  if (phone == null ||
                                      phone.completeNumber.isEmpty) {
                                    return "Phone number is required";
                                  }
                                  // Regex: `+` followed by 1 to 3 digits (country code), then 10 digits (phone number)
                                  final regex = RegExp(r'^\+234[1-9]\d{9}$');
                                  if (!regex.hasMatch(phone.completeNumber)) {
                                    return "Phone number must be 10 digits long";
                                  }

                                  return null; // Valid phone number
                                },
                                isPhone: true,
                                hasTitle: true,
                                controller: signInController.loginController,
                              ),
                        SizedBox(
                          height: 10.sp,
                        ),
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
                        SizedBox(
                          height: 10.h,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                  Routes.RESET_PASSWORD_EMAIL_ENTRY_SCREEN);
                            },
                            child: customText("Forgot your password?",
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            signInController.signIn();
                          },
                          isBusy: signInController.isLoading,
                          title: "Log in",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText("Don't have an account?",
                                color: AppColors.obscureTextColor,
                                fontSize: 15.sp),
                            SizedBox(
                              width: 12.w,
                            ),
                            InkWell(
                              onTap: () {
                                Get.offAndToNamed(Routes.SIGNUP_SCREEN);
                              },
                              child: customText("Create an account",
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp),
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
    });
  }
}

class LoginTypeSelector extends StatelessWidget {
  final String title;
  final Function onSelected;
  final bool isSelected;
  const LoginTypeSelector(
      {super.key,
      required this.title,
      this.isSelected = false,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.transparent,
      onTap: () {
        onSelected();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.sp),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.obscureTextColor,
                width: isSelected ? 2.sp : 1.sp),
          ),
        ),
        width: double.infinity,
        child: Center(
          child: customText(title,
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.obscureTextColor),
        ),
      ),
    );
  }
}
