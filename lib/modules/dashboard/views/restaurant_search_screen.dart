import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/widgets/restaurant_container.dart';
import 'package:gosharpsharp/core/widgets/skeleton_loaders.dart';

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        return Scaffold(
          appBar: flatAppBar(
            bgColor: AppColors.backgroundColor,
            navigationColor: AppColors.backgroundColor,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Column(
            children: [
              // Search Bar Section
              Container(
                color: AppColors.backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Column(
                  children: [
                    // Title
                    Row(
                      children: [
                        customText(
                          "Search Restaurants",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blackColor,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    // Search Input
                    CustomOutlinedRoundedInputField(
                      controller: dashboardController.searchController,
                      borderRadius: 25.r,
                      isSearch: true,
                      prefixWidget: Icon(Icons.search, size: 25.sp),
                      onFieldSubmitted: (value) {
                        dashboardController.updateSearchQuery(value);
                      },
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
              // Results Section
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: AppColors.primaryColor,
                  color: AppColors.whiteColor,
                  onRefresh: () async {
                    await dashboardController.fetchRestaurants();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.sp,
                      horizontal: 10.sp,
                    ),
                    color: AppColors.backgroundColor,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show all restaurants when search is empty
                          if (dashboardController
                              .searchQuery
                              .value
                              .isEmpty) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              child: customText(
                                "All Restaurants",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ] else ...[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              child: customText(
                                "Search Results",
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],

                          // Loading State
                          if (dashboardController.isLoadingRestaurants)
                            SkeletonLoaders.restaurantCard(count: 5)
                          // Empty State
                          else if (dashboardController.restaurants.isEmpty)
                            _buildEmptyState(dashboardController)
                          // Restaurant List
                          else
                            _buildRestaurantList(
                              dashboardController,
                              dashboardController.searchQuery.value,
                            ),

                          SizedBox(height: 30.h),
                        ],
                      ),
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

  Widget _buildRestaurantList(DashboardController controller, String query) {
    // Filter restaurants based on search query
    List<RestaurantModel> filteredRestaurants = controller.restaurants;

    if (query.isNotEmpty) {
      filteredRestaurants = controller.restaurants.where((restaurant) {
        final name = restaurant.name.toLowerCase();
        final cuisine = restaurant.cuisineType?.toLowerCase() ?? '';
        final description = restaurant.description?.toLowerCase() ?? '';

        return name.contains(query) ||
            cuisine.contains(query) ||
            description.contains(query);
      }).toList();
    }

    // Show "no results" if search returned nothing
    if (filteredRestaurants.isEmpty && query.isNotEmpty) {
      return _buildNoResultsState(query);
    }

    return Column(
      children: List.generate(
        filteredRestaurants.length,
        (i) => RestaurantContainer(
          key: ValueKey('search_restaurant_${filteredRestaurants[i].id}'),
          restaurant: filteredRestaurants[i],
          onPressed: () {
            controller.navigateToRestaurant(filteredRestaurants[i]);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(DashboardController controller) {
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

  Widget _buildNoResultsState(String query) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60.sp,
            color: AppColors.obscureTextColor.withAlpha(127),
          ),
          SizedBox(height: 15.h),
          customText(
            "No Results Found",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          customText(
            "We couldn't find any restaurants matching \"$query\"",
            fontSize: 14.sp,
            color: AppColors.obscureTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
