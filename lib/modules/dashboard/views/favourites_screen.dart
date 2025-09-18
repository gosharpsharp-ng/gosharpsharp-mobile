import 'package:flutter/material.dart';
import '../../../core/utils/exports.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        return Scaffold(
          appBar: defaultAppBar(centerTitle: true, title: "Favourites"),
          body: RefreshIndicator(
            backgroundColor: AppColors.primaryColor,
            color: AppColors.whiteColor,
            onRefresh: () async {
              await dashboardController.fetchFavoriteRestaurants();
            },
            child: dashboardController.isLoadingFavorites
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            )
                : dashboardController.favoriteRestaurants.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    "Your Favorite Restaurants",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 15.h),
                  ...List.generate(
                    dashboardController.favoriteRestaurants.length,
                        (i) => FavRestaurantContainer(
                      restaurant: dashboardController.favoriteRestaurants[i],
                      onPressed: () {
                        dashboardController.navigateToRestaurant(
                            dashboardController.favoriteRestaurants[i]
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        width: 1.sw,
        height: 0.7.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80.sp,
              color: AppColors.obscureTextColor.withOpacity(0.5),
            ),
            SizedBox(height: 20.h),
            customText(
              "No Favorites Yet",
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 10.h),
            customText(
              "Start adding restaurants to your favorites\nto see them here",
              fontSize: 16.sp,
              color: AppColors.obscureTextColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                Get.back(); // Go back to browse restaurants
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: customText(
                "Browse Restaurants",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}