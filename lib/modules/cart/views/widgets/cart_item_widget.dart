import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/models/cart_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;
  final bool isUpdating;
  final bool isRemoving;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    this.isUpdating = false,
    this.isRemoving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main item row
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food/Restaurant Image
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.backgroundColor,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: _buildItemImage(),
                  ),
                ),

                SizedBox(width: 16.w),

                // Item Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item name
                      customText(
                        item.purchasable.name,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                        maxLines: 2,
                      ),

                      SizedBox(height: 12.h),

                      // Price information
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "₦${item.price} each",
                                fontSize: 14.sp,
                                color: AppColors.obscureTextColor,
                              ),
                              customText(
                                "₦${item.total}",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),

                          // Quantity controls with delete button
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildQuantityControls(),
                              SizedBox(width: 12.w),
                              InkWell(
                                onTap: isRemoving ? null : () => _showRemoveDialog(context),
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: isRemoving
                                        ? AppColors.greyColor.withOpacity(0.3)
                                        : Colors.red.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isRemoving ? Icons.hourglass_empty : Icons.delete_outline,
                                    size: 18.sp,
                                    color: isRemoving ? AppColors.greyColor : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Discount row if applicable
                      if (double.tryParse(item.discount) != null && double.parse(item.discount) > 0) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.local_offer,
                              size: 14.sp,
                              color: Colors.green,
                            ),
                            SizedBox(width: 4.w),
                            customText(
                              "You saved ₦${item.discount}",
                              fontSize: 12.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage() {
    // Try to use banner first, then logo, then fallback
    String? imageUrl = item.purchasable.files[0].url??"";

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.backgroundColor,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackImage(),
      );
    }

    return _buildFallbackImage();
  }

  Widget _buildFallbackImage() {
    return Container(
      color: AppColors.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              color: AppColors.primaryColor,
              size: 24.sp,
            ),
            SizedBox(height: 4.h),
            customText(
              item.purchasable.name.length > 10
                  ? "${item.purchasable.name.substring(0, 10)}..."
                  : item.purchasable.name,
              fontSize: 8.sp,
              color: AppColors.obscureTextColor,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button
          InkWell(
            onTap: isUpdating || item.quantity <= 1
                ? null
                : () => onQuantityChanged(item.quantity - 1),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: item.quantity <= 1 || isUpdating
                    ? AppColors.backgroundColor
                    : AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
              child: Icon(
                Icons.remove,
                size: 16.sp,
                color: item.quantity <= 1 || isUpdating
                    ? AppColors.greyColor
                    : AppColors.primaryColor,
              ),
            ),
          ),

          // Quantity display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
            ),
            child: customText(
              item.quantity.toString(),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ),

          // Increase button
          InkWell(
            onTap: isUpdating
                ? null
                : () => onQuantityChanged(item.quantity + 1),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: isUpdating
                    ? AppColors.backgroundColor
                    : AppColors.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Icon(
                Icons.add,
                size: 16.sp,
                color: isUpdating
                    ? AppColors.greyColor
                    : AppColors.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor() {
    // Return different colors based on category
    switch (item.purchasable.category.name.toLowerCase()) {
      case 'appetizers':
        return Colors.orange;
      case 'main course':
      case 'main':
        return Colors.green;
      case 'desserts':
      case 'dessert':
        return Colors.pink;
      case 'beverages':
      case 'drinks':
        return Colors.blue;
      case 'salads':
        return Colors.teal;
      default:
        return AppColors.primaryColor;
    }
  }

  void _showRemoveDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: customText(
          'Remove Item',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        content: customText(
          'Are you sure you want to remove "${item.purchasable.name}" from your cart?',
          fontSize: 14.sp,
          color: AppColors.greyColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: customText(
              'Cancel',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onRemove();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: customText(
              'Remove',
              fontSize: 14.sp,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}