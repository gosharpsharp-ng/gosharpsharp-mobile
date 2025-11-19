import 'package:gosharpsharp/core/utils/exports.dart';

class FoodTypeCategoryItem extends StatelessWidget {
  final String name;
  final String image;
  final bool isSelected;
  final VoidCallback? onPressed;

  const FoodTypeCategoryItem({
    super.key,
    required this.name,
    required this.image,
    this.isSelected = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1, end: isSelected ? 1.05 : 1),
      duration: Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: InkWell(
            onTap: onPressed,
            splashColor: AppColors.primaryColor.withAlpha(30),
            highlightColor: AppColors.primaryColor.withAlpha(15),
            borderRadius: BorderRadius.circular(10.r),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withAlpha(26)
                    : AppColors.transparent,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : AppColors.transparent,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryColor.withAlpha(40),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Animated image with tilt effect when selected
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0,
                      end: isSelected ? -0.05 : 0,
                    ),
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    builder: (context, rotation, child) {
                      return Transform.rotate(
                        angle: rotation,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.all(isSelected ? 3.sp : 0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppColors.primaryColor.withAlpha(38)
                                : AppColors.transparent,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25.r),
                            child: Image.asset(
                              image,
                              height: 45.sp,
                              width: 45.sp,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 6.h),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryColor : AppColors.blackColor,
                    ),
                    child: Text(name),
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
