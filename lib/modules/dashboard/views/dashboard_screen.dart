import 'dart:io';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/widgets/category_container.dart';
import 'package:gosharpsharp/core/widgets/filter_chip_widget.dart';
import 'package:gosharpsharp/core/widgets/restaurant_container.dart';
import 'package:gosharpsharp/modules/dashboard/views/widgets/food_type_bottom_sheet.dart';
import 'package:gosharpsharp/modules/dashboard/views/widgets/food_type_category_item.dart';
import 'package:gosharpsharp/core/widgets/skeleton_loaders.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:upgrader/upgrader.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: Get.isRegistered<DashboardController>()
          ? Get.find<DashboardController>()
          : Get.put(DashboardController()),
      builder: (dashboardController) {
        return GetBuilder<DeliveriesController>(
          init: Get.isRegistered<DeliveriesController>()
              ? Get.find<DeliveriesController>()
              : Get.put(DeliveriesController()),
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
                        horizontal: 5.w,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible:
                                            settingsController
                                                .userProfile
                                                ?.avatarUrl !=
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
                                                        ?.avatarUrl ??
                                                    '',
                                              ),
                                          radius: 18.r,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      // SizedBox(width: 8.sp),
                                      customText(
                                        "Hi ${settingsController.userProfile?.fname ?? ''}",
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
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
                                                    fontSize: 14.sp,
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
                                                          8
                                                      ? '8+'
                                                      : settingsController
                                                            .notifications
                                                            .length
                                                            .toString(),
                                                  fontSize: 14.sp,
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
                          vertical: 5.h,
                        ),
                        child: Column(
                          children: [
                            LocationDisplayWidget(
                              textColor: AppColors.blackColor,
                              iconColor: AppColors.blackColor,
                              fontSize: 13,
                            ),
                            SizedBox(height: 15.h),
                            GetBuilder<DashboardController>(
                              builder: (ctrl) {
                                return CustomOutlinedRoundedInputField(
                                  borderRadius: 25.r,
                                  isSearch: true,
                                  prefixWidget: Icon(Icons.search, size: 25.sp),
                                  controller: ctrl.searchController,
                                  onFieldSubmitted: (value) {
                                    ctrl.updateSearchQuery(value);
                                  },
                                );
                              },
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
                            await dashboardController.refreshData();
                            Get.find<SettingsController>().getProfile();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 0.sp,
                              horizontal: 10.sp,
                            ),
                            color: AppColors.whiteColor,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 5.h),

                                  // Categories Section with Icons

                                  // Food Type Categories Row (Menu Categories)
                                  GetBuilder<DashboardController>(
                                    builder: (ctrl) {
                                      if (ctrl.menuCategories.isEmpty) {
                                        return SizedBox.shrink();
                                      }
                                      return Column(
                                        children: [
                                          Container(
                                            width: 1.sw,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: ctrl.menuCategories
                                                    .map(
                                                      (
                                                        category,
                                                      ) => FoodTypeCategoryItem(
                                                        name: category.name,
                                                        imageUrl:
                                                            category.iconUrl,
                                                        isSelected:
                                                            ctrl
                                                                .selectedFoodType
                                                                .value ==
                                                            category.name,
                                                        onPressed: () {
                                                          ctrl.updateSelectedFoodType(
                                                            category.name,
                                                          );
                                                        },
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12.h),
                                        ],
                                      );
                                    },
                                  ),

                                  // Filter Chips Row
                                  Container(
                                    width: 1.sw,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                      ),
                                      child: Row(
                                        children: [
                                          // Discounts/Promotions filter
                                          FilterChipWidget(
                                            label: "Discounts",
                                            icon: Icons.local_offer_outlined,
                                            isSelected: dashboardController
                                                .hasDiscountFilter
                                                .value,
                                            onPressed: () {
                                              dashboardController
                                                  .toggleDiscountFilter();
                                            },
                                          ),
                                          // Free Delivery filter
                                          FilterChipWidget(
                                            label: "Free Delivery",
                                            icon: Icons.electric_bike_outlined,
                                            isSelected: dashboardController
                                                .hasFreeDeliveryFilter
                                                .value,
                                            onPressed: () {
                                              dashboardController
                                                  .toggleFreeDeliveryFilter();
                                            },
                                          ),
                                          // Food Type filter (opens bottomsheet)
                                          FilterChipWidget(
                                            label:
                                                dashboardController
                                                    .selectedFoodType
                                                    .value
                                                    .isEmpty
                                                ? "Food Type"
                                                : dashboardController
                                                      .selectedFoodType
                                                      .value,
                                            icon:
                                                Icons.restaurant_menu_outlined,
                                            isSelected: dashboardController
                                                .selectedFoodType
                                                .value
                                                .isNotEmpty,
                                            onPressed: () {
                                              showFoodTypeBottomSheet(
                                                context,
                                                dashboardController,
                                              );
                                            },
                                          ),
                                          // Clear all filters (only show if filters are active)
                                          if (dashboardController
                                              .hasActiveFilters)
                                            FilterChipWidget(
                                              label: "Clear All",
                                              icon: Icons.clear_all,
                                              isSelected: false,
                                              onPressed: () {
                                                dashboardController
                                                    .clearAllFilters();
                                              },
                                            ),
                                        ],
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
                                          height: 0.h,
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

                                  // Top Restaurants Section - Only show if has top-rated restaurants
                                  if (dashboardController
                                      .getTopRatedRestaurants()
                                      .isNotEmpty) ...[
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
                                        : Container(
                                            width: 1.sw,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ...dashboardController
                                                      .getTopRatedRestaurants()
                                                      .take(5)
                                                      .map(
                                                        (
                                                          restaurant,
                                                        ) => RestaurantContainer(
                                                          key: ValueKey(
                                                            'top_restaurant_${restaurant.id}',
                                                          ),
                                                          restaurant:
                                                              restaurant,
                                                          onPressed: () {
                                                            dashboardController
                                                                .navigateToRestaurant(
                                                                  restaurant,
                                                                );
                                                          },
                                                        ),
                                                      ),
                                                ],
                                              ),
                                            ),
                                          ),
                                    SizedBox(height: 20.h),
                                  ],

                                  // Favourites Section - Only show if has favourites and no filters active
                                  if (dashboardController
                                          .favoriteRestaurants
                                          .isNotEmpty &&
                                      !dashboardController
                                          .hasActiveFilters) ...[
                                    SizedBox(height: 0.h),

                                    // Favourites Header
                                    SectionHeader(title: "Favourites"),
                                    SizedBox(height: 10.h),

                                    // Favourite restaurants list
                                    Container(
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
                                              (i) => FavRestaurantContainer(
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

                                  // Top Restaurants Section - Only show if there are featured/sponsored restaurants
                                  if (dashboardController.restaurants
                                      .where(
                                        (r) =>
                                            r.isFeaturedBool || r.isSponsored,
                                      )
                                      .isNotEmpty) ...[
                                    SizedBox(height: 25.h),
                                    SectionHeader(title: "Top Restaurants"),
                                    SizedBox(height: 10.h),

                                    // Loading state or top restaurants list
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
                                                  5,
                                                  (index) => Container(
                                                    width: 300.w,
                                                    height: 280.h,
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
                                            height: 280.h,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5.w,
                                              ),
                                              child: Row(
                                                children: [
                                                  ...List.generate(
                                                    dashboardController
                                                        .restaurants
                                                        .where(
                                                          (r) =>
                                                              r.isFeaturedBool ||
                                                              r.isSponsored,
                                                        )
                                                        .take(10)
                                                        .length,
                                                    (i) {
                                                      final topRestaurants =
                                                          dashboardController
                                                              .restaurants
                                                              .where(
                                                                (r) =>
                                                                    r.isFeaturedBool ||
                                                                    r.isSponsored,
                                                              )
                                                              .take(10)
                                                              .toList();
                                                      return Container(
                                                        width: 300.w,
                                                        margin: EdgeInsets.only(
                                                          right: 10.w,
                                                        ),
                                                        child: RestaurantContainer(
                                                          key: ValueKey(
                                                            'top_restaurant_${topRestaurants[i].id}',
                                                          ),
                                                          restaurant:
                                                              topRestaurants[i],
                                                          onPressed: () {
                                                            dashboardController
                                                                .navigateToRestaurant(
                                                                  topRestaurants[i],
                                                                );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),

                                    SizedBox(height: 25.h),
                                  ],
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
          !controller.hasValidLocation()
              ? Icon(
                  Icons.location_off,
                  size: 60.sp,
                  color: AppColors.obscureTextColor.withAlpha(127),
                )
              : SvgPicture.asset(
                  SvgAssets.restaurantIcon,
                  height: 60.sp,
                  width: 60.sp,
                  colorFilter: ColorFilter.mode(
                    AppColors.obscureTextColor.withAlpha(127),
                    BlendMode.srcIn,
                  ),
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
            message.isNotEmpty ? message : "Pull down to refresh",
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: customText(
                "Enable Location",
                fontSize: 15.sp,
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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: customText(
                "Select Delivery Address",
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () async {
                await controller.fetchRestaurants();
              },
              icon: Icon(
                Icons.refresh_rounded,
                color: AppColors.blackColor,
                size: 20.sp,
              ),
              label: customText(
                "Refresh",
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellowColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
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
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  ClipOval(
                    child:
                        (restaurant.logoUrl != null &&
                                restaurant.logoUrl!.isNotEmpty) ||
                            (restaurant.logo != null &&
                                restaurant.logo!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: restaurant.logoUrl ?? restaurant.logo!,
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
                          color: Colors.black.withValues(alpha: 0.7),
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
                fontSize: 14.sp,
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
      init: Get.isRegistered<DashboardController>()
          ? Get.find<DashboardController>()
          : Get.put(DashboardController()),
      builder: (controller) {
        return InkWell(
          onTap: restaurantOpen ? onPressed : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            margin: EdgeInsets.only(right: 5.w, bottom: 10.h),
            width: 1.sw * 0.88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant image
                Container(
                  height: 170.sp,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.backgroundColor,
                    image: DecorationImage(
                      image:
                          favourite.favoritable?.bannerUrl != null &&
                              favourite.favoritable!.bannerUrl!.isNotEmpty
                          ? NetworkImage(favourite.favoritable!.bannerUrl!)
                          : favourite.favoritable!.logoUrl != null &&
                                favourite.favoritable!.logoUrl!.isNotEmpty
                          ? NetworkImage(favourite.favoritable!.logoUrl!)
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
                                Colors.black.withValues(alpha: 0.3),
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
                              color: Colors.black.withValues(alpha: 0.7),
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
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.whiteColor,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      // Restaurant badges overlay at top left
                      if (favourite.favoritable != null &&
                          favourite.favoritable!.badges != null &&
                          favourite.favoritable!.badges!.isNotEmpty)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Wrap(
                            spacing: 4.w,
                            runSpacing: 4.h,
                            direction: Axis.vertical,
                            children: favourite.favoritable!.badges!.map((
                              badge,
                            ) {
                              return RestaurantBadgeChip(badge: badge);
                            }).toList(),
                          ),
                        ),
                      // Discount overlay at bottom left
                      if (favourite.favoritable != null &&
                          favourite.favoritable!.discountBadgeText != null)
                        Positioned(
                          bottom: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.redColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: customText(
                              favourite.favoritable!.discountBadgeText!,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      // Free delivery badge at bottom right
                      // if (favourite.favoritable != null &&
                      //     favourite.favoritable!.freeDelivery)
                      //   Positioned(
                      //     bottom: 8.h,
                      //     right: 8.w,
                      //     child: Container(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: 10.w,
                      //         vertical: 6.h,
                      //       ),
                      //       decoration: BoxDecoration(
                      //         color: AppColors.greenColor,
                      //         borderRadius: BorderRadius.circular(6.r),
                      //       ),
                      //       child: Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Icon(
                      //             Icons.electric_bike,
                      //             size: 15.sp,
                      //             color: AppColors.whiteColor,
                      //           ),
                      //           SizedBox(width: 4.w),
                      //           customText(
                      //             "FREE DELIVERY",
                      //             fontSize: 14.sp,
                      //             fontWeight: FontWeight.w700,
                      //             color: AppColors.whiteColor,
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // Featured and Sponsored badges on the right
                      if (favourite.favoritable != null)
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (favourite.favoritable!.isFeaturedBool)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: customText(
                                    "FEATURED",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              if (favourite.favoritable!.isSponsored)
                                Container(
                                  margin: EdgeInsets.only(top: 4.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.amberColor,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: customText(
                                    "SPONSORED",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                            ],
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
                            favourite.favoritable!.name.capitalizeFirst ?? favourite.favoritable!.name,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            maxLines: 1,
                          ),
                          SizedBox(height: 3.h),
                          if (favourite.favoritable!.cuisineType != null)
                            customText(
                              favourite.favoritable!.cuisineType!.capitalizeFirst ?? favourite.favoritable!.cuisineType!,
                              fontSize: 14.sp,
                              color: AppColors.obscureTextColor,
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                    // Favorite button
                    InkWell(
                      onTap: () async {
                        await controller.toggleFavorite(
                          favourite.favoritable!,
                          context,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        child: Icon(
                          Icons.favorite,
                          size: 22.sp,
                          color: AppColors.redColor,
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
                        // Delivery method chip (walk or bike) with free delivery indicator
                        Container(
                          margin: EdgeInsets.only(right: 5.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                controller.isFavouriteRestaurantWalkable(
                                      favourite,
                                    )
                                    ? SvgAssets.walkIcon
                                    : SvgAssets.bikeIcon,
                                height: 16.sp,
                                width: 16.sp,
                                colorFilter: ColorFilter.mode(
                                  AppColors.blackColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              if (favourite.favoritable?.hasFreeDelivery ==
                                  true) ...[
                                SizedBox(width: 4.w),
                                customText(
                                  "Free",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Active status based on schedule
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 6.w,
                        //     vertical: 2.h,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: restaurantOpen
                        //         ? AppColors.primaryColor.withAlpha(80)
                        //         : AppColors.redColor.withAlpha(80),
                        //     borderRadius: BorderRadius.circular(4.r),
                        //   ),
                        //   child: customText(
                        //     restaurantOpen ? "Open" : "Closed",
                        //     fontSize: 14.sp,
                        //     fontWeight: FontWeight.w500,
                        //     color: restaurantOpen
                        //         ? AppColors.primaryColor
                        //         : AppColors.redColor,
                        //   ),
                        // ),
                        SizedBox(width: 6.w),
                        customText(
                          favourite.favoritable!.prepTime ?? "",
                          //  getOpeningHours(favourite.favoritable!),
                          fontSize: 14.sp,
                        ),
                      ],
                    ),
                    // Rating placeholder (since not in API yet)
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 15.sp),
                        SizedBox(width: 2.w),
                        customText(
                          favourite.favoritable?.formattedRating ?? "0",
                          fontSize: 14.sp,
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
