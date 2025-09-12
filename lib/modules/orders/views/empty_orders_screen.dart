import 'package:flutter/material.dart';

import '../../../core/utils/exports.dart';

class EmptyCartScreen extends StatelessWidget {
  const EmptyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'My Cart',
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
            // Cart Icon
            Container(
              padding: EdgeInsets.all(30.sp),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_basket_outlined,
                size: 80.sp,
                color: AppColors.secondaryColor,
              ),
            ),
            SizedBox(height: 30.h),
            customText(
              'Your Cart is Empty',
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: customText(
                'Search your favorite foods and\nrestaurants. Start ordering now.',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greyColor,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40.h),
            Container(
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextButton(
                onPressed: () => Get.offAllNamed(Routes.DASHBOARD),
                child: customText(
                  'Go to Home',
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
  }
}
