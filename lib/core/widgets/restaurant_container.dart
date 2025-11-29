import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

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
      init: Get.isRegistered<DashboardController>()
          ? Get.find<DashboardController>()
          : Get.put(DashboardController()),
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
                  height: 170.sp,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.backgroundColor,
                    image: DecorationImage(
                      image:
                          restaurant.bannerUrl != null &&
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
                      // Featured and Sponsored badges on the right
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (restaurant.isFeaturedBool)
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
                            if (restaurant.isSponsored)
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
                      // Discount overlay at bottom left
                      if (restaurant.topDiscount?.badgeText != null)
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
                              restaurant.topDiscount!.badgeText!,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      // // Free delivery badge at bottom right
                      // if (restaurant.freeDelivery)
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
                      // Restaurant badges overlay at top left
                      if (restaurant.badges != null &&
                          restaurant.badges!.isNotEmpty)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Wrap(
                            spacing: 4.w,
                            runSpacing: 4.h,
                            direction: Axis.horizontal,
                            children: restaurant.badges!.map((badge) {
                              return RestaurantBadgeChip(badge: badge);
                            }).toList(),
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
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            maxLines: 1,
                          ),
                          SizedBox(height: 3.h),
                          if (restaurant.cuisineType != null)
                            customText(
                              restaurant.cuisineType!,
                              fontSize: 15.sp,
                              color: AppColors.obscureTextColor,
                              maxLines: 1,
                            ),
                        ],
                      ),
                    ),
                    // Favorite button
                    InkWell(
                      onTap: () async {
                        await controller.toggleFavorite(restaurant, context);
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
                        // Delivery method chip (walk or bike) with free delivery indicator
                        Container(
                          margin: EdgeInsets.only(right: 5.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: restaurant.freeDelivery
                                ? AppColors.secondaryColor
                                : AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                controller.isRestaurantWalkable(restaurant)
                                    ? SvgAssets.walkIcon
                                    : SvgAssets.bikeIcon,
                                height: 16.sp,
                                width: 16.sp,
                                colorFilter: ColorFilter.mode(
                                  restaurant.freeDelivery
                                      ? AppColors.blackColor
                                      : AppColors.blackColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              if (restaurant.freeDelivery) ...[
                                SizedBox(width: 4.w),
                                customText(
                                  "Free delivery",
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
                          getOpeningHours(restaurant),
                          fontSize: 14.sp,
                        ),
                      ],
                    ),
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 15.sp),
                        SizedBox(width: 2.w),
                        customText(
                          restaurant.averageRating,
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
