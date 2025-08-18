import 'package:gosharpsharp/core/utils/exports.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordResetController>(
        builder: (passwordResetController) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: defaultAppBar(
            title: "Reset password", bgColor: AppColors.backgroundColor),
        body: Form(
          key: passwordResetController.resetPasswordFormKey,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 20.sp),
              child: TitleSectionBox(
                backgroundColor: AppColors.whiteColor,
                title:
                    "Your new password must be different from the previous password!",
                children: [
                  SizedBox(
                    height: 25.sp,
                  ),
                  CustomRoundedInputField(
                    title: "Password",
                    label: "Create your 8-digit password",
                    showLabel: true,
                    isRequired: true,
                    useCustomValidator: true,
                    obscureText: passwordResetController.passwordVisibility,
                    hasTitle: true,
                    controller: passwordResetController.newPasswordController,
                    suffixWidget: IconButton(
                      onPressed: () {
                        passwordResetController.togglePasswordVisibility();
                      },
                      icon: Icon(
                        passwordResetController.passwordVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  CustomRoundedInputField(
                    title: "Confirm Password",
                    label: "Retype your 8-digit password",
                    showLabel: true,
                    isRequired: true,
                    useCustomValidator: true,
                    obscureText:
                        passwordResetController.confirmPasswordVisibility,
                    hasTitle: true,
                    controller:
                        passwordResetController.confirmPasswordController,
                    suffixWidget: IconButton(
                      onPressed: () {
                        passwordResetController
                            .toggleConfirmPasswordVisibility();
                      },
                      icon: Icon(
                        passwordResetController.confirmPasswordVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value !=
                          passwordResetController.newPasswordController.text) {
                        return 'Password mismatch';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 32.sp,
                  ),
                  CustomButton(
                    onPressed: () {
                      passwordResetController.resetPassword();
                    },
                    isBusy: passwordResetController.isLoading,
                    backgroundColor: AppColors.primaryColor,
                    title: "Reset Password",
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
