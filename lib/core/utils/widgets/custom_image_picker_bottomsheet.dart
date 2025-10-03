import 'package:gosharpsharp/core/utils/exports.dart';


class CustomImagePickerBottomSheet extends StatelessWidget {
  final Function takePhotoFunction;
  final Function selectFromGalleryFunction;
  final Function deleteFunction;
  final String title;

  const CustomImagePickerBottomSheet({
    super.key,
    required this.title,
    required this.takePhotoFunction,
    required this.selectFromGalleryFunction,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header with title and close button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Row(
              children: [
                Expanded(
                  child: customText(
                    title,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    color: AppColors.blackColor,
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.greyColor,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Options
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                // Camera Option
                _buildOptionTile(
                  icon: Icons.camera_alt,
                  iconColor: AppColors.primaryColor,
                  iconBgColor: AppColors.primaryColor.withOpacity(0.1),
                  title: "Take Photo",
                  subtitle: "Use camera to capture image",
                  onTap: () async {
                    await takePhotoFunction();
                    Get.back();
                  },
                ),

                SizedBox(height: 16.h),

                // Gallery Option
                _buildOptionTile(
                  icon: Icons.photo_library,
                  iconColor: AppColors.primaryColor,
                  iconBgColor: AppColors.primaryColor.withOpacity(0.1),
                  title: "Choose from Gallery",
                  subtitle: "Select from your photo library",
                  onTap: () async {
                    await selectFromGalleryFunction();
                    Get.back();
                  },
                ),

                SizedBox(height: 16.h),

                // Delete Option (if needed)
                // _buildOptionTile(
                //   icon: Icons.delete_outline,
                //   iconColor: AppColors.redColor,
                //   iconBgColor: AppColors.redColor.withOpacity(0.1),
                //   title: "Remove Image",
                //   subtitle: "Delete current image",
                //   onTap: () async {
                //     await deleteFunction();
                //     Get.back();
                //   },
                // ),
              ],
            ),
          ),

          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.greyColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.sp,
              ),
            ),

            SizedBox(width: 16.w),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    title,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 4.h),
                  customText(
                    subtitle,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.greyColor.withOpacity(0.5),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}