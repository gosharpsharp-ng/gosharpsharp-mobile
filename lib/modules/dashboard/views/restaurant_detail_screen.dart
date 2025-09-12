import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/dashboard/views/food_detail_screen.dart';

class RestaurantDetailScreen extends StatelessWidget {


  const RestaurantDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Column(
            children: [
              // Header Image with Back Button and Menu
              Container(
                height: 300.h,
                width: 1.sw,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(dashboardController.selectedRestaurant?.name??""),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Dark overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    // Back button and menu
                    Positioned(
                      top: 50.h,
                      left: 20.w,
                      right: 20.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.whiteColor,
                                size: 20.sp,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.more_vert,
                                color: AppColors.whiteColor,
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Restaurant name overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.redColor.withAlpha(200),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Restaurant Info Card
              Expanded(
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // Restaurant Info
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 25.r,
                                backgroundColor: AppColors.primaryColor,
                                child: Text(
                                  "😊",
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      dashboardController.selectedRestaurant?.name??"",
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(height: 8.h),
                                    customText(
                                      dashboardController.selectedRestaurant?.description??"",
                                      fontSize: 14.sp,
                                      color: AppColors.obscureTextColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Location and Opening Hours
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    "Location",
                                    fontSize: 14.sp,
                                    color: AppColors.obscureTextColor,
                                  ),
                                  customText(
                                    dashboardController.selectedRestaurant?.location
                                        ??"",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  customText(
                                    "Opening hours:",
                                    fontSize: 14.sp,
                                    color: AppColors.obscureTextColor,
                                  ),
                                  customText(
                                    dashboardController.selectedRestaurant?.openingHours??"",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30.h),

                        // Category Tabs
                        Container(
                          height: 50.h,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              children: [
                                _buildCategoryTab("All", false),
                                _buildCategoryTab("Drinks", true),
                                _buildCategoryTab("Burger", false),
                                _buildCategoryTab("Sandwich", false),
                                _buildCategoryTab("Pizza", false),
                                _buildCategoryTab("Drinks", false),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Menu Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: customText(
                            "Drinks (10)",
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.obscureTextColor,
                          ),
                        ),

                        SizedBox(height: 15.h),

                        // Menu Items
                        _buildMenuItem(
                          "Drinkupucho",
                          "₦3,000.00",
                          PngAssets.chow1,
                        ),
                        _buildMenuItem(
                          "Menu title",
                          "₦2,500.00",
                          PngAssets.chow2,
                        ),
                        _buildMenuItem(
                          "Menu title",
                          "₦2,500.00",
                          PngAssets.chow3,
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryTab(String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isSelected ? AppColors.secondaryColor : AppColors.obscureTextColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          customText(
            title,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.blackColor : AppColors.obscureTextColor,
          ),
          if (isSelected) ...[
            SizedBox(width: 8.w),
            Icon(
              Icons.close,
              size: 16.sp,
              color: AppColors.blackColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(String name, String price, String image) {
    return InkWell(
      onTap: () {
        Get.to(() => FoodDetailScreen(
          foodName: name,
          price: price,
          foodImage: image,
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        child: Row(
          children: [
            // Food Image
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 15.w),

            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    name,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 5.h),
                  customText(
                    price,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            ),

            // Add to Cart Button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: customText(
                "Add to cart",
                fontSize: 12.sp,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}