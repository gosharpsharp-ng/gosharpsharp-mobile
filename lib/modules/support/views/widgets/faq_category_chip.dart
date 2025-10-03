

import '../../../../core/utils/exports.dart';

class FaqCategoryChip extends StatelessWidget {
  final String value;
  final bool isSelected;
  final Function onSelected;
  const FaqCategoryChip(
      {super.key,
      required this.value,
      this.isSelected = false,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelected();
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.3), width: 1.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: customText(
                value,
                color: AppColors.blackColor.withOpacity(0.7),
                fontWeight: isSelected?FontWeight.w500:FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
