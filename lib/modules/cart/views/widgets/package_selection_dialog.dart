import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';

class PackageSelectionDialog extends StatefulWidget {
  final List<String> existingPackages;
  final String? currentPackage;

  const PackageSelectionDialog({
    super.key,
    required this.existingPackages,
    this.currentPackage,
  });

  @override
  State<PackageSelectionDialog> createState() => _PackageSelectionDialogState();
}

class _PackageSelectionDialogState extends State<PackageSelectionDialog> {
  String? selectedPackage;

  @override
  void initState() {
    super.initState();
    selectedPackage = widget.currentPackage ?? widget.existingPackages.firstOrNull;
  }

  /// Generate the next package name (Pack 2, Pack 3, etc.)
  String _getNextPackageName() {
    int maxNumber = 0;
    for (final name in widget.existingPackages) {
      // Extract number from "Pack X" format
      final match = RegExp(r'Pack\s*(\d+)', caseSensitive: false).firstMatch(name);
      if (match != null) {
        final num = int.tryParse(match.group(1) ?? '0') ?? 0;
        if (num > maxNumber) maxNumber = num;
      }
    }
    return 'Pack ${maxNumber + 1}';
  }

  /// Get item count for a package
  int _getPackageItemCount(String packageName) {
    try {
      final cartController = Get.find<CartController>();
      final package = cartController.packages.firstWhereOrNull(
        (p) => p.name == packageName,
      );
      return package?.items.length ?? 0;
    } catch (e) {
      return 0;
    }
  }

  void _showPackageInfo() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 24.sp,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 12.w),
                  customText(
                    'What is a Package?',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              customText(
                'A package is a group of items in your cart that will be delivered together. You can have multiple packages to organize orders for different recipients or delivery locations.',
                fontSize: 14.sp,
                color: AppColors.blackColor.withValues(alpha: 0.7),
                maxLines: 10,
              ),
              SizedBox(height: 12.h),
              customText(
                'When you add items to your cart, they are automatically added to your selected package.',
                fontSize: 14.sp,
                color: AppColors.blackColor.withValues(alpha: 0.7),
                maxLines: 5,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () => Get.back(),
                  title: 'Got it',
                  backgroundColor: AppColors.primaryColor,
                  fontColor: AppColors.whiteColor,
                  height: 48.h,
                  borderRadius: 12.r,
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPackageItem(String packageName) {
    final isSelected = selectedPackage == packageName;
    final itemCount = _getPackageItemCount(packageName);
    final isCurrent = widget.currentPackage == packageName;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPackage = packageName;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.08)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyColor.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22.sp,
              height: 22.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14.sp,
                      color: AppColors.whiteColor,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      customText(
                        packageName.capitalizeFirst ?? packageName,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      if (isCurrent) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: customText(
                            'Current',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 2.h),
                  customText(
                    '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                    fontSize: 12.sp,
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.6.sh),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 20.w, 12.w, 16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 24.sp,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: customText(
                      "Select Package",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                  IconButton(
                    onPressed: _showPackageInfo,
                    icon: Icon(
                      Icons.info_outline,
                      size: 20.sp,
                      color: AppColors.greyColor,
                    ),
                    padding: EdgeInsets.all(8.sp),
                    constraints: BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close,
                      size: 22.sp,
                      color: AppColors.greyColor,
                    ),
                    padding: EdgeInsets.all(8.sp),
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ),

            Divider(height: 1, thickness: 1, color: AppColors.greyColor.withValues(alpha: 0.15)),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Existing packages list
                    if (widget.existingPackages.isNotEmpty)
                      ...widget.existingPackages.map((packageName) => _buildPackageItem(packageName)),

                    if (widget.existingPackages.isNotEmpty) SizedBox(height: 8.h),

                    // Create new package button
                    GestureDetector(
                      onTap: () {
                        final newName = _getNextPackageName();
                        Get.back(result: newName);
                      },
                      child: Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: AppColors.primaryColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            customText(
                              "Create New Package",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action button
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.greyColor.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {
                    if (selectedPackage != null) {
                      Get.back(result: selectedPackage);
                    } else {
                      showToast(
                        message: "Please select a package",
                        isError: true,
                      );
                    }
                  },
                  title: "Select Package",
                  backgroundColor: AppColors.primaryColor,
                  fontColor: AppColors.whiteColor,
                  height: 50.h,
                  borderRadius: 12.r,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
