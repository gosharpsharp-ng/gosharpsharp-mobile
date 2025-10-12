import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/orders/views/orders_home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get order details from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final orderNumber = args?['orderNumber'] ?? 'N/A';

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
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
                  'Order Placed!',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                customText(
                  'Your order #$orderNumber has been confirmed',
                  fontSize: 15.sp,
                  color: AppColors.obscureTextColor,
                  textAlign: TextAlign.center,
                ),

                Spacer(),

                // Action Buttons
                Column(
                  children: [
                    // Primary Button - View My Orders
                    CustomButton(
                      width: double.infinity,
                      height: 56.h,
                      backgroundColor: AppColors.primaryColor,
                      title: 'View My Orders',
                      onPressed: () {
                        // Clear entire navigation stack and go to dashboard
                        Get.offAllNamed(Routes.APP_NAVIGATION);
                        // Then navigate to Orders with proper navigation stack
                        Future.delayed(Duration.zero, () {
                          Get.toNamed(Routes.ORDERS_HOME_SCREEN);
                        });
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
                        // Navigate back to Dashboard, removing success screen from stack
                        Get.offAllNamed(Routes.APP_NAVIGATION);
                      },
                      borderRadius: 12.r,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.primaryColor,
                      borderColor: AppColors.primaryColor,
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
