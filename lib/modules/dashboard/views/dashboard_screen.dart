import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/utils/widgets/dot.dart';
import 'package:gosharpsharp/modules/dashboard/views/restaurant_detail_screen.dart' show RestaurantDetailScreen;
import 'package:upgrader/upgrader.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        return GetBuilder<DeliveriesController>(
          builder: (ordersController) {
            return UpgradeAlert(
              barrierDismissible: false,
              showIgnore: false,
              showLater: false,
              showReleaseNotes: true,
              dialogStyle: Platform.isIOS
                  ? UpgradeDialogStyle.cupertino
                  : UpgradeDialogStyle.material,
              upgrader: Upgrader(
                messages: UpgraderMessages(code: "Kindly update your app"),
              ),
              child: Scaffold(
                appBar: flatAppBar(
                  bgColor: AppColors.backgroundColor,
                  navigationColor: AppColors.backgroundColor,
                ),
                backgroundColor: AppColors.backgroundColor,
                body: Scaffold(
                  backgroundColor: AppColors.whiteColor,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(55.sp),
                    child: Container(
                      width: 1.sw,
                      color: AppColors.backgroundColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 0.h,
                        horizontal: 10.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GetBuilder<SettingsController>(
                            builder: (settingsController) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.sp),
                                color: AppColors.transparent,
                                child: Row(
                                  children: [
                                    Visibility(
                                      visible:
                                      settingsController
                                          .userProfile
                                          ?.avatar !=
                                          null,
                                      replacement: CircleAvatar(
                                        radius: 22.r,
                                        backgroundColor:
                                        AppColors.backgroundColor,
                                        child: customText(
                                          "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage:
                                        CachedNetworkImageProvider(
                                          settingsController
                                              .userProfile
                                              ?.avatar ??
                                              '',
                                        ),
                                        radius: 22.r,
                                      ),
                                    ),
                                    SizedBox(width: 8.sp),
                                    customText(
                                      "Hi ${settingsController.userProfile?.fname ?? ''}",
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          GetBuilder<SettingsController>(
                            builder: (settingsController) {
                              return Row(
                                children: [
                                  InkWell(
                                    splashColor: AppColors.transparent,
                                    highlightColor: AppColors.transparent,
                                    onTap: () {
                                      Get.toNamed(Routes.NOTIFICATIONS_HOME);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.sp,
                                      ),
                                      child: Badge(
                                        textColor: AppColors.whiteColor,
                                        backgroundColor: AppColors.redColor,
                                        isLabelVisible: true,
                                        label: customText(
                                          settingsController
                                              .isLoadingNotification
                                              ? ''
                                              : settingsController
                                              .notifications
                                              .length >
                                              10
                                              ? '10+'
                                              : settingsController
                                              .notifications
                                              .length
                                              .toString(),
                                          fontSize: 12.sp,
                                        ),
                                        child: SvgPicture.asset(
                                          SvgAssets.notificationIcon,
                                          color: AppColors.obscureTextColor,
                                          height: 20.sp,
                                          width: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  InkWell(
                                    splashColor: AppColors.transparent,
                                    highlightColor: AppColors.transparent,
                                    onTap: () {
                                      // Get.toNamed(Routes.NOTIFICATIONS_HOME);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 1.sp,
                                        vertical: 5.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(5.sp),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 3.w,
                                            ),
                                            child: SvgPicture.asset(
                                              SvgAssets.bikeIcon,
                                              height: 20.sp,
                                              width: 20.sp,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            padding: EdgeInsets.all(5.sp),
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 3.w,
                                            ),
                                            child: SvgPicture.asset(
                                              SvgAssets.walkIcon,
                                              height: 20.sp,
                                              width: 20.sp,
                                              colorFilter: ColorFilter.mode(
                                                AppColors.whiteColor,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: RefreshIndicator(
                    backgroundColor: AppColors.primaryColor,
                    color: AppColors.whiteColor,
                    onRefresh: () async {
                      await Future.wait<void>([
                        // ordersController.fetchDeliveries(),
                        // Get.find<WalletController>().getWalletBalance(),
                        // Get.find<WalletController>().getTransactions(),
                        // Get.find<SettingsController>().getProfile(),
                        // Get.find<NotificationsController>().getNotifications(),
                        dashboardController.refreshData(),
                      ]);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.sp,
                        horizontal: 10.sp,
                      ),
                      color: AppColors.backgroundColor,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 15.h),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryColor.withAlpha(
                                      120,
                                    ),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    children: [
                                      customText(
                                        "Jos central palace",
                                        color: AppColors.blackColor,
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        CupertinoIcons.chevron_down,
                                        size: 15.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),
                            CustomOutlinedRoundedInputField(
                              borderRadius: 12.r,
                              isSearch: true,
                              prefixWidget: Icon(Icons.search, size: 25.sp),
                              suffixWidget: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5.h,
                                  horizontal: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withAlpha(
                                    180,
                                  ),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: SvgPicture.asset(
                                  SvgAssets.filterIcon,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.whiteColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),

                            // Categories Section
                            Container(
                              width: 1.sw,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: dashboardController.categories.map((category) =>
                                      CategoryContainer(
                                        name: category,
                                        onPressed: () {
                                          dashboardController.updateSelectedCategory(category);
                                        },
                                      ),
                                  ).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),

                            // Popular Brands Section
                            ordersController.allDeliveries.isEmpty
                                ? const SectionHeader(title: "Popular Brands")
                                : PartialViewHeader(
                              title: "Popular Brands",
                              onPressed: () {
                                Get.toNamed(Routes.DELIVERIES_HOME);
                              },
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              width: 1.sw,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    BrandsContainer(
                                      name: "Wendy",
                                      image: PngAssets.wendyBrand,
                                    ),
                                    BrandsContainer(
                                      name: "In-n-Out",
                                      image: PngAssets.inOutBrand,
                                    ),
                                    BrandsContainer(
                                      name: "Pizza-Hut",
                                      image: PngAssets.pizzaHutBrand,
                                    ),
                                    BrandsContainer(
                                      name: "Jonny Rockets",
                                      image: PngAssets.jonnyRocketsBrand,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 25.h),

                            // Top Restaurants Section
                            PartialViewHeader(
                              title: "Top Restaurants",
                              onPressed: () {
                                Get.toNamed(Routes.DELIVERIES_HOME);
                              },
                            ),
                            SizedBox(height: 10.h),

                            // Loading state for top restaurants
                            dashboardController.isLoadingRestaurants
                                ? Container(
                              height: 200.h,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                                ),
                              ),
                            )
                                : dashboardController.restaurants.isEmpty
                                ? _buildEmptyRestaurantsState(dashboardController)
                                : Container(
                              width: 1.sw,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                      dashboardController.restaurants.take(5).length,
                                          (i) => RestaurantContainer(
                                        restaurant: dashboardController.restaurants[i],
                                        onPressed: () {
                                          dashboardController.navigateToRestaurant(
                                              dashboardController.restaurants[i]
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 25.h), SizedBox(height: 25.h),

                            // Top Restaurants Section
                            PartialViewHeader(
                              title: "Favourites",
                              onPressed: () {
                                Get.toNamed(Routes.FAQS_SCREEN);
                              },
                            ),
                            SizedBox(height: 10.h),

                            // Loading state for top restaurants
                            dashboardController.isLoadingFavorites
                                ? Container(
                              height: 200.h,
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                                ),
                              ),
                            )
                                : dashboardController.favoriteRestaurants.isEmpty
                                ? _buildEmptyRestaurantsState(dashboardController)
                                : Container(
                              width: 1.sw,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ...List.generate(
                                      dashboardController.favoriteRestaurants.take(5).length,
                                          (i) => FavRestaurantContainer(
                                        restaurant: dashboardController.favoriteRestaurants[i],
                                        onPressed: () {
                                          dashboardController.navigateToRestaurant(
                                              dashboardController.restaurants[i]
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 25.h),

                            // All Restaurants Section
                            PartialViewHeader(
                              title: "All Restaurants",
                              onPressed: () {
                                // Navigate to all restaurants screen
                              },
                            ),
                            SizedBox(height: 15.h),

                            // Loading state for all restaurants
                            dashboardController.isLoadingRestaurants
                                ? Column(
                              children: List.generate(3, (index) =>
                                  _buildRestaurantSkeleton(),
                              ),
                            )
                                : dashboardController.getFilteredRestaurants().isEmpty
                                ? _buildEmptyRestaurantsState(dashboardController)
                                : Column(
                              children: List.generate(
                                dashboardController.getFilteredRestaurants().length,
                                    (i) => RestaurantContainer(
                                  restaurant: dashboardController.getFilteredRestaurants()[i],
                                  onPressed: () {
                                    dashboardController.navigateToRestaurant(
                                        dashboardController.getFilteredRestaurants()[i]
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyRestaurantsState(DashboardController controller) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant,
            size: 60.sp,
            color: AppColors.obscureTextColor.withOpacity(0.5),
          ),
          SizedBox(height: 15.h),
          customText(
            "No Restaurants Available",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 8.h),
          customText(
            "We're working on adding more restaurants to your area",
            fontSize: 14.sp,
            color: AppColors.obscureTextColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              controller.fetchRestaurants();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: customText(
              "Refresh",
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantSkeleton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      margin: EdgeInsets.only(right: 5.w, bottom: 10.h),
      width: 1.sw * 0.95,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180.sp,
            width: 1.sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.backgroundColor,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 16.h,
            width: 200.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: AppColors.backgroundColor,
            ),
          ),
          SizedBox(height: 5.h),
          Container(
            height: 12.h,
            width: 150.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: AppColors.backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final String image;
  final String name;
  final VoidCallback? onPressed;

  const CategoryContainer({
    super.key,
    this.name = "Lunch",
    this.image = PngAssets.food,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image, height: 65.sp, width: 65.sp),
            SizedBox(height: 5.h),
            customText(
              name,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}

class BrandsContainer extends StatelessWidget {
  final String image;
  final String name;
  final VoidCallback? onPressed;

  const BrandsContainer({
    super.key,
    this.name = "Brand",
    this.image = PngAssets.food,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(image, height: 80.sp, width: 80.sp),
            SizedBox(height: 8.h),
            customText(
              name,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}

// Update RestaurantContainer and FavRestaurantContainer to use API data
class RestaurantContainer extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onPressed;

  const RestaurantContainer({
    super.key,
    required this.restaurant,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            margin: EdgeInsets.only(right: 5.w, bottom: 10.h),
            width: 1.sw * 0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant image
                Container(
                  height: 180.sp,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.backgroundColor,
                    image: DecorationImage(
                      image: restaurant.banner != null && restaurant.banner!.isNotEmpty
                          ? NetworkImage(restaurant.banner!)
                          : restaurant.logo != null && restaurant.logo!.isNotEmpty
                          ? NetworkImage(restaurant.logo!)
                          : AssetImage("assets/images/placeholder.png") as ImageProvider,
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Handle image loading error
                      },
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Gradient overlay for better text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Featured badge
                      if (restaurant.isFeatured == 1)
                        Positioned(
                          top: 10.h,
                          right: 10.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: customText(
                              "Featured",
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),

                // Restaurant name and info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            restaurant.name,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            maxLines: 1,
                          ),
                          SizedBox(height: 3.h),
                          if (restaurant.cuisineType != null)
                            customText(
                              restaurant.cuisineType!,
                              fontSize: 12.sp,
                              color: AppColors.obscureTextColor,
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                    // Favorite button
                    InkWell(
                      onTap: () async {
                        await controller.toggleFavorite(restaurant);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        child: Icon(
                          controller.isFavorite(restaurant.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20.sp,
                          color: controller.isFavorite(restaurant.id)
                              ? Colors.red
                              : AppColors.obscureTextColor,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 5.h),

                // Status badges and contact info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Active status
                        if (restaurant.isActive == 1)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: customText(
                              "Open",
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        SizedBox(width: 6.w),
                        // Commission rate (you can show delivery fee instead)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: customText(
                            "₦${(double.parse(restaurant.commissionRate) * 10).toInt()} delivery",
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.obscureTextColor,
                          ),
                        ),
                      ],
                    ),
                    // Rating placeholder (since not in API yet)
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 12.sp,
                        ),
                        SizedBox(width: 2.w),
                        customText(
                          "4.5",
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FavRestaurantContainer extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onPressed;

  const FavRestaurantContainer({
    super.key,
    required this.restaurant,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return InkWell(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
            width: 1.sw * 0.87,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant banner/logo
                Container(
                  height: 180.sp,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.backgroundColor,
                    image: DecorationImage(
                      image: restaurant.banner != null && restaurant.banner!.isNotEmpty
                          ? NetworkImage(restaurant.banner!)
                          : restaurant.logo != null && restaurant.logo!.isNotEmpty
                          ? NetworkImage(restaurant.logo!)
                          : AssetImage("assets/images/placeholder.png") as ImageProvider,
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        // Handle image loading error
                      },
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Featured badge
                      if (restaurant.isFeatured == 1)
                        Positioned(
                          top: 10.h,
                          right: 10.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: customText(
                              "Featured",
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and favorite button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: customText(
                              restaurant.name,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                              maxLines: 1,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.toggleFavorite(restaurant);
                            },
                            child: Icon(
                              Icons.favorite,
                              size: 18.sp,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5.h),

                      // Description
                      if (restaurant.description != null)
                        customText(
                          restaurant.description!,
                          fontSize: 12.sp,
                          color: AppColors.obscureTextColor,
                          maxLines: 2,
                        ),

                      SizedBox(height: 8.h),

                      // Status and contact info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (restaurant.isActive == 1)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: customText(
                                    "Open",
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                            ],
                          ),
                          customText(
                            restaurant.phone,
                            fontSize: 10.sp,
                            color: AppColors.obscureTextColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
  }
}