import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/location_permission/controllers/location_permission_controller.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationPermissionController());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isTablet = constraints.maxWidth > 600;
            double iconSize = isTablet ? 100.w : 120.w;
            double iconInnerSize = isTablet ? 50.sp : 60.sp;
            double titleFontSize = isTablet ? 22.sp : 24.sp;
            double descFontSize = isTablet ? 14.sp : 14.sp;
            double benefitTitleFontSize = isTablet ? 14.sp : 14.sp;
            double benefitDescFontSize = isTablet ? 12.sp : 12.sp;
            double benefitIconSize = isTablet ? 20.sp : 20.sp;
            double benefitContainerSize = isTablet ? 40.w : 40.w;
            double buttonHeight = isTablet ? 35.h : 50.h;
            double buttonFontSize = isTablet ? 10.sp : 14.sp;
            double skipFontSize = isTablet ? 14.sp : 14.sp;
            double spacing = isTablet ? 20.h : 40.h;
            double titleSpacing = isTablet ? 8.h : 16.h;
            double descSpacing = isTablet ? 16.h : 32.h;
            double benefitSpacing = isTablet ? 8.h : 16.h;
            double buttonSpacing = isTablet ? 8.h : 12.h;
            double verticalPadding = isTablet ? 8.h : 32.h;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: verticalPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Location icon
                        Container(
                          width: iconSize,
                          height: iconSize,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: iconInnerSize,
                            color: AppColors.primaryColor,
                          ),
                        ),

                        SizedBox(height: spacing),

                        // Title
                        customText(
                          "Enable Location Services",
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackColor,
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 16.h),

                        // Description
                        customText(
                          "We need your location to show you nearby restaurants, track deliveries, and provide accurate service in your area.",
                          fontSize: descFontSize,
                          color: AppColors.obscureTextColor,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                        ),

                        SizedBox(height: descSpacing),

                        // Benefits list
                        _buildBenefit(
                          icon: Icons.restaurant,
                          title: "Find nearby restaurants",
                          description: "Discover food options around you",
                          isTablet: isTablet,
                          titleFontSize: benefitTitleFontSize,
                          descFontSize: benefitDescFontSize,
                          iconSize: benefitIconSize,
                          containerSize: benefitContainerSize,
                        ),
                        SizedBox(height: benefitSpacing),
                        _buildBenefit(
                          icon: Icons.delivery_dining,
                          title: "Real-time delivery tracking",
                          description: "Track your orders accurately",
                          isTablet: isTablet,
                          titleFontSize: benefitTitleFontSize,
                          descFontSize: benefitDescFontSize,
                          iconSize: benefitIconSize,
                          containerSize: benefitContainerSize,
                        ),
                        SizedBox(height: benefitSpacing),
                        _buildBenefit(
                          icon: Icons.speed,
                          title: "Faster service",
                          description: "Get quicker delivery estimates",
                          isTablet: isTablet,
                          titleFontSize: benefitTitleFontSize,
                          descFontSize: benefitDescFontSize,
                          iconSize: benefitIconSize,
                          containerSize: benefitContainerSize,
                        ),
                      ],
                    ),
                  ),

                  // Buttons
                  Obx(() => Column(
                    children: [
                      // Enable Location button with loading state
                      if (controller.isLoading.value)
                        CustomButton(
                          title: "Getting your location...",
                          onPressed: () {},
                          width: double.infinity,
                          height: buttonHeight,
                          fontSize: buttonFontSize,
                          isBusy: true,
                        )
                      else
                        CustomButton(
                          title: "Enable Location",
                          onPressed: () => controller.requestLocationPermission(),
                          width: double.infinity,
                          height: buttonHeight,
                          fontSize: buttonFontSize,
                        ),

                      SizedBox(height: buttonSpacing),

                      // Manual selection button
                      CustomButton(
                        title: "Select Location Manually",
                        onPressed: controller.isLoading.value
                            ? () {}
                            : () => controller.selectLocationManually(),
                        width: double.infinity,
                        height: buttonHeight,
                        fontSize: buttonFontSize,
                        backgroundColor: AppColors.whiteColor,
                        fontColor: controller.isLoading.value
                            ? AppColors.primaryColor.withAlpha(128)
                            : AppColors.primaryColor,
                        borderColor: controller.isLoading.value
                            ? AppColors.primaryColor.withAlpha(128)
                            : AppColors.primaryColor,
                      ),

                      SizedBox(height: buttonSpacing),

                      // Skip button
                      TextButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.skipForNow(),
                        child: customText(
                          "Skip for now",
                          fontSize: skipFontSize,
                          color: controller.isLoading.value
                              ? AppColors.obscureTextColor.withOpacity(0.5)
                              : AppColors.obscureTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String title,
    required String description,
    required bool isTablet,
    required double titleFontSize,
    required double descFontSize,
    required double iconSize,
    required double containerSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: AppColors.secondaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                title,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              SizedBox(height: 4.h),
              customText(
                description,
                fontSize: descFontSize,
                color: AppColors.obscureTextColor,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}