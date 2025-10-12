import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get order details from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    final orderNumber = args?['orderNumber'] ?? 'N/A';
    final totalAmount = args?['totalAmount'] ?? 0.0;
    final paymentMethod = args?['paymentMethod'] ?? 'Unknown';
    final deliveryAddress = args?['deliveryAddress'] ?? 'N/A';

    return WillPopScope(
      // Intercept back button - redirect to dashboard instead of checkout
      onWillPop: () async {
        Get.offAllNamed(Routes.APP_NAVIGATION);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),

                // Success Animation/Icon
                Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      size: 120.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Success Message
                customText(
                  'Order Placed Successfully!',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                customText(
                  'Your order has been confirmed and will be delivered soon.',
                  fontSize: 14.sp,
                  color: AppColors.obscureTextColor,
                  textAlign: TextAlign.center,
                  height: 1.5,
                ),

                SizedBox(height: 40.h),

                // Order Details Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.greyColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        'Order Details',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(height: 16.h),

                      // Order Number
                      _buildDetailRow('Order Number', '#$orderNumber'),
                      SizedBox(height: 12.h),

                      // Total Amount
                      _buildDetailRow(
                        'Total Amount',
                        formatToCurrency(totalAmount),
                      ),
                      SizedBox(height: 12.h),

                      // Payment Method
                      _buildDetailRow(
                        'Payment Method',
                        _formatPaymentMethod(paymentMethod),
                      ),
                      SizedBox(height: 12.h),

                      // Delivery Address
                      _buildDetailRow(
                        'Delivery Address',
                        deliveryAddress,
                        isAddress: true,
                      ),
                    ],
                  ),
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
                        // Navigate to orders history, clearing entire stack
                        Get.offAllNamed(Routes.ORDERS_HOME_SCREEN);
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
                        // Navigate to dashboard, clearing entire stack
                        Get.offAllNamed(Routes.APP_NAVIGATION);
                      },
                      borderRadius: 12.r,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontColor: AppColors.primaryColor,
                      // hasBorder: true,
                      borderColor: AppColors.primaryColor,
                    ),
                  ],
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAddress = false}) {
    return Row(
      crossAxisAlignment: isAddress
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(label, fontSize: 13.sp, color: AppColors.obscureTextColor),
        SizedBox(width: 12.w),
        Flexible(
          child: customText(
            value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
            textAlign: TextAlign.end,
            maxLines: isAddress ? 3 : 1,
          ),
        ),
      ],
    );
  }

  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'wallet':
        return 'Go Wallet';
      case 'paystack':
        return 'Card Payment';
      case 'cash':
        return 'Cash on Delivery';
      default:
        return method;
    }
  }
}
