import 'package:gosharpsharp/core/utils/exports.dart';

class CategoryContainer extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool isSelected;
  final VoidCallback? onPressed;

  const CategoryContainer({
    super.key,
    this.name = "Lunch",
    this.icon = Icons.restaurant,
    this.isSelected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      splashColor: AppColors.primaryColor.withAlpha(30),
      highlightColor: AppColors.primaryColor.withAlpha(15),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.r),
        topRight: Radius.circular(30.r),
        bottomLeft: Radius.circular(15.r),
        bottomRight: Radius.circular(30.r),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
            bottomLeft: Radius.circular(15.r),
            bottomRight: Radius.circular(30.r),
          ),
          border: Border.all(
            color: isSelected
                ? AppColors.blackColor
                : AppColors.greyColor.withAlpha(50),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.blackColor.withAlpha(30)
                  : AppColors.blackColor.withAlpha(15),
              blurRadius: isSelected ? 12 : 8,
              offset: Offset(0, isSelected ? 4 : 3),
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Animated tilted icon
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: isSelected ? -0.12 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  builder: (context, rotation, child) {
                    return Transform.rotate(
                      angle: rotation,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 1,
                          end: isSelected ? 1.1 : 1,
                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primaryColor.withAlpha(30)
                                    : AppColors.greyColor.withAlpha(20),
                              ),
                              child: Icon(
                                icon,
                                size: 28.sp,
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.blackColor.withAlpha(180),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 8.h),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.blackColor
                        : AppColors.blackColor.withAlpha(180),
                  ),
                  child: Text(name),
                ),
              ],
            ),
            // Check icon at bottom right - white check in black container
            Positioned(
              bottom: -6.h,
              right: -6.w,
              child: AnimatedScale(
                scale: isSelected ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                curve: Curves.elasticOut,
                child: AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    padding: EdgeInsets.all(4.sp),
                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withAlpha(80),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check,
                      size: 10.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
