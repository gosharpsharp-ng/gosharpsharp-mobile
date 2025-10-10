import 'package:gosharpsharp/core/utils/exports.dart';

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
  bool isCreatingNew = false;
  final TextEditingController _newPackageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedPackage = widget.currentPackage ?? widget.existingPackages.firstOrNull;
  }

  @override
  void dispose() {
    _newPackageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.75.sh),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    "Select Package",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, size: 24.sp, color: AppColors.greyColor),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ),

            Divider(height: 1, thickness: 1, color: AppColors.lightGreyColor),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Existing packages list
                    if (widget.existingPackages.isNotEmpty) ...[
                      customText(
                        "Existing Packages",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyColor,
                      ),
                      SizedBox(height: 12.h),
                      ...widget.existingPackages.map((packageName) {
                        final isSelected = selectedPackage == packageName && !isCreatingNew;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPackage = packageName;
                              isCreatingNew = false;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.lightGreyColor : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.blackColor
                                    : AppColors.lightGreyColor,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: isSelected
                                      ? AppColors.blackColor
                                      : AppColors.greyColor,
                                  size: 22.sp,
                                ),
                                SizedBox(width: 12.w),
                                Icon(
                                  Icons.inventory_2_outlined,
                                  color: AppColors.greyColor,
                                  size: 18.sp,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: customText(
                                    packageName,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 20.h),
                    ],

                    // Create new package option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isCreatingNew = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: isCreatingNew ? AppColors.lightGreyColor : AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isCreatingNew
                                ? AppColors.blackColor
                                : AppColors.lightGreyColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isCreatingNew
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: isCreatingNew
                                  ? AppColors.blackColor
                                  : AppColors.greyColor,
                              size: 22.sp,
                            ),
                            SizedBox(width: 12.w),
                            Icon(
                              Icons.add_circle_outline,
                              color: AppColors.greyColor,
                              size: 18.sp,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: customText(
                                "Create New Package",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // New package name input (shown when creating new)
                    if (isCreatingNew) ...[
                      SizedBox(height: 16.h),
                      CustomOutlinedRoundedInputField(
                        controller: _newPackageController,
                        label: "Enter package name (e.g., Pack 2)",
                        onChanged: (value) {
                          setState(() {
                            selectedPackage = value;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.lightGreyColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.greyColor),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: customText(
                        "Cancel",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isCreatingNew) {
                          final newPackageName = _newPackageController.text.trim();
                          if (newPackageName.isEmpty) {
                            showToast(
                              message: "Please enter a package name",
                              isError: true,
                            );
                            return;
                          }
                          Get.back(result: newPackageName);
                        } else if (selectedPackage != null) {
                          Get.back(result: selectedPackage);
                        } else {
                          showToast(
                            message: "Please select a package",
                            isError: true,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: customText(
                        "Add to Package",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}