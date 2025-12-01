import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (settingsController) {
        WebViewController webViewController = createWebViewController(
          successCallback: () {
            Get.back();
          },
        );
        return Scaffold(
          appBar: defaultAppBar(
            implyLeading: false,
            bgColor: AppColors.backgroundColor,
            title: "Settings",
            centerTitle: false,
          ),
          body: Container(
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SectionBox(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    backgroundColor: AppColors.whiteColor,
                    children: [
                      // Avatar display priority: local file > network URL > initials
                      Builder(
                        builder: (context) {
                          // 1. Show locally picked image first
                          if (settingsController.userProfilePicture != null) {
                            return CircleAvatar(
                              backgroundImage: FileImage(
                                settingsController.userProfilePicture!,
                              ),
                              radius: 55.r,
                            );
                          }
                          // 2. Show network avatar if available
                          if (settingsController.userProfile?.avatarUrl != null &&
                              settingsController.userProfile!.avatarUrl!.isNotEmpty) {
                            return CircleAvatar(
                              backgroundImage: NetworkImage(
                                settingsController.userProfile!.avatarUrl!,
                              ),
                              radius: 55.r,
                            );
                          }
                          // 3. Show initials as fallback
                          return CircleAvatar(
                            radius: 55.r,
                            backgroundColor: AppColors.backgroundColor,
                            child: customText(
                              "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                              fontSize: 24.sp,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 5.h),
                      customText(
                        "${settingsController.userProfile?.fname ?? ""} ${settingsController.userProfile?.lname ?? ""}",
                        color: AppColors.blackColor,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(height: 5.h),
                      customText(
                        settingsController.userProfile?.email ?? "",
                        color: AppColors.obscureTextColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  SectionBox(
                    children: [
                      SettingsItem(
                        onPressed: () {
                          settingsController.setProfileFields();
                          settingsController.toggleProfileEditState(false);
                          Get.toNamed(Routes.EDIT_PROFILE_SCREEN);
                        },
                        title: "Edit Profile",
                        icon: SvgAssets.profileIcon,
                      ),
                      SettingsItem(
                        onPressed: () {
                          // Get or create NotificationsController and fetch notifications
                          final notificationsController = Get.put(NotificationsController());
                          notificationsController.getNotifications();
                          Get.toNamed(Routes.NOTIFICATIONS_HOME);
                        },
                        title: "Notifications",
                        icon: SvgAssets.notificationIcon,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.CHANGE_PASSWORD_SCREEN);
                        },
                        title: "Change Password",
                        icon: SvgAssets.passwordChangeIcon,
                      ),

                      // SettingsItem(
                      //   onPressed: () {},
                      //   title: "Disputes",
                      //   icon: SvgAssets.supportIcon,
                      // ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.WALLETS_HOME_SCREEN);
                        },
                        title: "GoWallet",
                        icon: SvgAssets.walletIcon,
                      ),
                      SettingsItem(
                        onPressed: () {
                          Get.toNamed(Routes.FAQS_SCREEN);
                        },
                        title: "FAQS",
                        icon: SvgAssets.faqsIcon,
                      ),

                      SettingsItem(
                        onPressed: () {
                          showWebViewDialog(
                            context,
                            controller: webViewController,
                            onDialogClosed: () {
                              Get.back();
                            },
                            title: "Help and Support",
                            url: "https://gosharpsharp.com/contact",
                          );
                        },
                        title: "Help and Support",
                        icon: SvgAssets.supportIcon,
                      ),

                      SettingsItem(
                        onPressed: () {
                          showWebViewDialog(
                            context,
                            controller: webViewController,
                            onDialogClosed: () {
                              Get.back();
                            },
                            title: "Privacy Policy",
                            url: "https://gosharpsharp.com/privacy",
                          );
                        },
                        title: "Privacy Policy",
                        icon: SvgAssets.profileIcon,
                      ),
                      // SettingsItem(
                      //   onPressed: () {},
                      //   title: "Language",
                      //   icon: SvgAssets.languageIcon,
                      // ),
                      // SettingsItem(
                      //   onPressed: () {},
                      //   title: "Security",
                      //   icon: SvgAssets.securityIcon,
                      // ),
                        SettingsItem(
                        onPressed: () {
                          settingsController.logout();
                        },
                        title: "Log out",
                        icon: SvgAssets.logoutIcon,
                        // isLogout: true,
                        isLast: true,
                      ),
                      SettingsItem(
                        onPressed: () {
                          settingsController.deletePasswordController.clear();
                          settingsController.showAccountDeletionDialog();
                        },
                        title: "Delete Account",
                        icon: SvgAssets.deleteIcon,
                        // isLogout: true,
                        // isLast: true,
                      ),
                    
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
