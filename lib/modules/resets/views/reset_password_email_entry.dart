import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class ResetPasswordEmailEntry extends StatelessWidget {
  const ResetPasswordEmailEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordResetController>(
        builder: (passwordResetController) {
      return Form(
        key: passwordResetController.resetPasswordRequestFormKey,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
              title: "Reset password", bgColor: AppColors.backgroundColor),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 20.sp),
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
                        SizedBox(
                          height: 5.sp,
                        ),
                        InkWell(
                          onTap: () {
                            passwordResetController.toggleSignInWithEmail();
                          },
                          child: customText(
                            "Use ${passwordResetController.useEmail ? 'Phone' : 'Email'} instead",
                            fontSize: 14.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 15.sp,
                        ),
                        passwordResetController.useEmail
                            ? CustomRoundedInputField(
                                title: "Email",
                                label: "meterme@gmail.com",
                                showLabel: true,
                                isRequired: true,
                                isPhone: passwordResetController.useEmail
                                    ? false
                                    : true,
                                useCustomValidator: true,
                                hasTitle: true,
                                keyboardType: TextInputType.emailAddress,
                                controller:
                                    passwordResetController.loginController,
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
                                  // Remove all spaces and leading zero
                                  String cleanedNumber = phone.number.replaceAll(' ', '');

                                  if (cleanedNumber.isNotEmpty && cleanedNumber.startsWith('0')) {
                                    cleanedNumber = cleanedNumber.replaceFirst(RegExp(r'^0'), '');
                                  }

                                  if (cleanedNumber != phone.number) {
                                    passwordResetController.loginController.value =
                                        TextEditingValue(
                                          text: cleanedNumber,
                                          selection: TextSelection.collapsed(
                                            offset: cleanedNumber.length,
                                          ),
                                        );
                                    PhoneNumber num = PhoneNumber(
                                        countryISOCode: phone.countryISOCode,
                                        countryCode: phone.countryCode,
                                        number: cleanedNumber);
                                    passwordResetController.setPhoneNumber(num);
                                  } else {
                                    passwordResetController.setPhoneNumber(phone);
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
                                    return "Phone number must start with +234 and be 10 digits long";
                                  }

                                  return null; // Valid phone number
                                },
                                isPhone: true,
                                hasTitle: true,
                                controller:
                                    passwordResetController.loginController,
                              ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            // passwordResetController.sendPasswordResetOTP();
                            Get.toNamed(Routes.RESET_PASSWORD_OTP_SCREEN);
                          },
                          isBusy: passwordResetController.isLoading,
                          title: "Send OTP",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),
                        SizedBox(
                          height: 15.h,
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
