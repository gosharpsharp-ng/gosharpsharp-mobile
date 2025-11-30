import 'package:gosharpsharp/core/utils/exports.dart';

class FoodTypeCategoryItem extends StatelessWidget {
  final String name;
  final String? image;
  final String? imageUrl;
  final bool isSelected;
  final VoidCallback? onPressed;

  const FoodTypeCategoryItem({
    super.key,
    required this.name,
    this.image,
    this.imageUrl,
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
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.transparent,
                  width: 0.1,
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
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: isSelected ? -0.2 : 0,
                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        builder: (context, rotation, child) {
                          return Transform.rotate(
                            angle: rotation,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              padding: EdgeInsets.all(isSelected ? 0.sp : 0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.primaryColor.withAlpha(14)
                                    : AppColors.transparent,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.r),
                                child: imageUrl != null && imageUrl!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: imageUrl!,
                                        height: 40.sp,
                                        width: 40.sp,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              height: 45.sp,
                                              width: 45.sp,
                                              color: AppColors.greyColor
                                                  .withAlpha(51),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              height: 45.sp,
                                              width: 45.sp,
                                              color: AppColors.backgroundColor,
                                              child: Icon(
                                                Icons.restaurant,
                                                size: 24.sp,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                      )
                                    : image != null && image!.isNotEmpty
                                    ? Image.asset(
                                        image!,
                                        height: 45.sp,
                                        width: 45.sp,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 45.sp,
                                        width: 45.sp,
                                        color: AppColors.backgroundColor,
                                        child: Icon(
                                          Icons.restaurant,
                                          size: 24.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Check icon at bottom right
                      if (isSelected)
                        Positioned(
                          bottom: -2.sp,
                          right: -2.sp,
                          child: AnimatedScale(
                            scale: isSelected ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.elasticOut,
                            child: Container(
                              padding: EdgeInsets.all(2.sp),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.whiteColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.check,
                                color: AppColors.whiteColor,
                                size: 12.sp,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
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
