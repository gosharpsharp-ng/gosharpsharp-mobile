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
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        // border: Border(
        //   bottom: BorderSide(
        //     color: AppColors.greyColor.withOpacity(0.2),
        //     width: 1,
        //   ),
        // ),
      ),
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                  maxLines: 2,
                ),

                SizedBox(height: 8.h),

                // Price information
                customText(
                  "₦${item.price} each",
                  fontSize: 13.sp,
                  color: AppColors.obscureTextColor,
                ),

                SizedBox(height: 8.h),

                // Total and quantity controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      "₦${item.total}",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),

                    // Quantity controls
                    _buildQuantityControls(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage() {
    // Check if files exist and are not empty
    String? imageUrl;
    if (item.purchasable.files.isNotEmpty) {
      imageUrl = item.purchasable.files[0].url;
    }

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.backgroundColor,
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
        color: AppColors.primaryColor.withOpacity(0.1),
        // border: Border.all(color: AppColors.greyColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button (shows delete icon when quantity is 1)
          InkWell(
            onTap: isUpdating
                ? null
                : item.quantity == 1
                    ? () => _showRemoveDialog(Get.context!)
                    : () => onQuantityChanged(item.quantity - 1),
            child: Container(
              padding: EdgeInsets.all(6.sp),
              child: Icon(
                item.quantity == 1 ? Icons.delete_outline : Icons.remove,
                size: 16.sp,
                color: isUpdating
                    ? AppColors.greyColor.withOpacity(0.5)
                    : item.quantity == 1
                        ? AppColors.primaryColor.withAlpha(250)
                        : AppColors.blackColor,
              ),
            ),
          ),

          // Quantity display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            child: customText(
              item.quantity.toString(),
              fontSize: 14.sp,
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
              padding: EdgeInsets.all(6.sp),
              child: Icon(
                Icons.add,
                size: 14.sp,
                color: isUpdating
                    ? AppColors.greyColor.withOpacity(0.5)
                    : AppColors.blackColor,
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