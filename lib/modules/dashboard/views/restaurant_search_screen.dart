import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/widgets/skeleton_loaders.dart';

class RestaurantSearchScreen extends StatefulWidget {
  const RestaurantSearchScreen({super.key});

  @override
  State<RestaurantSearchScreen> createState() => _RestaurantSearchScreenState();
}

class _RestaurantSearchScreenState extends State<RestaurantSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ),
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
                      controller: _searchController,
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
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
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
                          if (_searchQuery.isEmpty) ...[
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
                              _searchQuery,
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

  Widget _buildRestaurantList(
    DashboardController controller,
    String query,
  ) {
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
            message.isNotEmpty
                ? message
                : "Pull down to refresh",
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

// Import the RestaurantContainer from dashboard_screen.dart
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
                      image: restaurant.bannerUrl != null &&
                              restaurant.bannerUrl!.isNotEmpty
                          ? NetworkImage(restaurant.bannerUrl!)
                          : restaurant.logoUrl != null &&
                                  restaurant.logoUrl!.isNotEmpty
                              ? NetworkImage(restaurant.logoUrl!)
                              : restaurant.banner != null &&
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
                      ],
                    ),
                    // Rating placeholder
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
