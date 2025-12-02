import 'dart:developer';
import 'dart:io';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();
  factory AppUpdateService() => _instance;
  AppUpdateService._internal();

  bool _isDialogShowing = false;

  // Store IDs - Update these with your actual store IDs
  static const String _playStoreId = 'com.gosharpsharp.customer';
  static const String _appStoreId = 'com.gosharpsharp.customer';

  /// Initialize and check for updates
  Future<void> initialize() async {
    await checkForUpdate();
  }

  /// Check if there's a new version available from Play Store/App Store
  Future<void> checkForUpdate() async {
    try {
      final upgrader = Upgrader(
        storeController: UpgraderStoreController(
          onAndroid: () => UpgraderPlayStore(),
          oniOS: () => UpgraderAppStore(),
        ),
      );

      await upgrader.initialize();

      final currentVersion = upgrader.currentInstalledVersion ?? '';
      final storeVersion = upgrader.currentAppStoreVersion ?? '';

      log('Current app version: $currentVersion');
      log('Store version: $storeVersion');

      if (upgrader.belowMinAppVersion()) {
        // Force update required
        log('Force update required - below minimum version');
        _showUpdateDialog(
          currentVersion: currentVersion,
          latestVersion: storeVersion,
          isForceUpdate: true,
          message: 'This version is no longer supported. Please update to continue using the app.',
          releaseNotes: upgrader.releaseNotes,
        );
      } else if (upgrader.isUpdateAvailable()) {
        // Optional update available
        log('New version available: $storeVersion');
        _showUpdateDialog(
          currentVersion: currentVersion,
          latestVersion: storeVersion,
          isForceUpdate: false,
          message: 'A new version of GoSharpSharp is available with improvements and bug fixes.',
          releaseNotes: upgrader.releaseNotes,
        );
      } else {
        log('App is up to date');
      }
    } catch (e) {
      log('Error checking for updates: $e');
    }
  }

  /// Show the update dialog
  void _showUpdateDialog({
    required String currentVersion,
    required String latestVersion,
    required bool isForceUpdate,
    required String message,
    String? releaseNotes,
  }) {
    if (_isDialogShowing) return;
    _isDialogShowing = true;

    Get.dialog(
      PopScope(
        canPop: !isForceUpdate,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.sp),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Update icon with animation effect
                Container(
                  width: 100.sp,
                  height: 100.sp,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withValues(alpha: 0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 20.r,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.system_update_rounded,
                      size: 50.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Title
                customText(
                  'Update Available',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 8.h),

                // Version info
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: customText(
                    'v$currentVersion → v$latestVersion',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(height: 16.h),

                // Message
                customText(
                  message,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyColor,
                  textAlign: TextAlign.center,
                ),

                // Release notes if available
                if (releaseNotes != null && releaseNotes.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.sp),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "What's New:",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                        ),
                        SizedBox(height: 6.h),
                        customText(
                          releaseNotes,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greyColor,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 24.h),

                // Force update notice
                if (isForceUpdate)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.sp),
                    margin: EdgeInsets.only(bottom: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: customText(
                            'This update is required to continue using the app',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Update button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _openStore,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Platform.isAndroid ? Icons.shop : Icons.apple,
                          color: AppColors.whiteColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        customText(
                          'Update Now',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),

                // Later button (only if not force update)
                if (!isForceUpdate) ...[
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () {
                      _isDialogShowing = false;
                      Get.back();
                    },
                    child: customText(
                      'Later',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: !isForceUpdate,
      barrierColor: Colors.black.withValues(alpha: 0.5),
    ).then((_) {
      if (!isForceUpdate) {
        _isDialogShowing = false;
      }
    });
  }

  /// Open the appropriate app store
  Future<void> _openStore() async {
    final Uri storeUrl;

    if (Platform.isAndroid) {
      storeUrl = Uri.parse('market://details?id=$_playStoreId');
    } else {
      storeUrl = Uri.parse('https://apps.apple.com/app/id$_appStoreId');
    }

    try {
      if (await canLaunchUrl(storeUrl)) {
        await launchUrl(storeUrl, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to web URL
        final webUrl = Platform.isAndroid
            ? Uri.parse(
                'https://play.google.com/store/apps/details?id=$_playStoreId')
            : Uri.parse('https://apps.apple.com/app/id$_appStoreId');
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      log('Error opening store: $e');
      showToast(message: 'Could not open store', isError: true);
    }
  }

  /// Manual trigger for testing (can be called from settings)
  void showUpdateDialogForTesting() {
    _showUpdateDialog(
      currentVersion: '1.0.0',
      latestVersion: '2.0.0',
      isForceUpdate: true,
      message:
          'A new version of GoSharpSharp is available with exciting new features and improvements!',
      releaseNotes:
          '• Faster food ordering experience\n• Bug fixes and performance improvements\n• New restaurant categories',
    );
  }
}
