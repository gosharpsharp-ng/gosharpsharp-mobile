import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class AddonSelectionBottomSheet extends StatefulWidget {
  final MenuItemModel menuItem;
  final Function(int? addonMenuId) onAddToCart;

  const AddonSelectionBottomSheet({
    super.key,
    required this.menuItem,
    required this.onAddToCart,
  });

  @override
  State<AddonSelectionBottomSheet> createState() => _AddonSelectionBottomSheetState();
}

class _AddonSelectionBottomSheetState extends State<AddonSelectionBottomSheet> {
  int? selectedAddonId;

  @override
  Widget build(BuildContext context) {
    final addons = widget.menuItem.addonMenus ?? [];

    return Container(
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
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.obscureTextColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: customText(
                        "Select Add-ons",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: AppColors.obscureTextColor,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                customText(
                  "Choose an add-on for ${widget.menuItem.name}",
                  fontSize: 14.sp,
                  color: AppColors.obscureTextColor,
                ),
              ],
            ),
          ),

          Divider(height: 1.h, color: AppColors.obscureTextColor.withOpacity(0.2)),

          // Add-ons list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              itemCount: addons.length,
              separatorBuilder: (context, index) => Divider(
                height: 1.h,
                color: AppColors.obscureTextColor.withOpacity(0.1),
              ),
              itemBuilder: (context, index) {
                final addon = addons[index];
                final isSelected = selectedAddonId == addon.id;

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedAddonId = isSelected ? null : addon.id;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    color: isSelected
                        ? AppColors.primaryColor.withOpacity(0.05)
                        : AppColors.whiteColor,
                    child: Row(
                      children: [
                        // Addon image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: addon.files.isNotEmpty
                              ? Image.network(
                                  addon.files.first.url,
                                  width: 60.w,
                                  height: 60.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60.w,
                                      height: 60.w,
                                      color: AppColors.backgroundColor,
                                      child: Icon(
                                        Icons.fastfood,
                                        color: AppColors.obscureTextColor,
                                        size: 30.sp,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 60.w,
                                  height: 60.w,
                                  color: AppColors.backgroundColor,
                                  child: Icon(
                                    Icons.fastfood,
                                    color: AppColors.obscureTextColor,
                                    size: 30.sp,
                                  ),
                                ),
                        ),
                        SizedBox(width: 12.w),

                        // Addon details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                addon.name,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              if (addon.description != null && addon.description!.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                customText(
                                  addon.description!,
                                  fontSize: 12.sp,
                                  color: AppColors.obscureTextColor,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              SizedBox(height: 4.h),
                              customText(
                                "+₦${addon.price.toStringAsFixed(2)}",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),

                        // Selection indicator
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.obscureTextColor.withOpacity(0.3),
                              width: 2,
                            ),
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.whiteColor,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: AppColors.whiteColor,
                                  size: 16.sp,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom action buttons
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        widget.onAddToCart(null);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryColor),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: customText(
                        "Skip Add-ons",
                        fontSize: 14.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: selectedAddonId != null
                          ? () {
                              Get.back();
                              widget.onAddToCart(selectedAddonId);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedAddonId != null
                            ? AppColors.primaryColor
                            : AppColors.obscureTextColor.withOpacity(0.3),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: customText(
                        "Add to Cart",
                        fontSize: 14.sp,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}