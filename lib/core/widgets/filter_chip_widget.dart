import 'package:gosharpsharp/core/utils/exports.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onPressed;
  final IconData? icon;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1, end: isSelected ? 1.02 : 1),
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(20.r),
            splashColor: AppColors.primaryColor.withAlpha(30),
            highlightColor: AppColors.primaryColor.withAlpha(15),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.greyColor.withAlpha(77),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withAlpha(77),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 16.sp,
                      color: isSelected
                          ? AppColors.whiteColor
                          : AppColors.obscureTextColor,
                    ),
                    SizedBox(width: 4.w),
                  ],
                  customText(
                    label,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? AppColors.whiteColor
                        : AppColors.blackColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
