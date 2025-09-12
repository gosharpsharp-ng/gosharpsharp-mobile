import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';

import '../../../../core/utils/exports.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return Container(
          padding: EdgeInsets.all(12.sp),
          margin: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              // Food Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  item.image,
                  width: 60.sp,
                  height: 60.sp,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),

              // Food Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      item.name,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 4.h),
                    customText(
                      '₦${item.price.toStringAsFixed(2)}',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 2.h),
                    customText(
                      item.options,
                      fontSize: 12.sp,
                      color: AppColors.greyColor,
                    ),
                  ],
                ),
              ),

              // Quantity Controls
              Row(
                children: [
                  // Remove button
                  InkWell(
                    onTap: () => cartController.removeItem(item.id),
                    child: Container(
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 16.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Decrease quantity
                  InkWell(
                    onTap: () => cartController.updateQuantity(
                      item.id,
                      item.quantity - 1,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.remove,
                        size: 16.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Quantity
                  customText(
                    item.quantity.toString(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(width: 8.w),

                  // Increase quantity
                  InkWell(
                    onTap: () => cartController.updateQuantity(
                      item.id,
                      item.quantity + 1,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(4.sp),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 16.sp,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
