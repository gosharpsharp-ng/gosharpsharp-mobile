import 'package:flutter/material.dart';
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Location icon
                    Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on,
                        size: 60.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Title
                    customText(
                      "Enable Location Services",
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 16.h),

                    // Description
                    customText(
                      "We need your location to show you nearby restaurants, track deliveries, and provide accurate service in your area.",
                      fontSize: 14.sp,
                      color: AppColors.obscureTextColor,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                    ),

                    SizedBox(height: 32.h),

                    // Benefits list
                    _buildBenefit(
                      icon: Icons.restaurant,
                      title: "Find nearby restaurants",
                      description: "Discover food options around you",
                    ),
                    SizedBox(height: 16.h),
                    _buildBenefit(
                      icon: Icons.delivery_dining,
                      title: "Real-time delivery tracking",
                      description: "Track your orders accurately",
                    ),
                    SizedBox(height: 16.h),
                    _buildBenefit(
                      icon: Icons.speed,
                      title: "Faster service",
                      description: "Get quicker delivery estimates",
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
                      height: 50.h,
                      isBusy: true,
                    )
                  else
                    CustomButton(
                      title: "Enable Location",
                      onPressed: () => controller.requestLocationPermission(),
                      width: double.infinity,
                      height: 50.h,
                    ),

                  SizedBox(height: 12.h),

                  // Manual selection button
                  CustomButton(
                    title: "Select Location Manually",
                    onPressed: controller.isLoading.value
                        ? () {}
                        : () => controller.selectLocationManually(),
                    width: double.infinity,
                    height: 50.h,
                    backgroundColor: AppColors.whiteColor,
                    fontColor: controller.isLoading.value
                        ? AppColors.primaryColor.withOpacity(0.5)
                        : AppColors.primaryColor,
                    borderColor: controller.isLoading.value
                        ? AppColors.primaryColor.withOpacity(0.5)
                        : AppColors.primaryColor,
                  ),

                  SizedBox(height: 12.h),

                  // Skip button
                  TextButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.skipForNow(),
                    child: customText(
                      "Skip for now",
                      fontSize: 14.sp,
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
        ),
      ),
    );
  }

  Widget _buildBenefit({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
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
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              SizedBox(height: 4.h),
              customText(
                description,
                fontSize: 12.sp,
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