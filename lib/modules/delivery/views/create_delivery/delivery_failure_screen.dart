import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryFailureScreen extends StatelessWidget {
  const DeliveryFailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get failure details from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final errorMessage = args?['message'] ?? 'Payment was not completed';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offAllNamed(Routes.APP_NAVIGATION);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),

                // Failure Icon
                Container(
                  width: 100.sp,
                  height: 100.sp,
                  decoration: BoxDecoration(
                    color: AppColors.redColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 60.sp,
                    color: AppColors.redColor,
                  ),
                ),

                SizedBox(height: 24.h),

                // Failure Message
                customText(
                  'Payment Failed',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                customText(
                  errorMessage,
                  fontSize: 15.sp,
                  color: AppColors.obscureTextColor,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),

                SizedBox(height: 16.h),

                customText(
                  'Your delivery request was not completed. Please try again.',
                  fontSize: 14.sp,
                  color: AppColors.obscureTextColor,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),

                Spacer(),

                // Action Buttons
                Column(
                  children: [
                    // Primary Button - Try Again
                    CustomButton(
                      width: double.infinity,
                      height: 56.h,
                      backgroundColor: AppColors.primaryColor,
                      title: 'Try Again',
                      onPressed: () {
                        // Pop back to APP_NAVIGATION then navigate to create delivery
                        Get.until(
                          (route) =>
                              route.settings.name == Routes.APP_NAVIGATION,
                        );
                        Get.toNamed(Routes.INITIATE_DELIVERY_SCREEN);
                      },
                      borderRadius: 12.r,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.whiteColor,
                    ),

                    SizedBox(height: 12.h),

                    // Secondary Button - Back to Home
                    CustomButton(
                      width: double.infinity,
                      height: 56.h,
                      backgroundColor: AppColors.whiteColor,
                      title: 'Back to Home',
                      onPressed: () {
                        // Navigate back to Dashboard
                        Get.offAllNamed(Routes.APP_NAVIGATION);
                      },
                      borderRadius: 12.r,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.greyColor,
                      borderColor: AppColors.greyColor,
                    ),
                  ],
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
