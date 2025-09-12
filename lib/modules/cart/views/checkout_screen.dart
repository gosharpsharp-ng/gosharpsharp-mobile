import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';

import '../../../core/utils/exports.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.blackColor),
              onPressed: () => Get.back(),
            ),
            title: customText(
              'Checkout',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Icon
                Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 40.sp,
                    color: AppColors.whiteColor,
                  ),
                ),
                SizedBox(height: 30.h),

                customText(
                  'Your Order has been placed',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 8.h),
                customText(
                  'Successfully',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 16.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: customText(
                    'You successfully placed an order, your order is\nconfirmed and delivered within 20 minutes. Wish you\nenjoy the food',
                    fontSize: 14.sp,
                    color: AppColors.greyColor,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 40.h),

                // Go Back Button
                Container(
                  width: 200.w,
                  height: 45.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextButton(
                    onPressed: () => cartController.goBackToHome(),
                    child: customText(
                      'Go back',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),

                // Track Order Button
                Container(
                  width: 200.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TextButton(
                    onPressed: () => cartController.trackOrderProgress(),
                    child: customText(
                      'Track Order Progress',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}