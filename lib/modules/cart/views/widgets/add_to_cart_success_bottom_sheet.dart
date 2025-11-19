import 'package:gosharpsharp/core/utils/exports.dart';

class AddToCartSuccessBottomSheet extends StatefulWidget {
  final String itemName;
  final int quantity;

  const AddToCartSuccessBottomSheet({
    super.key,
    required this.itemName,
    required this.quantity,
  });

  @override
  State<AddToCartSuccessBottomSheet> createState() =>
      _AddToCartSuccessBottomSheetState();
}

class _AddToCartSuccessBottomSheetState
    extends State<AddToCartSuccessBottomSheet> {
  @override
  void initState() {
    super.initState();

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && Get.isBottomSheetOpen == true) {
        Get.back();
      }
    });
  }

  void _handleViewCart() {
    Get.back();
    Get.toNamed(Routes.CART_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(bottom: 20.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.obscureTextColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Success icon
          Icon(Icons.check_circle, color: Colors.green, size: 48.sp),

          SizedBox(height: 16.h),

          // Title
          customText(
            "Added to Cart!",
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),

          SizedBox(height: 8.h),

          // Description
          customText(
            "${widget.quantity} x ${widget.itemName} has been added to your cart",
            fontSize: 14.sp,
            color: AppColors.greyColor,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primaryColor),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: customText(
                    "Continue Shopping",
                    fontSize: 14.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleViewCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: customText(
                    "View Cart",
                    fontSize: 14.sp,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
