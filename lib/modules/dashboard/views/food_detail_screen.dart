import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';
import 'package:gosharpsharp/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/modules/dashboard/views/widgets/addon_selection_bottom_sheet.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> with TickerProviderStateMixin {
  int quantity = 1;
  late TabController _tabController;
  bool isFavorite = false;

  late final DashboardController dashboardController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    dashboardController = Get.find<DashboardController>();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    final menuItem = dashboardController.selectedMenuItem;
    final maxQuantity = menuItem?.quantity ?? 99;
    if (quantity < maxQuantity) {
      setState(() {
        quantity++;
      });
    } else {
      showToast(
        message: "Maximum available quantity is $maxQuantity",
        isError: true,
      );
    }
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    showToast(
      message: isFavorite ? "Added to favorites" : "Removed from favorites",
      isError: false,
    );
  }

  void _addToCartAndShowSuccess(CartController cartController) async {
    final menuItem = dashboardController.selectedMenuItem;
    if (menuItem == null) return;

    await cartController.addToCart(menuItem.id, quantity);

    // Show success bottom sheet instead of dialog
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            customText(
              "Added to Cart!",
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 8.h),
            customText(
              "$quantity x ${menuItem.name} has been added to your cart",
              fontSize: 14.sp,
              color: AppColors.greyColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryColor),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: customText(
                      "Continue Shopping",
                      fontSize: 14.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Close the bottom sheet first
                      Get.back();
                      // Navigate to app navigation and set cart tab
                      Get.offNamedUntil(Routes.APP_NAVIGATION, (route) => false);
                      // Ensure the controller is available and set cart tab
                      Future.delayed(Duration(milliseconds: 100), () {
                        try {
                          final appNavController = Get.find<AppNavigationController>();
                          appNavController.changeScreenIndex(1);
                        } catch (e) {
                          print('Error setting cart tab: $e');
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: customText(
                      "View Cart",
                      fontSize: 14.sp,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  double _calculateTotalPrice(MenuItemModel? menuItem) {
    if (menuItem == null) return 0.0;
    return menuItem.price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        return GetBuilder<CartController>(
          builder: (cartController) {
            final menuItem = dashboardController.selectedMenuItem;

            if (menuItem == null) {
              return Scaffold(
                appBar: AppBar(title: Text("Food Details")),
                body: Center(
                  child: customText(
                    "No food item selected",
                    fontSize: 16.sp,
                    color: AppColors.obscureTextColor,
                  ),
                ),
              );
            }

            final isAvailable = dashboardController.isMenuItemAvailable(menuItem);
            final availabilityStatus = dashboardController.getMenuItemAvailabilityStatus(menuItem);
            final isCurrentlyAdding = cartController.isAddingItemToCart(menuItem.id);

            return Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Column(
                children: [
                  // Header Image with Back Button and Actions
                  Container(
                    height: 300.h,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: menuItem.files.isNotEmpty
                            ? NetworkImage(menuItem.files[0].url)
                            : AssetImage(PngAssets.chow1) as ImageProvider,
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // Handle image loading error
                        },
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Dark gradient overlay for better text visibility
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),

                        // Back button and actions
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
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppColors.blackColor,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Share functionality
                                      showToast(message: "Share functionality coming soon", isError: false);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.sp),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.share,
                                        color: AppColors.blackColor,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  InkWell(
                                    onTap: _toggleFavorite,
                                    child: Container(
                                      padding: EdgeInsets.all(8.sp),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : AppColors.blackColor,
                                        size: 20.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Food name overlay at bottom
                        Positioned(
                          bottom: 20.h,
                          left: 20.w,
                          right: 20.w,
                          child: Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  menuItem.name,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blackColor,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      child: customText(
                                        menuItem.category.name,
                                        fontSize: 12.sp,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (menuItem.plateSize != null && menuItem.plateSize!.isNotEmpty) ...[
                                      SizedBox(width: 8.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundColor,
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: customText(
                                          menuItem.plateSize!,
                                          fontSize: 12.sp,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Availability status indicator
                        if (!isAvailable)
                          Positioned(
                            top: 100.h,
                            right: 20.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: customText(
                                availabilityStatus,
                                fontSize: 12.sp,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Food Details Card
                  Expanded(
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.r),
                          topRight: Radius.circular(0.r),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),

                            // Price and Quick Info
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        "₦${menuItem.price.toStringAsFixed(2)}",
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor,
                                      ),
                                      customText(
                                        "per plate",
                                        fontSize: 12.sp,
                                        color: AppColors.obscureTextColor,
                                      ),
                                    ],
                                  ),
                                  if (menuItem.prepTimeMinutes!=null)
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundColor,
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            color: AppColors.obscureTextColor,
                                            size: 25.sp,
                                          ),
                                          SizedBox(width: 4.w),
                                          customText(
                                            "${menuItem.prepTimeMinutes} min(s)",
                                            fontSize: 14.sp,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Availability info
                            if (availabilityStatus != "Available")
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: availabilityStatus == "Limited Stock"
                                        ? Colors.orange.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: availabilityStatus == "Limited Stock"
                                            ? Colors.orange
                                            : Colors.red,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: customText(
                                          availabilityStatus == "Limited Stock"
                                              ? "Only ${menuItem.quantity} left in stock"
                                              : availabilityStatus,
                                          fontSize: 14.sp,
                                          color: availabilityStatus == "Limited Stock"
                                              ? Colors.orange
                                              : Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            SizedBox(height: 24.h),

                            // Restaurant Info
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20.r,
                                      backgroundColor: AppColors.primaryColor,
                                      backgroundImage: menuItem.restaurant.logo != null && menuItem.restaurant.logo!.isNotEmpty
                                          ? NetworkImage(menuItem.restaurant.logo!)
                                          : null,
                                      child: menuItem.restaurant.logo == null || menuItem.restaurant.logo!.isEmpty
                                          ? Text(
                                        menuItem.restaurant.name.isNotEmpty
                                            ? menuItem.restaurant.name[0].toUpperCase()
                                            : "R",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.whiteColor,
                                        ),
                                      )
                                          : null,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          customText(
                                            menuItem.restaurant.name,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor,
                                          ),
                                          if (menuItem.restaurant.cuisineType != null)
                                            customText(
                                              menuItem.restaurant.cuisineType!,
                                              fontSize: 12.sp,
                                              color: AppColors.obscureTextColor,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                            // Tabs (Details / Reviews)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: TabBar(
                                controller: _tabController,
                                labelColor: AppColors.blackColor,
                                unselectedLabelColor: AppColors.obscureTextColor,
                                indicatorColor: AppColors.primaryColor,
                                indicatorWeight: 3,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                unselectedLabelStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                tabs: [
                                  Tab(text: "Details"),
                                  Tab(text: "Reviews"),
                                ],
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Tab Content
                            Container(
                              height: 180.h,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // Details Tab
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          customText(
                                            "Description",
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackColor,
                                          ),
                                          SizedBox(height: 8.h),
                                          customText(
                                            menuItem.description ?? "No description available",
                                            fontSize: 14.sp,
                                            color: AppColors.obscureTextColor,
                                            height: 1.6,
                                          ),
                                          SizedBox(height: 16.h),
                                          // Additional details
                                          _buildDetailRow("Category", menuItem.category.name),
                                          SizedBox(height: 8.h),
                                          if (menuItem.plateSize != null && menuItem.plateSize!.isNotEmpty) ...[
                                            _buildDetailRow("Plate Size", menuItem.plateSize!),
                                            SizedBox(height: 8.h),
                                          ],
                                          // _buildDetailRow("Available Quantity", "${menuItem.quantity}"),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Reviews Tab
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // No reviews state
                                          Container(
                                            padding: EdgeInsets.all(20.w),
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.rate_review,
                                                  size: 48.sp,
                                                  color: AppColors.obscureTextColor.withOpacity(0.5),
                                                ),
                                                SizedBox(height: 12.h),
                                                customText(
                                                  "No Reviews Yet",
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.blackColor,
                                                ),
                                                SizedBox(height: 8.h),
                                                customText(
                                                  "Be the first to leave a review for this item",
                                                  fontSize: 14.sp,
                                                  color: AppColors.obscureTextColor,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),


                            // Cart Controls Section
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal:16.w,vertical: 5.h),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        customText(
                                          "Add to Cart",
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor,
                                        ),
                                        if (cartController.getItemQuantityInCart(menuItem.id) > 0)
                                          customText(
                                            "${cartController.getItemQuantityInCart(menuItem.id)} in cart",
                                            fontSize: 14.sp,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      ],
                                    ),
                                    _buildCartControls(menuItem, cartController, isAvailable, isCurrentlyAdding),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 100.h), // Extra padding for bottom button
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: cartController.getItemQuantityInCart(menuItem.id) > 0 ? Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: CustomButton(
                    width: double.infinity,
                    height: 56.h,
                    backgroundColor: AppColors.primaryColor,
                    title: "View Cart (${cartController.itemCount} items)",
                    onPressed: () {
                      Get.offNamedUntil(
                        Routes.APP_NAVIGATION,
                        (route) => false,
                        arguments: {'initialIndex': 1},
                      );
                    },
                    borderRadius: 12.r,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.whiteColor,
                  ),
                ),
              ) : null,
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          fontSize: 14.sp,
          color: AppColors.obscureTextColor,
        ),
        Flexible(
          child: customText(
            value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildCartControls(
    MenuItemModel menuItem,
    CartController cartController,
    bool isAvailable,
    bool isCurrentlyAdding,
  ) {
    int cartQuantity = cartController.getItemQuantityInCart(menuItem.id);

    if (!isAvailable) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.obscureTextColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: customText(
          "Unavailable",
          fontSize: 12.sp,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    if (cartQuantity == 0) {
      // Show plus button for items not in cart
      return InkWell(
        onTap: !isCurrentlyAdding
            ? () => _addToCart(menuItem, cartController)
            : null,
        child: Container(
          width: 32.w,
          height: 32.w,
          decoration: BoxDecoration(
            color: isCurrentlyAdding
                ? AppColors.obscureTextColor
                : AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: isCurrentlyAdding
              ? SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.whiteColor,
                    ),
                  ),
                )
              : Icon(
                  Icons.add,
                  color: AppColors.whiteColor,
                  size: 18.sp,
                ),
        ),
      );
    } else {
      // Show quantity controls for items in cart
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus/Remove button
          InkWell(
            onTap: () => _decreaseQuantity(menuItem, cartController, cartQuantity),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: cartQuantity == 1 ? Colors.red : AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                cartQuantity == 1 ? Icons.delete : Icons.remove,
                color: AppColors.whiteColor,
                size: 14.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Quantity display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: customText(
              cartQuantity.toString(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ),
          SizedBox(width: 8.w),
          // Plus button
          InkWell(
            onTap: () => _addToCart(menuItem, cartController),
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: AppColors.whiteColor,
                size: 14.sp,
              ),
            ),
          ),
        ],
      );
    }
  }

  void _addToCart(MenuItemModel menuItem, CartController cartController) async {
    try {
      // Check if menu item has addons
      if (menuItem.addonMenus != null && menuItem.addonMenus!.isNotEmpty) {
        // Show addon selection bottom sheet
        Get.bottomSheet(
          AddonSelectionBottomSheet(
            menuItem: menuItem,
            onAddToCart: (int? addonMenuId) async {
              await cartController.addToCart(menuItem.id, 1, addonMenuId: addonMenuId);
            },
          ),
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
        );
      } else {
        // No addons, add directly to cart
        await cartController.addToCart(menuItem.id, 1);
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

  void _decreaseQuantity(
    MenuItemModel menuItem,
    CartController cartController,
    int currentQuantity,
  ) async {
    try {
      await cartController.removeFromCart(menuItem.id);
    } catch (e) {
      debugPrint('Error decreasing quantity: $e');
    }
  }
}