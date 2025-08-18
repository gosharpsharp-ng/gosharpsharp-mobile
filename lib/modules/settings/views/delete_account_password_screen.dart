import 'package:gosharpsharp/core/utils/exports.dart';

class DeleteAccountPasswordScreen extends StatelessWidget {
  const DeleteAccountPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Form(
        key: settingsController.deleteAccountFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Delete Account",
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
                          obscureText:
                              !settingsController.deletePasswordVisibility,
                          hasTitle: true,
                          controller:
                              settingsController.deletePasswordController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              settingsController
                                  .toggleDeletePasswordVisibility();
                            },
                            icon: Icon(
                              !settingsController.deletePasswordVisibility
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
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            settingsController.deleteAccount();
                          },
                          isBusy: settingsController.deletingAccount,
                          title: "Delete Account",
                          width: 1.sw,
                          backgroundColor: AppColors.redColor,
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
