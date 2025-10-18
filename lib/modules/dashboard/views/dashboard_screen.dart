import 'dart:io';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/widgets/skeleton_loaders.dart';
import 'package:skeletonizer/skeletonizer.dart';
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GetBuilder<AppNavigationController>(
                            builder: (navController) {
                              return IconButton(
                                icon: Icon(Icons.arrow_back, size: 24.sp),
                                onPressed: () {
                                  navController.toggleToRestaurantView();
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              );
                            },
                          ),

                          Expanded(
                            flex: 2,
                            child: GetBuilder<SettingsController>(
                              builder: (settingsController) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 5.sp,
                                  ),
                                  color: AppColors.transparent,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
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
                                      SizedBox(width: 5.w),
                                      // SizedBox(width: 8.sp),
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
                          ),
                          Expanded(
                            flex: 2,
                            child: GetBuilder<SettingsController>(
                              builder: (settingsController) {
                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      splashColor: AppColors.transparent,
                                      highlightColor: AppColors.transparent,
                                      onTap: () {
                                        // Get or create NotificationsController and fetch notifications
                                        final notificationsController = Get.put(
                                          NotificationsController(),
                                        );
                                        notificationsController
                                            .getNotifications();
                                        Get.toNamed(Routes.NOTIFICATIONS_HOME);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5.sp,
                                        ),
                                        child:
                                            settingsController
                                                .isLoadingNotification
                                            ? Skeletonizer(
                                                enabled: true,
                                                child: Badge(
                                                  textColor:
                                                      AppColors.whiteColor,
                                                  backgroundColor:
                                                      AppColors.redColor,
                                                  isLabelVisible: true,
                                                  label: customText(
                                                    '0',
                                                    fontSize: 12.sp,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    SvgAssets.notificationIcon,
                                                    color: AppColors
                                                        .obscureTextColor,
                                                    height: 20.sp,
                                                    width: 20.sp,
                                                  ),
                                                ),
                                              )
                                            : Badge(
                                                textColor: AppColors.whiteColor,
                                                backgroundColor:
                                                    AppColors.redColor,
                                                isLabelVisible:
                                                    settingsController
                                                        .notifications
                                                        .isNotEmpty,
                                                label: customText(
                                                  settingsController
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
                                                  color: AppColors
                                                      .obscureTextColor,
                                                  height: 20.sp,
                                                  width: 20.sp,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    InkWell(
                                      splashColor: AppColors.transparent,
                                      highlightColor: AppColors.transparent,
                                      onTap: () {
                                        dashboardController
                                            .toggleWalkingDistanceFilter();
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
                                        margin: EdgeInsets.only(left: 5.w),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    dashboardController
                                                        .isWalkingDistanceFilter
                                                        .value
                                                    ? AppColors.primaryColor
                                                    : AppColors.secondaryColor,
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
                                                colorFilter: ColorFilter.mode(
                                                  dashboardController
                                                          .isWalkingDistanceFilter
                                                          .value
                                                      ? AppColors.whiteColor
                                                      : AppColors.blackColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color:
                                                    dashboardController
                                                        .isWalkingDistanceFilter
                                                        .value
                                                    ? AppColors.secondaryColor
                                                    : AppColors.primaryColor,
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
                                                  dashboardController
                                                          .isWalkingDistanceFilter
                                                          .value
                                                      ? AppColors.blackColor
                                                      : AppColors.whiteColor,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  body: Column(
                    children: [
                      // Fixed location widget and search
                      Container(
                        color: AppColors.backgroundColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        child: Column(
                          children: [
                            LocationDisplayWidget(
                              textColor: AppColors.blackColor,
                              iconColor: AppColors.blackColor,
                              fontSize: 13,
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
                                  color: AppColors.primaryColor.withAlpha(180),
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
                          ],
                        ),
                      ),
                      // Scrollable content
                      Expanded(
                        child: RefreshIndicator(
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

                                  // // Categories Section
                                  Container(
                                    width: 1.sw,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: dashboardController.categories
                                            .map(
                                              (category) => CategoryContainer(
                                                name: category,
                                                onPressed: () {
                                                  dashboardController
                                                      .updateSelectedCategory(
                                                        category,
                                                      );
                                                },
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.h),

                                  // Popular Brands Section
                                  dashboardController.restaurants
                                          .where(
                                            (restaurant) =>
                                                restaurant.isFeatured == 1,
                                          )
                                          .isNotEmpty
                                      ? const SectionHeader(
                                          title: "Popular Brands",
                                        )
                                      : SizedBox.shrink(),

                                  SizedBox(height: 10.h),
                                  dashboardController.isLoadingRestaurants
                                      ? Container(
                                          height: 120.h,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: List.generate(
                                                4,
                                                (index) => Container(
                                                  width: 100.w,
                                                  margin: EdgeInsets.only(
                                                    right: 10.w,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 80.sp,
                                                        height: 80.sp,
                                                        decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: AppColors
                                                              .backgroundColor,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.h),
                                                      Container(
                                                        height: 12.h,
                                                        width: 70.w,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4.r,
                                                              ),
                                                          color: AppColors
                                                              .backgroundColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 1.sw,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: dashboardController
                                                  .restaurants
                                                  .where(
                                                    (restaurant) =>
                                                        restaurant.isFeatured ==
                                                        1,
                                                  )
                                                  .take(6)
                                                  .map(
                                                    (
                                                      restaurant,
                                                    ) => BrandsContainer(
                                                      restaurant: restaurant,
                                                      onPressed: () {
                                                        dashboardController
                                                            .navigateToRestaurant(
                                                              restaurant,
                                                            );
                                                      },
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                  SizedBox(height: 5.h),

                                  // Top Restaurants Section
                                  SectionHeader(title: "Top Restaurants"),
                                  SizedBox(height: 10.h),
                                  // Loading state for top restaurants
                                  dashboardController.isLoadingRestaurants
                                      ? Container(
                                          height: 280.h,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                            ),
                                            child: Row(
                                              children: List.generate(
                                                3,
                                                (index) => Container(
                                                  width: 1.sw * 0.85,
                                                  margin: EdgeInsets.only(
                                                    right: 10.w,
                                                  ),
                                                  child:
                                                      SkeletonLoaders.restaurantCard(
                                                        count: 1,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : dashboardController.restaurants.isEmpty
                                      ? _buildEmptyRestaurantsState(
                                          dashboardController,
                                        )
                                      : Container(
                                          width: 1.sw,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ...List.generate(
                                                  dashboardController
                                                      .restaurants
                                                      .take(5)
                                                      .length,
                                                  (i) => RestaurantContainer(
                                                    key: ValueKey(
                                                      'top_restaurant_${dashboardController.restaurants[i].id}',
                                                    ),
                                                    restaurant:
                                                        dashboardController
                                                            .restaurants[i],
                                                    onPressed: () {
                                                      dashboardController
                                                          .navigateToRestaurant(
                                                            dashboardController
                                                                .restaurants[i],
                                                          );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                  SizedBox(height: 25.h),

                                  // Favourites Section - Only show if loading or has favourites
                                  if (dashboardController.isLoadingFavorites ||
                                      dashboardController
                                          .favoriteRestaurants
                                          .isNotEmpty) ...[
                                    SizedBox(height: 25.h),

                                    // Favourites Header
                                    SectionHeader(title: "Favourites"),
                                    SizedBox(height: 10.h),

                                    // Loading state or favourite restaurants list
                                    dashboardController.isLoadingFavorites
                                        ? Container(
                                            height: 280.h,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5.w,
                                              ),
                                              child: Row(
                                                children: List.generate(
                                                  3,
                                                  (index) => Container(
                                                    width: 1.sw * 0.85,
                                                    margin: EdgeInsets.only(
                                                      right: 10.w,
                                                    ),
                                                    child:
                                                        SkeletonLoaders.restaurantCard(
                                                          count: 1,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 1.sw,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ...List.generate(
                                                    dashboardController
                                                        .favoriteRestaurants
                                                        .take(5)
                                                        .length,
                                                    (
                                                      i,
                                                    ) => FavRestaurantContainer(
                                                      favourite: dashboardController
                                                          .favoriteRestaurants[i],
                                                      onPressed: () {
                                                        dashboardController
                                                            .navigateToRestaurant(
                                                              dashboardController
                                                                  .favoriteRestaurants[i]
                                                                  .favoritable!,
                                                            );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  ],
                                  SizedBox(height: 25.h),
                                  // All Restaurants Section
                                  // SectionHeader(title: "All Restaurants"),
                                  // SizedBox(height: 15.h),

                                  // Loading state for all restaurants
                                  Builder(
                                    builder: (context) {
                                      if (dashboardController
                                          .isLoadingRestaurants) {
                                        return SkeletonLoaders.restaurantCard(
                                          count: 3,
                                        );
                                      }

                                      final filteredRestaurants =
                                          dashboardController
                                              .getFilteredRestaurants();
                                      if (filteredRestaurants.isEmpty) {
                                        return _buildEmptyRestaurantsState(
                                          dashboardController,
                                        );
                                      }

                                      return Column(
                                        children: List.generate(
                                          filteredRestaurants.length,
                                          (i) => RestaurantContainer(
                                            key: ValueKey(
                                              'restaurant_${filteredRestaurants[i].id}',
                                            ),
                                            restaurant: filteredRestaurants[i],
                                            onPressed: () {
                                              dashboardController
                                                  .navigateToRestaurant(
                                                    filteredRestaurants[i],
                                                  );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              ),
                            ),
                          ),
                          // child:Container(),
                        ),
                      ),
                    ],
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
    String message = controller.getLocationStatusMessage();
    bool showLocationPicker =
        !controller.hasValidLocation() || !controller.shouldShowRestaurants();

    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            !controller.hasValidLocation()
                ? Icons.location_off
                : Icons.restaurant,
            size: 60.sp,
            color: AppColors.obscureTextColor.withAlpha(127),
          ),
          SizedBox(height: 15.h),
          customText(
            !controller.hasValidLocation()
                ? "Location Required"
                : !controller.shouldShowRestaurants()
                ? "Service Not Available"
                : "No Restaurants Available",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          customText(
            message.isNotEmpty
                ? message
                : "We're working on adding more restaurants to your area",
            fontSize: 14.sp,
            color: AppColors.obscureTextColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          if (showLocationPicker && !controller.hasValidLocation())
            ElevatedButton(
              onPressed: () {
                controller.refreshCurrentLocation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: customText(
                "Enable Location",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            )
          else if (!controller.shouldShowRestaurants())
            ElevatedButton(
              onPressed: () {
                controller.openLocationPicker();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: customText(
                "Select Delivery Address",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            )
          else
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
  final RestaurantModel restaurant;
  final VoidCallback? onPressed;

  const BrandsContainer({super.key, required this.restaurant, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final bool restaurantOpen = isRestaurantOpen(restaurant);

    return InkWell(
      onTap: restaurantOpen ? onPressed : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Restaurant logo
            Container(
              width: 80.sp,
              height: 80.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundColor,
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  ClipOval(
                    child:
                        restaurant.logo != null && restaurant.logo!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: restaurant.logo!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppColors.backgroundColor,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: customText(
                                restaurant.name.isNotEmpty
                                    ? restaurant.name[0].toUpperCase()
                                    : "R",
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        : Center(
                            child: customText(
                              restaurant.name.isNotEmpty
                                  ? restaurant.name[0].toUpperCase()
                                  : "R",
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                  ),
                  // Closed overlay
                  if (!restaurantOpen)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.7),
                        ),
                        child: Center(
                          child: customText(
                            "Closed",
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            // Restaurant name
            SizedBox(
              width: 90.w,
              child: customText(
                restaurant.name,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
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
    final bool restaurantOpen = isRestaurantOpen(restaurant);

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return InkWell(
          onTap: onPressed,
          // onTap: restaurantOpen ? onPressed : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            margin: EdgeInsets.only(right: 5.w, bottom: 10.h),
            width: 1.sw * 0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant image
                Container(
                  height: 200.sp,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.backgroundColor,
                    image: DecorationImage(
                      image:
                          restaurant.banner != null &&
                              restaurant.banner!.isNotEmpty
                          ? NetworkImage(restaurant.banner!)
                          : restaurant.logo != null &&
                                restaurant.logo!.isNotEmpty
                          ? NetworkImage(restaurant.logo!)
                          : AssetImage("assets/images/placeholder.png")
                                as ImageProvider,
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
                      // Closed overlay
                      if (!restaurantOpen)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customText(
                                    "Closed",
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
                                  ),
                                  SizedBox(height: 5.h),
                                  customText(
                                    getNextOpeningTime(restaurant),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.whiteColor,
                                    textAlign: TextAlign.center,
                                  ),
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
                          size: 22.sp,
                          color: controller.isFavorite(restaurant.id)
                              ? AppColors.redColor
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
                        Container(
                          margin: EdgeInsets.only(right: 5.w),
                          child: controller.isRestaurantWalkable(restaurant)
                              ? SvgPicture.asset(
                                  SvgAssets.walkIcon,
                                  height: 15.sp,
                                  width: 15.sp,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.blackColor,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  SvgAssets.bikeIcon,
                                  height: 15.sp,
                                  width: 15.sp,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.blackColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                        ),

                        // Active status based on schedule
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: restaurantOpen
                                ? AppColors.primaryColor.withAlpha(80)
                                : AppColors.redColor.withAlpha(80),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: customText(
                            restaurantOpen ? "Open" : "Closed",
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: restaurantOpen
                                ? AppColors.primaryColor
                                : AppColors.redColor,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        customText(
                          getOpeningHours(restaurant),
                          fontSize: 10.sp,
                        ),
                        // SizedBox(width: 6.w),
                        // // Commission rate (you can show delivery fee instead)
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 6.w,
                        //     vertical: 2.h,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: AppColors.backgroundColor,
                        //     borderRadius: BorderRadius.circular(4.r),
                        //   ),
                        //   child: customText(
                        //     "₦${(double.parse(restaurant.commissionRate) * 10).toInt()} delivery",
                        //     fontSize: 10.sp,
                        //     fontWeight: FontWeight.w500,
                        //     color: AppColors.obscureTextColor,
                        //   ),
                        // ),
                      ],
                    ),
                    // Rating placeholder (since not in API yet)
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 12.sp),
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
  final FavouriteRestaurantModel favourite;
  final VoidCallback? onPressed;

  const FavRestaurantContainer({
    super.key,
    required this.favourite,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool restaurantOpen = favourite.favoritable != null
        ? isRestaurantOpen(favourite.favoritable!)
        : false;

    return GetBuilder<DashboardController>(
      builder: (controller) {
        return InkWell(
          onTap: restaurantOpen ? onPressed : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            margin: EdgeInsets.only(right: 5.w, bottom: 10.h),
            width: 1.sw * 0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant image
                Container(
                  height: 200.sp,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.backgroundColor,
                    image: DecorationImage(
                      image:
                          favourite.favoritable?.banner != null &&
                              favourite.favoritable!.banner!.isNotEmpty
                          ? NetworkImage(favourite.favoritable!.banner!)
                          : favourite.favoritable!.logo != null &&
                                favourite.favoritable!.logo!.isNotEmpty
                          ? NetworkImage(favourite.favoritable!.logo!)
                          : AssetImage("assets/images/placeholder.png")
                                as ImageProvider,
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
                      // Closed overlay
                      if (!restaurantOpen && favourite.favoritable != null)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  customText(
                                    "Closed",
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
                                  ),
                                  SizedBox(height: 5.h),
                                  customText(
                                    getNextOpeningTime(favourite.favoritable!),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.whiteColor,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      // Featured badge
                      if (favourite.favoritable?.isFeatured == 1)
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
                            favourite.favoritable!.name,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            maxLines: 1,
                          ),
                          SizedBox(height: 3.h),
                          if (favourite.favoritable!.cuisineType != null)
                            customText(
                              favourite.favoritable!.cuisineType!,
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
                        await controller.toggleFavorite(favourite.favoritable!);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        child: Icon(
                          controller.isFavorite(favourite.favoritable!.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 22.sp,
                          color:
                              controller.isFavorite(favourite.favoritable!.id)
                              ? AppColors.redColor
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
                        Container(
                          margin: EdgeInsets.only(right: 5.w),
                          child:
                              controller.isFavouriteRestaurantWalkable(
                                favourite,
                              )
                              ? SvgPicture.asset(
                                  SvgAssets.walkIcon,
                                  height: 15.sp,
                                  width: 15.sp,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.blackColor,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : SvgPicture.asset(
                                  SvgAssets.bikeIcon,
                                  height: 15.sp,
                                  width: 15.sp,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.blackColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                        ),

                        // Active status based on schedule
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: restaurantOpen
                                ? AppColors.primaryColor.withAlpha(80)
                                : AppColors.redColor.withAlpha(80),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: customText(
                            restaurantOpen ? "Open" : "Closed",
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: restaurantOpen
                                ? AppColors.primaryColor
                                : AppColors.redColor,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        customText(
                          getOpeningHours(favourite.favoritable!),
                          fontSize: 10.sp,
                        ),
                        // SizedBox(width: 6.w),
                        // // Commission rate (you can show delivery fee instead)
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 6.w,
                        //     vertical: 2.h,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: AppColors.backgroundColor,
                        //     borderRadius: BorderRadius.circular(4.r),
                        //   ),
                        //   child: customText(
                        //     "₦${(double.parse(restaurant.commissionRate) * 10).toInt()} delivery",
                        //     fontSize: 10.sp,
                        //     fontWeight: FontWeight.w500,
                        //     color: AppColors.obscureTextColor,
                        //   ),
                        // ),
                      ],
                    ),
                    // Rating placeholder (since not in API yet)
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 12.sp),
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
