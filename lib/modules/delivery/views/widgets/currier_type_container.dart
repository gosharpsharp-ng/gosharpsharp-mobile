import 'package:gosharpsharp/core/utils/exports.dart';

class CurrierTypeContainer extends StatelessWidget {
  final CourierTypePrice currierType;
  final bool isSelected;
  final bool isSelectable;
  final Function onSelected;
  const CurrierTypeContainer({
    super.key,
    required this.currierType,
    required this.onSelected,
    required this.isSelectable,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.transparent,
      splashColor: AppColors.transparent,
      onTap: () {
        if (isSelectable) {
          onSelected();
        }
      },
      child: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.w),
        margin: EdgeInsets.symmetric(vertical: 5.sp),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.fadedPrimaryColor
              : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Image.asset(
                PngAssets.localRideIcon,
                color: !isSelectable
                    ? AppColors.blackColor.withValues(alpha: 0.5)
                    : null,
                height: 40.sp,
                width: 40.sp,
              ),
            ),
            SizedBox(width: 15.sp),
            customText(
              currierType.courierType.capitalizeFirst!,
              color: !isSelectable
                  ? AppColors.blackColor.withValues(alpha: 0.5)
                  : AppColors.blackColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  customText(
                    formatToCurrency(currierType.price.round()),
                    color: !isSelectable
                        ? AppColors.blackColor.withValues(alpha: 0.5)
                        : AppColors.blackColor,
                    // fontStyle: GoogleFonts.inter().fontStyle,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            Container(
              width: 15,
              height: 15,
              margin: EdgeInsets.only(left: 5.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Make the shape circular
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.transparent, // Background color
                border: Border.all(
                  color: AppColors.obscureTextColor, // Border color
                  width: 1.0, // Border width
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
