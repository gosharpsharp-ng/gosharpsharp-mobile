import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/widgets/skeleton_loaders.dart';
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
              backgroundColor: AppColors.whiteColor,
              body: Column(
                children: [
                  // Header Image with Back Button and Menu
                  _buildHeader(restaurant, cartController, dashboardController),

                  // Spacer for overlapping logo
                  SizedBox(height: 35.h),

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
                      child: RefreshIndicator(
                        onRefresh: () =>
                            _refreshRestaurantDetails(dashboardController),
                        color: AppColors.primaryColor,
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Restaurant Description
                              if (restaurant.description != null &&
                                  restaurant.description!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        restaurant.name,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blackColor,
                                      ),
                                      SizedBox(height: 4.h),
                                      if (restaurant.cuisineType != null)
                                        customText(
                                          restaurant.cuisineType!,
                                          fontSize: 14.sp,
                                          color: AppColors.obscureTextColor,
                                        ),
                                      customText(
                                        restaurant.description!,
                                        fontSize: 14.sp,
                                        color: AppColors.obscureTextColor,
                                        maxLines: 3,
                                      ),
                                    ],
                                  ),
                                ),

                              if (restaurant.description != null &&
                                  restaurant.description!.isNotEmpty)
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
    return Stack(
      children: [
        // Cover Image
        Container(
          height: 180.h,
          width: 1.sw,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  restaurant.bannerUrl != null &&
                      restaurant.bannerUrl!.isNotEmpty
                  ? NetworkImage(restaurant.bannerUrl!)
                  : restaurant.logoUrl != null && restaurant.logoUrl!.isNotEmpty
                  ? NetworkImage(restaurant.logoUrl!)
                  : restaurant.banner != null && restaurant.banner!.isNotEmpty
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
            clipBehavior: Clip.none,
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
              ),
              Positioned(
                top: 130.h,
                left: 20.w,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.whiteColor, width: 4.w),
                  ),
                  child: CircleAvatar(
                    radius: 40.r,
                    backgroundColor: AppColors.primaryColor,
                    backgroundImage:
                        (restaurant.logoUrl != null &&
                            restaurant.logoUrl!.isNotEmpty)
                        ? NetworkImage(restaurant.logoUrl!)
                        : (restaurant.logo != null &&
                              restaurant.logo!.isNotEmpty)
                        ? NetworkImage(restaurant.logo!)
                        : null,
                    child:
                        (restaurant.logoUrl == null ||
                                restaurant.logoUrl!.isEmpty) &&
                            (restaurant.logo == null ||
                                restaurant.logo!.isEmpty)
                        ? Text(
                            restaurant.name.isNotEmpty
                                ? restaurant.name[0].toUpperCase()
                                : "R",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
                      color: getStatusColor(restaurant.status),
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
                    getOpeningHours(restaurant),
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
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.refresh,
                size: 12.sp,
                color: AppColors.primaryColor,
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
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.w),
        child: SkeletonLoaders.menuItem(count: 8),
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
    int cartQuantity = cartController.getItemQuantityInCart(menuItem.id);
    bool isAvailable = controller.isMenuItemAvailable(menuItem);
    bool isCurrentlyAdding = cartController.isAddingItemToCart(menuItem.id);

    return InkWell(
      onTap: () {
        controller.navigateToFoodDetail(menuItem);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          // borderRadius: BorderRadius.circular(12.r),
          border: Border(
            bottom: BorderSide(color: AppColors.obscureTextColor, width: 0.2),
          ),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.05),
          //     blurRadius: 10,
          //     offset: Offset(0, 2),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food Image
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.backgroundColor,
                    image: menuItem.files.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(menuItem.files[0].url),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) {
                              // Handle image loading error
                            },
                          )
                        : null,
                  ),
                  child: menuItem.files.isEmpty
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
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      customText(
                        menuItem.name,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                      ),

                      // SizedBox(height: 4.h),
                      //
                      // // Category badge
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 6.w,
                      //     vertical: 2.h,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: AppColors.secondaryColor,
                      //     borderRadius: BorderRadius.circular(4.r),
                      //   ),
                      //   child: customText(
                      //     menuItem.category.name,
                      //     fontSize: 10.sp,
                      //     color: AppColors.blackColor,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      SizedBox(height: 4.h),

                      if (menuItem.description != null &&
                          menuItem.description!.isNotEmpty)
                        customText(
                          menuItem.description!,
                          fontSize: 12.sp,
                          color: AppColors.blackColor,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                        ),
                      SizedBox(height: 8.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (menuItem.plateSize != null &&
                              menuItem.plateSize!.isNotEmpty) ...[
                            customText(
                              "${menuItem.plateSize}",
                              fontSize: 12.sp,
                              color: AppColors.blackColor,
                            ),
                          ],
                          if (menuItem.prepTimeMinutes != null) ...[
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.access_time,
                              color: AppColors.blackColor,
                              size: 12.sp,
                            ),
                            SizedBox(width: 2.w),
                            customText(
                              "${menuItem.prepTimeMinutes}",
                              fontSize: 11.sp,
                              color: AppColors.blackColor,
                            ),
                          ],
                        ],
                      ),

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

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    customText(
                      formatToCurrency(menuItem.price),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCartControls(
                  menuItem,
                  cartController,
                  isAvailable,
                  isCurrentlyAdding,
                  cartQuantity,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartControls(
    MenuItemModel menuItem,
    CartController cartController,
    bool isAvailable,
    bool isCurrentlyAdding,
    int cartQuantity,
  ) {
    if (!isAvailable) {
      return Container(
        width: double.infinity,
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

    // Always show Add to Cart button (or cart icon if item is in cart)
    bool isInCart = cartQuantity > 0;

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
              : isInCart
              ? AppColors.primaryColor
              : AppColors.lightGreyColor,
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
                color: isInCart ? AppColors.whiteColor : AppColors.blackColor,
                size: 18.sp,
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
      await controller.toggleFavorite(restaurant, context);
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  void _addToCart(MenuItemModel menuItem, CartController cartController) async {
    try {
      // Check if menu item has addons
      if (menuItem.addonMenus != null && menuItem.addonMenus!.isNotEmpty) {
        // Navigate to food detail screen to show addons
        final controller = Get.find<DashboardController>();
        controller.navigateToFoodDetail(menuItem);
      } else {
        // No addons, add directly to cart
        final controller = Get.find<DashboardController>();
        await cartController.addToCart(
          menuItem.id,
          1,
          restaurant: controller.selectedRestaurant,
        );
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

  Future<void> _refreshRestaurantDetails(DashboardController controller) async {
    final restaurant = controller.selectedRestaurant;
    if (restaurant != null) {
      await controller.refreshRestaurantDetails(restaurant.id.toString());
    }
  }
}
