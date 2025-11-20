import 'package:gosharpsharp/core/models/categories_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

/// Shows a styled and animated food type bottom sheet
void showFoodTypeBottomSheet(
  BuildContext context,
  DashboardController controller,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.blackColor.withAlpha(100),
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(context),
      duration: Duration(milliseconds: 400),
    ),
    builder: (context) => FoodTypeBottomSheet(controller: controller),
  );
}

class FoodTypeBottomSheet extends StatefulWidget {
  final DashboardController controller;

  const FoodTypeBottomSheet({super.key, required this.controller});

  @override
  State<FoodTypeBottomSheet> createState() => _FoodTypeBottomSheetState();
}

class _FoodTypeBottomSheetState extends State<FoodTypeBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          alignment: Alignment.bottomCenter,
          child: Opacity(opacity: _fadeAnimation.value, child: child),
        );
      },
      child: Container(
        height: 0.65.sh,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withAlpha(40),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Animated handle bar
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scaleX: value,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor.withAlpha(77),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                );
              },
            ),
            // Header with slide-in animation
            TweenAnimationBuilder<Offset>(
              tween: Tween<Offset>(begin: Offset(0, -20), end: Offset.zero),
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: offset,
                  child: Opacity(
                    opacity: offset == Offset.zero ? 1 : 0.5,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      "Food Type",
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                    GetBuilder<DashboardController>(
                      builder: (ctrl) {
                        return AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          child: ctrl.selectedFoodType.value.isNotEmpty
                              ? TextButton(
                                  key: ValueKey('clear'),
                                  onPressed: () {
                                    ctrl.updateSelectedFoodType('');
                                    Navigator.pop(context);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 8.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: customText(
                                    "Clear",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                )
                              : SizedBox.shrink(key: ValueKey('empty')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Divider(height: 1, color: AppColors.greyColor.withAlpha(51)),
            SizedBox(height: 8.h),
            // Grid of food types with staggered animation
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: GetBuilder<DashboardController>(
                  builder: (ctrl) {
                    return GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.82,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 16.h,
                      ),
                      itemCount: ctrl.menuCategories.length,
                      itemBuilder: (context, index) {
                        final category = ctrl.menuCategories[index];
                        final isSelected =
                            ctrl.selectedFoodType.value == category.name;

                        // Staggered animation for each item
                        return TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: Duration(milliseconds: 300 + (index * 50)),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: value.clamp(0.0, 1.0),
                                child: child,
                              ),
                            );
                          },
                          child: _buildFoodTypeItem(
                            context,
                            category,
                            isSelected,
                            ctrl,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodTypeItem(
    BuildContext context,
    CategoryModel category,
    bool isSelected,
    DashboardController ctrl,
  ) {
    return InkWell(
      onTap: () {
        ctrl.updateSelectedFoodType(category.name);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(14.r),
      splashColor: AppColors.primaryColor.withAlpha(20),
      highlightColor: AppColors.primaryColor.withAlpha(10),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withAlpha(26)
              : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.greyColor.withAlpha(0),
            width: isSelected ? 1.5 : 0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image with tilt animation when selected
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: isSelected ? -0.1 : 0),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  builder: (context, rotation, child) {
                    return Transform.rotate(
                      angle: rotation,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(isSelected ? 2.sp : 0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.primaryColor.withAlpha(30)
                              : AppColors.transparent,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28.r),
                          child:
                              category.iconUrl != null &&
                                  category.iconUrl!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: category.iconUrl!,
                                  height: 44.sp,
                                  width: 44.sp,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 44.sp,
                                    width: 44.sp,
                                    color: AppColors.greyColor.withAlpha(51),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        height: 44.sp,
                                        width: 44.sp,
                                        color: AppColors.backgroundColor,
                                        child: Icon(
                                          Icons.restaurant,
                                          size: 22.sp,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                )
                              : Container(
                                  height: 44.sp,
                                  width: 44.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.restaurant,
                                    size: 22.sp,
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
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withAlpha(60),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check,
                          color: AppColors.whiteColor,
                          size: 10.sp,
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
                fontSize: 9.5.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.blackColor,
                height: 1.2,
              ),
              child: customText(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
