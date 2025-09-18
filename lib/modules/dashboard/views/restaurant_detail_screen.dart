import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/dashboard/views/food_detail_screen.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  String selectedCategory = 'All';

  // Get controllers using Get.find() to avoid initialization issues
  late final DashboardController dashboardController;
  late final CartController cartController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    dashboardController = Get.find<DashboardController>();
    cartController = Get.find<CartController>();

    // Fetch menu items when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (dashboardController.selectedRestaurant != null) {
        dashboardController.fetchRestaurantMenus(
          dashboardController.selectedRestaurant!.id.toString(),
        );
        // Also fetch menu categories
        dashboardController.fetchMenuCategories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (dashboardController) {
        return GetBuilder<CartController>(
          builder: (cartController) {
            final restaurant = dashboardController.selectedRestaurant;

            if (restaurant == null) {
              return Scaffold(
                appBar: AppBar(title: Text("Restaurant Details")),
                body: Center(
                  child: customText(
                    "No restaurant selected",
                    fontSize: 16.sp,
                    color: AppColors.obscureTextColor,
                  ),
                ),
              );
            }

            return Scaffold(
              backgroundColor: AppColors.backgroundColor,
              body: Column(
                children: [
                  // Header Image with Back Button and Menu
                  _buildHeader(restaurant, cartController, dashboardController),

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
                            _buildRestaurantInfo(restaurant),

                            SizedBox(height: 20.h),

                            // Contact Info and Status
                            _buildContactInfo(restaurant),

                            SizedBox(height: 30.h),

                            // Category Tabs
                            _buildCategoryTabs(),

                            SizedBox(height: 20.h),

                            // Menu Section Header
                            _buildMenuHeader(dashboardController),

                            SizedBox(height: 15.h),

                            // Menu Items
                            _buildMenuItems(
                              dashboardController,
                              cartController,
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
      },
    );
  }

  Widget _buildHeader(
    RestaurantModel restaurant,
    CartController cartController,
    DashboardController dashboardController,
  ) {
    return Container(
      height: 300.h,
      width: 1.sw,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: restaurant.banner != null && restaurant.banner!.isNotEmpty
              ? NetworkImage(restaurant.banner!)
              : restaurant.logo != null && restaurant.logo!.isNotEmpty
              ? NetworkImage(restaurant.logo!)
              : AssetImage('assets/images/default_restaurant_banner.png')
                    as ImageProvider,
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            // Fallback to default image on error
          },
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
                  onTap: () {
                    Navigator.of(context).pop();
                  },
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
                Row(
                  children: [
                    // Cart icon with badge
                    InkWell(
                      onTap: () => Get.toNamed(Routes.CART_SCREEN),
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          children: [
                            Icon(
                              Icons.shopping_cart,
                              color: AppColors.whiteColor,
                              size: 20.sp,
                            ),
                            if (cartController.itemCount > 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    cartController.itemCount > 99
                                        ? '99+'
                                        : cartController.itemCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: () =>
                          _toggleFavorite(restaurant, dashboardController),
                      child: Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          dashboardController.isFavorite(restaurant.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: dashboardController.isFavorite(restaurant.id)
                              ? Colors.red
                              : AppColors.whiteColor,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
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
                    AppColors.primaryColor.withAlpha(200),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(
                      restaurant.name,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                    SizedBox(height: 8.h),
                    if (restaurant.cuisineType != null)
                      customText(
                        restaurant.cuisineType!,
                        fontSize: 16.sp,
                        color: AppColors.whiteColor.withOpacity(0.9),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo(RestaurantModel restaurant) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.primaryColor,
            backgroundImage:
                restaurant.logo != null && restaurant.logo!.isNotEmpty
                ? NetworkImage(restaurant.logo!)
                : null,
            child: restaurant.logo == null || restaurant.logo!.isEmpty
                ? Text(
                    restaurant.name.isNotEmpty
                        ? restaurant.name[0].toUpperCase()
                        : "R",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  restaurant.name,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 8.h),
                customText(
                  restaurant.description ?? "No description available",
                  fontSize: 14.sp,
                  color: AppColors.obscureTextColor,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(RestaurantModel restaurant) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      "Phone",
                      fontSize: 14.sp,
                      color: AppColors.obscureTextColor,
                    ),
                    customText(
                      restaurant.phone,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customText(
                    "Status",
                    fontSize: 14.sp,
                    color: AppColors.obscureTextColor,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(restaurant.status),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: customText(
                      restaurant.status.toUpperCase(),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      "Email",
                      fontSize: 14.sp,
                      color: AppColors.obscureTextColor,
                    ),
                    customText(
                      restaurant.email,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customText(
                    "Opening hours:",
                    fontSize: 14.sp,
                    color: AppColors.obscureTextColor,
                  ),
                  customText(
                    _getOpeningHours(restaurant),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            _buildCategoryTab("All"),
            ...dashboardController.menuCategories.map(
              (category) => _buildCategoryTab(category.name),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuHeader(DashboardController dashboardController) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            "Menu Items ${selectedCategory != 'All' ? '($selectedCategory)' : ''}",
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.obscureTextColor,
          ),
          if (dashboardController.isLoadingMenus)
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(
    DashboardController dashboardController,
    CartController cartController,
  ) {
    if (dashboardController.isLoadingMenus) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ),
      );
    }

    final filteredItems = _getFilteredMenuItems(dashboardController);
    if (filteredItems.isEmpty) {
      return _buildEmptyMenuState();
    }

    return Column(
      children: filteredItems
          .map(
            (menuItem) =>
                _buildMenuItem(menuItem, dashboardController, cartController),
          )
          .toList(),
    );
  }

  List<MenuItemModel> _getFilteredMenuItems(
    DashboardController dashboardController,
  ) {
    final restaurant = dashboardController.selectedRestaurant;
    if (restaurant == null) return [];

    return dashboardController.getFilteredMenuItemsForRestaurant(
      restaurant.id.toString(),
      selectedCategory,
    );
  }

  Widget _buildEmptyMenuState() {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 60.sp,
            color: AppColors.obscureTextColor.withOpacity(0.5),
          ),
          SizedBox(height: 15.h),
          customText(
            "No Menu Items Available",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 8.h),
          customText(
            selectedCategory != 'All'
                ? "No items found in this category"
                : "This restaurant hasn't added any menu items yet",
            fontSize: 14.sp,
            color: AppColors.obscureTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String title) {
    bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 15.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.obscureTextColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            customText(
              title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? AppColors.whiteColor
                  : AppColors.obscureTextColor,
            ),
            if (isSelected && title != 'All') ...[
              SizedBox(width: 8.w),
              Icon(Icons.close, size: 16.sp, color: AppColors.whiteColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    MenuItemModel menuItem,
    DashboardController controller,
    CartController cartController,
  ) {
    bool isInCart = cartController.isInCart(menuItem.id);
    int cartQuantity = cartController.getItemQuantityInCart(menuItem.id);
    bool isAvailable = controller.isMenuItemAvailable(menuItem);

    return InkWell(
      onTap: () {
        controller.navigateToFoodDetail(menuItem);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        padding: EdgeInsets.all(12.w),
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
        child: Row(
          children: [
            // Food Image
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.backgroundColor,
                image: menuItem.image.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(menuItem.image),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // Handle image loading error
                        },
                      )
                    : null,
              ),
              child: menuItem.image.isEmpty
                  ? Icon(
                      Icons.restaurant,
                      color: AppColors.obscureTextColor,
                      size: 30.sp,
                    )
                  : null,
            ),
            SizedBox(width: 15.w),

            // Food Details
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    menuItem.name,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 4.h),

                  // Category badge
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
                      menuItem.category.name,
                      fontSize: 10.sp,
                      color: AppColors.obscureTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  if (menuItem.description != null &&
                      menuItem.description!.isNotEmpty)
                    customText(
                      menuItem.description!,
                      fontSize: 12.sp,
                      color: AppColors.obscureTextColor,
                      maxLines: 2,
                    ),
                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      customText(
                        "₦${menuItem.price.toStringAsFixed(2)}",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      if (menuItem.plateSize != null &&
                          menuItem.plateSize!.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        customText(
                          "• ${menuItem.plateSize}",
                          fontSize: 12.sp,
                          color: AppColors.obscureTextColor,
                        ),
                      ],
                      if (menuItem.duration.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.access_time,
                          color: AppColors.obscureTextColor,
                          size: 12.sp,
                        ),
                        SizedBox(width: 2.w),
                        customText(
                          menuItem.duration,
                          fontSize: 11.sp,
                          color: AppColors.obscureTextColor,
                        ),
                      ],
                    ],
                  ),

                  if (isInCart) ...[
                    SizedBox(height: 4.h),
                    customText(
                      "$cartQuantity in cart",
                      fontSize: 11.sp,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],

                  // Stock status
                  if (!isAvailable) ...[
                    SizedBox(height: 4.h),
                    customText(
                      controller.getMenuItemAvailabilityStatus(menuItem),
                      fontSize: 11.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ],
              ),
            ),

            // Add to Cart Button
            SizedBox(width: 8.w),
            InkWell(
              onTap: (isAvailable && !cartController.isAddingToCart)
                  ? () => _addToCart(menuItem, cartController)
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isAvailable
                      ? (cartController.isAddingToCart
                            ? AppColors.obscureTextColor
                            : AppColors.primaryColor)
                      : AppColors.obscureTextColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (cartController.isAddingToCart) ...[
                      SizedBox(
                        width: 12.w,
                        height: 12.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.whiteColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                    ],
                    customText(
                      cartController.isAddingToCart
                          ? "Adding..."
                          : (isAvailable ? "Add to cart" : "Unavailable"),
                      fontSize: 12.sp,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  void _toggleFavorite(
    RestaurantModel restaurant,
    DashboardController controller,
  ) async {
    try {
      await controller.toggleFavorite(restaurant);
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  void _addToCart(MenuItemModel menuItem, CartController cartController) async {
    try {
      await cartController.addToCart(menuItem.id, 1);
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

  String _getOpeningHours(RestaurantModel restaurant) {
    if (restaurant.schedules == null || restaurant.schedules!.isEmpty) {
      return "No schedule available";
    }

    final today = DateTime.now().weekday;
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    final currentDay = dayNames[today - 1];

    final todaySchedule = restaurant.schedules!.firstWhere(
      (schedule) => schedule.dayOfWeek.toLowerCase() == currentDay,
      orElse: () => restaurant.schedules!.first,
    );

    final openTime = DateTime.parse(todaySchedule.openTime);
    final closeTime = DateTime.parse(todaySchedule.closeTime);

    return "${_formatTime(openTime)} - ${_formatTime(closeTime)}";
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
