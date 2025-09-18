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

                      SizedBox(height: 6.h),

                      // Restaurant name
                      Row(
                        children: [
                          Icon(
                            Icons.restaurant,
                            size: 14.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: customText(
                              item.purchasable.restaurant.name,
                              fontSize: 14.sp,
                              color: AppColors.obscureTextColor,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),

                      // Category and Plate Size row
                      Row(
                        children: [
                          // Category badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: _getCategoryColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: _getCategoryColor().withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: customText(
                              item.purchasable.category.name,
                              fontSize: 11.sp,
                              color: _getCategoryColor(),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(width: 8.w),

                          // Plate size if available
                          if (item.purchasable.plateSize.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: customText(
                                "Size: ${item.purchasable.plateSize}",
                                fontSize: 11.sp,
                                color: AppColors.obscureTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          Spacer(),

                          // Prep time
                          if (item.purchasable.prepTimeMinutes > 0) ...[
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 12.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                                SizedBox(width: 2.w),
                                customText(
                                  "${item.purchasable.prepTimeMinutes}min",
                                  fontSize: 11.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                              ],
                            ),
                          ],
                        ],
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

                          // Quantity controls
                          _buildQuantityControls(),
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

          // Action buttons row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor.withOpacity(0.3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Description preview
                Expanded(
                  child: customText(
                    item.purchasable.description,
                    fontSize: 12.sp,
                    color: AppColors.obscureTextColor,
                    maxLines: 1,
                  ),
                ),

                SizedBox(width: 16.w),

                // Remove button
                InkWell(
                  onTap: isRemoving ? null : () => _showRemoveDialog(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isRemoving
                          ? AppColors.greyColor.withOpacity(0.3)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isRemoving
                            ? AppColors.greyColor.withOpacity(0.5)
                            : Colors.red.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isRemoving ? Icons.hourglass_empty : Icons.delete_outline,
                          size: 14.sp,
                          color: isRemoving ? AppColors.greyColor : Colors.red,
                        ),
                        SizedBox(width: 4.w),
                        customText(
                          isRemoving ? "Removing..." : "Remove",
                          fontSize: 12.sp,
                          color: isRemoving ? AppColors.greyColor : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
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
    String? imageUrl = item.purchasable.restaurant.banner ?? item.purchasable.restaurant.logo;

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