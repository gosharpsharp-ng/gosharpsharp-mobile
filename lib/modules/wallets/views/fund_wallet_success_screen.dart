import 'package:gosharpsharp/core/utils/exports.dart';

class FundWalletSuccessScreen extends StatelessWidget {
  const FundWalletSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get success details from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final amount = args?['amount'] ?? 'N/A';

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

                // Success Icon
                Icon(
                  Icons.check_circle,
                  size: 100.sp,
                  color: AppColors.primaryColor,
                ),

                SizedBox(height: 24.h),

                // Success Message
                customText(
                  'Wallet Funded!',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                customText(
                  'Your wallet has been successfully funded with $amount',
                  fontSize: 15.sp,
                  color: AppColors.obscureTextColor,
                  textAlign: TextAlign.center,
                  maxLines: 2,
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
