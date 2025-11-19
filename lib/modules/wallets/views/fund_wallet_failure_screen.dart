import 'package:gosharpsharp/core/utils/exports.dart';

class FundWalletFailureScreen extends StatelessWidget {
  const FundWalletFailureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get failure details from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final errorMessage = args?['message'] ?? 'Payment was not completed';

    // Refresh wallet data when screen loads
    final walletController = Get.find<WalletController>();
    Future.delayed(Duration.zero, () {
      walletController.getWalletBalance();
      walletController.getTransactions();
    });

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
                  'Wallet Funding Failed',
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

                Spacer(),

                // Action Buttons
                Column(
                  children: [
                    // Primary Button - Back to Wallet
                    CustomButton(
                      width: double.infinity,
                      height: 56.h,
                      backgroundColor: AppColors.primaryColor,
                      title: 'Back to Wallet',
                      onPressed: () {
                        // Navigate to wallet home screen
                        Get.offNamedUntil(
                          Routes.WALLETS_HOME_SCREEN,
                          (route) => route.settings.name == Routes.APP_NAVIGATION,
                        );
                      },
                      borderRadius: 12.r,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.whiteColor,
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
