import 'package:gosharpsharp/core/utils/exports.dart';


class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Form(
        key: settingsController.changePasswordFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Change Password",
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
                        horizontal: 10.sp, vertical: 20.sp),
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomRoundedInputField(
                          title: "Current Password",
                          label: "Enter your current password",
                          useCustomValidator: true,
                          showLabel: true,
                          obscureText: !settingsController.oldPasswordVisibility,
                          hasTitle: true,
                          controller: settingsController.oldPasswordController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              settingsController.toggleOldPasswordVisibility();
                            },
                            icon: Icon(
                              !settingsController.oldPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                        ),
                        CustomRoundedInputField(
                          title: "New Password",
                          hasTitle: true,
                          label: "Enter the new password",
                          showLabel: true,
                          controller: settingsController.newPasswordController,
                          useCustomValidator: true,
                          obscureText: !settingsController.newPasswordVisibility,
                          suffixWidget: IconButton(
                            onPressed: () {
                              settingsController.toggleNewPasswordVisibility();
                            },
                            icon: Icon(
                              !settingsController.newPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                        ),
                        CustomRoundedInputField(
                          title: "Confirm Password",
                          label: "Confirm new password",
                          showLabel: true,
                          hasTitle: true,
                          useCustomValidator: true,
                          obscureText:
                          !settingsController.confirmNewPasswordVisibility,
                          controller: settingsController.confirmNewPasswordController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              settingsController
                                  .toggleConfirmNewPasswordVisibility();
                            },
                            icon: Icon(
                              !settingsController.confirmNewPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password cannot be empty';
                            }
                            if (value !=
                                settingsController.newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            settingsController.changePassword();
                          },
                          isBusy: settingsController.isLoading,
                          title: "Save",
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
