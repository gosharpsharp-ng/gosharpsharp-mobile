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
                      ordersController.fetchDeliveries();
                      Get.find<WalletController>().getWalletBalance();
                      Get.find<WalletController>().getTransactions();
                      Get.find<SettingsController>().getProfile();
                      Get.find<NotificationsController>().getNotifications();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.sp,
                        horizontal: 10.sp,
                      ),
                      color: AppColors.backgroundColor,
                      child: RefreshIndicator(
                        backgroundColor: AppColors.primaryColor,
                        onRefresh: () async {
                          ordersController.fetchDeliveries();
                          Get.find<WalletController>().getWalletBalance();
                          Get.find<WalletController>().getTransactions();
                          Get.find<SettingsController>().getProfile();
                          Get.find<NotificationsController>()
                              .getNotifications();
                        },
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

                              // PartialViewHeader(
                              //   title: "Categories",
                              //   onPressed: () {
                              //     Get.toNamed(Routes.DELIVERIES_HOME);
                              //   },
                              // ),
                              Container(
                                width: 1.sw,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CategoryContainer(),
                                      CategoryContainer(name: "Breakfast"),
                                      CategoryContainer(name: "Grills"),
                                      CategoryContainer(name: "Snacks"),
                                      CategoryContainer(name: "Bakery"),
                                      CategoryContainer(name: "Ice cream"),
                                      CategoryContainer(name: "amala"),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.h),
                              ordersController.allDeliveries.isEmpty
                                  ? const SectionHeader(title: "Popular Brands")
                                  : PartialViewHeader(
                                      title: "Categories",
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
                                      CategoryContainer(
                                        name: "In-n-Out",
                                        image: PngAssets.inOutBrand,
                                      ),
                                      CategoryContainer(
                                        name: "Pizza-Hut",
                                        image: PngAssets.pizzaHutBrand,
                                      ),
                                      CategoryContainer(
                                        name: "Jonny Rockets",
                                        image: PngAssets.jonnyRocketsBrand,
                                      ),
                                      CategoryContainer(
                                        name: "Jonny Rockets",
                                        image: PngAssets.jonnyRocketsBrand,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.h),
                              PartialViewHeader(
                                title: "Top Restaurants",
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
                                      ...List.generate(
                                        dashboardController.restaurants.length,
                                            (i) => RestaurantContainer(
                                          restaurant: dashboardController.restaurants[i],
                                          onPressed: (){},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 15.h),
                              ...List.generate(
                                dashboardController.restaurants.length,
                                    (i) => RestaurantContainer(
                                  restaurant: dashboardController.restaurants[i],
                                  onPressed: (){},
                                ),
                              ),
                            ],
                          ),
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
}

class CategoryContainer extends StatelessWidget {
  final String image;
  final String name;
  final VoidCallbackAction? onPressed;
  const CategoryContainer({
    super.key,
    this.name = "Lunch",
    this.image = PngAssets.food,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class BrandsContainer extends StatelessWidget {
  final String image;
  final String name;
  final VoidCallbackAction? onPressed;
  const BrandsContainer({
    super.key,
    this.name = "Rice",
    this.image = PngAssets.food,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return InkWell(
          onTap: onPressed ??
                  () {
                // Navigate to restaurant detail screen
                controller.setSelectedRestaurant(restaurant);
                Get.to(() => RestaurantDetailScreen());
              },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            margin: EdgeInsets.only(right: 5.w, bottom: 10.h),
            width: 1.sw * 0.95,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Use logo or banner (if provided by API)
                Container(
                  height: 180.sp,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: restaurant.logo != null
                          ? NetworkImage(restaurant.logo!)
                          : const AssetImage("assets/images/placeholder.png")
                      as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                // ✅ Restaurant name
                customText(
                  restaurant.name,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),

                SizedBox(height: 5.h),

                // ✅ Status & commission (just as example badges)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Show "Active" if isActive == 1
                        if (restaurant.isActive == 1)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: customText(
                              "Active",
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        SizedBox(width: 6.w),

                        // Show "Featured" if isFeatured == 1
                        if (restaurant.isFeatured == 1)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: customText(
                              "Featured",
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          ),
                      ],
                    ),

                    // ✅ Favorite button
                    InkWell(
                      child: Icon(Icons.favorite_border, size: 18.sp),
                      onTap: () {
                        // add to favorites logic
                      },
                    ),
                  ],
                ),

                SizedBox(height: 5.h),

                // ✅ Show email / phone (since distance, deliveryTime not in API)
                customText(
                  "${restaurant.email} • ${restaurant.phone}",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blackColor,
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
          onTap: onPressed ??
                  () {
                controller.setSelectedRestaurant(restaurant);
                Get.to(() => RestaurantDetailScreen());
              },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            margin: EdgeInsets.only(right: 10.w, bottom: 10.h),
            width: 1.sw * 0.87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant banner/logo
                Container(
                  height: 180.sp,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: (restaurant.banner != null &&
                          restaurant.banner!.startsWith("http"))
                          ? NetworkImage(restaurant.banner!)
                          : (restaurant.logo != null &&
                          restaurant.logo!.startsWith("http"))
                          ? NetworkImage(restaurant.logo!)
                          : const AssetImage("assets/images/placeholder.png")
                      as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                // Name
                customText(
                  restaurant.name,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 5.h),

                // Details row (only showing active/featured for now)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (restaurant.isFeatured == 1)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: customText(
                              "Featured",
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                            ),
                          ),
                      ],
                    ),

                    // Favorite button (local state handled in controller)
                    InkWell(
                      onTap: () {
                        controller.toggleFavorite(restaurant);
                      },
                      child: Icon(
                        controller.isFavorite(restaurant.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18.sp,
                        color: controller.isFavorite(restaurant.id)
                            ? Colors.red
                            : AppColors.blackColor,
                      ),
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


