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
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyColor.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main content Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food/Restaurant Image
              Container(
                width: 90.w,
                height: 90.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.backgroundColor,
                  border: Border.all(
                    color: AppColors.greyColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: _buildItemImage(),
                ),
              ),

              SizedBox(width: 12.w),

              // Item Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item name with padding for remove button
                    Padding(
                      padding: EdgeInsets.only(right: 30.w),
                      child: customText(
                        item.purchasable.name.capitalizeFirst ?? item.purchasable.name,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                        maxLines: 2,
                      ),
                    ),

                    SizedBox(height: 6.h),

                    // Price information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          formatToCurrency(double.tryParse(item.price) ?? 0),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                        // Food Pack (Packaging Price) - if available
                        if (item.purchasable.packagingPrice != null &&
                            double.tryParse(item.purchasable.packagingPrice!) !=
                                null &&
                            double.parse(item.purchasable.packagingPrice!) >
                                0) ...[
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 13.sp,
                                color: AppColors.blackColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              customText(
                                "Pack: ${formatToCurrency(double.parse(item.purchasable.packagingPrice!))}",
                                fontSize: 12.sp,
                                color: AppColors.blackColor.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: 10.h),

                    // Addons (if any)
                    if (item.addons.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 10.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.15,
                            ),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.restaurant,
                                  size: 14.sp,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 4.w),
                                customText(
                                  'Add-ons',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            ...item.addons.map((addon) {
                              final addonName =
                                  (addon.addonMenu?.name ?? 'Unknown addon').capitalizeFirst ?? 'Unknown addon';
                              final addonPrice =
                                  double.tryParse(addon.price) ?? 0.0;
                              return Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5.w,
                                      height: 5.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: customText(
                                        '$addonName',
                                        fontSize: 14.sp,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    customText(
                                      'x${addon.quantity}',
                                      fontSize: 13.sp,
                                      color: AppColors.blackColor.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    customText(
                                      formatToCurrency(
                                        addonPrice * addon.quantity,
                                      ),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],

                    // Total and quantity controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Total price: (quantity * item price) + (packaging price * quantity)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: customText(
                            formatToCurrency(_calculateItemTotal()),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
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
          // Remove button at top right corner
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: isRemoving ? null : () => _showRemoveDialog(Get.context!),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.all(6.sp),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: isRemoving
                    ? SizedBox(
                        width: 14.sp,
                        height: 14.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      )
                    : Icon(Icons.close_rounded, size: 14.sp, color: Colors.red),
              ),
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
        placeholder: (context, url) =>
            Container(color: AppColors.backgroundColor),
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
              (item.purchasable.name.length > 10
                  ? "${item.purchasable.name.substring(0, 10)}..."
                  : item.purchasable.name).capitalizeFirst ?? item.purchasable.name,
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
        color: AppColors.whiteColor,
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
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
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.all(5.sp),
              child: Icon(
                item.quantity == 1
                    ? Icons.delete_outline_rounded
                    : Icons.remove_rounded,
                size: 15.sp,
                color: isUpdating
                    ? AppColors.greyColor.withValues(alpha: 0.5)
                    : item.quantity == 1
                    ? Colors.red
                    : AppColors.primaryColor,
              ),
            ),
          ),

          // Quantity display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: customText(
              item.quantity.toString(),
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),

          // Increase button
          InkWell(
            onTap: isUpdating
                ? null
                : () => onQuantityChanged(item.quantity + 1),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.all(8.sp),
              child: Icon(
                Icons.add_rounded,
                size: 18.sp,
                color: isUpdating
                    ? AppColors.greyColor.withValues(alpha: 0.5)
                    : AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate total: (quantity * item price) + (packaging price * quantity)
  double _calculateItemTotal() {
    final itemPrice = double.tryParse(item.price) ?? 0.0;
    final packagingPrice = item.purchasable.packagingPrice != null
        ? (double.tryParse(item.purchasable.packagingPrice!) ?? 0.0)
        : 0.0;

    return (item.quantity * itemPrice) + (packagingPrice * item.quantity);
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
          'Are you sure you want to remove "${item.purchasable.name.capitalizeFirst ?? item.purchasable.name}" from your cart?',
          fontSize: 15.sp,
          color: AppColors.blackColor.withValues(alpha: 0.7),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: customText(
              'Cancel',
              fontSize: 15.sp,
              color: AppColors.blackColor.withValues(alpha: 0.6),
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
              fontSize: 15.sp,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
