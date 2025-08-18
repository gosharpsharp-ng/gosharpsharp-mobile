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
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0.r),
        topRight: Radius.circular(15.0.r),
      ),
      child: Container(
        height: 200.sp,
        width: 1.sw,
        decoration: const BoxDecoration(color: AppColors.whiteColor),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 13.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.whiteColor),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    splashColor: AppColors.transparent,
                    child: Icon(
                      Icons.clear,
                      color: AppColors.redColor,
                      size: 25.sp,
                    ),
                  ),
                SizedBox(width: 45.w,),
                customText(
                      title,
                      fontWeight: FontWeight.w500,
                      fontSize: 25.sp,
                      color: AppColors.blackColor
                  ),
                ],
              ),
            ),
            InkWell(
              splashColor: AppColors.transparent,
              onTap: () async {
                await takePhotoFunction();
                Get.back();
              },
              child: customText(
                "Use Camera",
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: AppColors.primaryColor
              ),
            ),
            InkWell(
                splashColor: AppColors.transparent,
                onTap: () async {
                  await selectFromGalleryFunction();
                  Get.back();
                },
                child: Text(
                  'Select from Gallery',
                  style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: AppColors.primaryColor),
                ),),

          ],
        ),
      ),
    );
  }
}
