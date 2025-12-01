import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/modules/cart/views/widgets/package_selection_dialog.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen>
    with TickerProviderStateMixin {
  int quantity = 1;
  late TabController _tabController;
  bool isFavorite = false;
  List<int> selectedAddonIds = []; // Track selected addon IDs
  bool isAddingToCart = false;
  bool isUpdatingQuantity = false; // Track quantity update state
  int? addingAddonId; // Track which addon is being added to cart

  late final DashboardController dashboardController;
  late final CartController cartController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    dashboardController = Get.find<DashboardController>();
    cartController = Get.find<CartController>();

    // Initialize quantity from cart if item exists
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeQuantityFromCart();
    });
  }

  void _initializeQuantityFromCart() {
    final menuItem = dashboardController.selectedMenuItem;
    if (menuItem != null) {
      final cartItem = cartController.getCartItemByPurchasableId(menuItem.id);
      if (cartItem != null) {
        setState(() {
          quantity = cartItem.quantity;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _incrementQuantity() async {
    if (isUpdatingQuantity) return;

    final menuItem = dashboardController.selectedMenuItem;
    if (menuItem == null) return;

    debugPrint('Increment tapped. Current quantity: $quantity');

    // Check if item is already in cart
    final cartItem = cartController.getCartItemByPurchasableId(menuItem.id);

    if (cartItem != null) {
      // Check if restaurant is open before updating cart
      final restaurant = dashboardController.selectedRestaurant;
      if (restaurant != null && !restaurant.isOpen()) {
        if (Get.context != null) {
          ModernSnackBar.showError(
            Get.context!,
            message: "${restaurant.name} is closed",
          );
        }
        return;
      }

      // Item is in cart - update via API
      setState(() => isUpdatingQuantity = true);
      try {
        await cartController.updateCartItemQuantity(
          cartItem.id,
          quantity: quantity + 1,
        );
        setState(() {
          quantity++;
        });
      } finally {
        setState(() => isUpdatingQuantity = false);
      }
    } else {
      // Item not in cart - just update local state
      setState(() {
        quantity++;
        debugPrint('New quantity after increment: $quantity');
      });
    }
  }

  void _decrementQuantity() async {
    if (isUpdatingQuantity) return;

    final menuItem = dashboardController.selectedMenuItem;
    if (menuItem == null) return;

    debugPrint('Decrement tapped. Current quantity: $quantity');

    if (quantity <= 1) return;

    // Check if item is already in cart
    final cartItem = cartController.getCartItemByPurchasableId(menuItem.id);

    if (cartItem != null) {
      // Check if restaurant is open before updating cart
      final restaurant = dashboardController.selectedRestaurant;
      if (restaurant != null && !restaurant.isOpen()) {
        if (Get.context != null) {
          ModernSnackBar.showError(
            Get.context!,
            message: "${restaurant.name} is closed",
          );
        }
        return;
      }

      // Item is in cart - update via API
      setState(() => isUpdatingQuantity = true);
      try {
        await cartController.updateCartItemQuantity(
          cartItem.id,
          quantity: quantity - 1,
        );
        setState(() {
          quantity--;
        });
      } finally {
        setState(() => isUpdatingQuantity = false);
      }
    } else {
      // Item not in cart - just update local state
      setState(() {
        quantity--;
        debugPrint('New quantity after decrement: $quantity');
      });
    }
  }

  double _calculateTotalPrice(MenuItemModel? menuItem) {
    if (menuItem == null) return 0.0;
    double total = menuItem.price * quantity;

    // Add packaging price if available
    if (menuItem.packagingPrice != null && menuItem.packagingPrice! > 0) {
      total += menuItem.packagingPrice! * quantity;
    }

    // Add selected addons prices (including their packaging prices)
    if (menuItem.addonMenus != null) {
      for (var addon in menuItem.addonMenus!) {
        if (selectedAddonIds.contains(addon.id)) {
          total += addon.price * quantity;
          // Add addon packaging price if available
          if (addon.packagingPrice != null && addon.packagingPrice! > 0) {
            total += addon.packagingPrice! * quantity;
          }
        }
      }
    }

    return total;
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
                appBar: defaultAppBar(title: "Food Details"),
                body: Center(
                  child: customText(
                    "No food item selected",
                    fontSize: 16.sp,
                    color: AppColors.obscureTextColor,
                  ),
                ),
              );
            }

            final isAvailable = dashboardController.isMenuItemAvailable(
              menuItem,
            );
            final availabilityStatus = dashboardController
                .getMenuItemAvailabilityStatus(menuItem);
            final isCurrentlyAdding = cartController.isAddingItemToCart(
              menuItem.id,
            );

            return Scaffold(
              backgroundColor: AppColors.whiteColor,
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
                                Colors.black.withValues(alpha: 0.3),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.6),
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
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.clear,
                                    color: AppColors.blackColor,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Availability status indicator
                        if (!isAvailable)
                          Positioned(
                            top: 100.h,
                            right: 20.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
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

                        // Discount badge
                        if (menuItem.discountBadgeText != null)
                          Positioned(
                            bottom: 20.h,
                            left: 20.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.redColor,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: customText(
                                menuItem.discountBadgeText!,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondaryColor,
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        child: customText(
                                          menuItem.category.name,
                                          fontSize: 12.sp,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      customText(
                                        menuItem.name.capitalizeFirst ?? menuItem.name,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blackColor,
                                      ),

                                      SizedBox(height: 8.h),
                                      // Plate size and prep time in a nice row
                                      Row(
                                        children: [
                                          // Plate Size
                                          if (menuItem.plateSize != null &&
                                              menuItem
                                                  .plateSize!
                                                  .isNotEmpty) ...[
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 6.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryColor
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.restaurant,
                                                    color:
                                                        AppColors.primaryColor,
                                                    size: 16.sp,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  customText(
                                                    menuItem.plateSize!,
                                                    fontSize: 13.sp,
                                                    color:
                                                        AppColors.primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 8.w),
                                          ],
                                          // Prep Time
                                          if (menuItem.prepTimeMinutes != null)
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 6.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.secondaryColor
                                                    .withValues(alpha: 0.3),
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    color: AppColors.blackColor,
                                                    size: 16.sp,
                                                  ),
                                                  SizedBox(width: 4.w),
                                                  customText(
                                                    "${menuItem.prepTimeMinutes} mins",
                                                    fontSize: 13.sp,
                                                    color: AppColors.blackColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      customText(
                                        formatToCurrency(menuItem.price),
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.blackColor,
                                      ),
                                      // Food Pack (Packaging Price)
                                      if (menuItem.packagingPrice != null &&
                                          menuItem.packagingPrice! > 0) ...[
                                        SizedBox(height: 8.h),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor
                                                .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.shopping_bag_outlined,
                                                color: AppColors.primaryColor,
                                                size: 16.sp,
                                              ),
                                              SizedBox(width: 4.w),
                                              customText(
                                                "Food Pack: ${formatToCurrency(menuItem.packagingPrice!)}",
                                                fontSize: 13.sp,
                                                color: AppColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 5.h),
                                      customText(
                                        menuItem.description?.capitalizeFirst ??
                                            "No description available",
                                        fontSize: 14.sp,
                                        color: AppColors.blackColor,
                                        height: 1.6,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Availability info
                            if (availabilityStatus != "Available")
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 8.h,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: availabilityStatus == "Limited Stock"
                                        ? Colors.orange.withValues(alpha: 0.1)
                                        : Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color:
                                            availabilityStatus ==
                                                "Limited Stock"
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
                                          color:
                                              availabilityStatus ==
                                                  "Limited Stock"
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

                            // Details Section
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 16.h),

                                  // Show addons if available
                                  if (menuItem.addonMenus != null &&
                                      menuItem.addonMenus!.isNotEmpty) ...[
                                    customText(
                                      "Goes well with",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(height: 12.h),
                                    Column(
                                      children: menuItem.addonMenus!
                                          .map(
                                            (addon) => _buildAddonItem(
                                              addon,
                                              menuItem,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    SizedBox(height: 16.h),
                                  ],
                                ],
                              ),
                            ),

                            SizedBox(height: 24.h),

                            SizedBox(
                              height: 100.h,
                            ), // Extra padding for bottom button
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: isAvailable
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Package selector row (only show if cart has items)
                            if (!cartController.isCartEmpty) ...[
                              _buildPackageSelector(cartController),
                              SizedBox(height: 12.h),
                            ],
                            Row(
                              children: [
                                // Quantity controls
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    children: [
                                      // Decrement button
                                      GestureDetector(
                                        onTap: isUpdatingQuantity
                                            ? null
                                            : () {
                                                debugPrint('Decrement button pressed');
                                                _decrementQuantity();
                                              },
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          padding: EdgeInsets.all(12.w),
                                          child: Icon(
                                            Icons.remove,
                                            color: isUpdatingQuantity
                                                ? AppColors.obscureTextColor
                                                : (quantity > 1
                                                    ? AppColors.blackColor
                                                    : AppColors.obscureTextColor),
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                      // Quantity display
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                        ),
                                        child: isUpdatingQuantity
                                            ? SizedBox(
                                                width: 20.w,
                                                height: 20.w,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<Color>(
                                                    AppColors.primaryColor,
                                                  ),
                                                ),
                                              )
                                            : customText(
                                                quantity.toString(),
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.blackColor,
                                              ),
                                      ),
                                      // Increment button
                                      GestureDetector(
                                        onTap: isUpdatingQuantity
                                            ? null
                                            : () {
                                                debugPrint('Increment button pressed');
                                                _incrementQuantity();
                                              },
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          padding: EdgeInsets.all(12.w),
                                          child: Icon(
                                            Icons.add,
                                            color: isUpdatingQuantity
                                                ? AppColors.obscureTextColor
                                                : AppColors.blackColor,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                // Add to cart button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: isAddingToCart
                                        ? null
                                        : () => _handleAddToCartWithAddons(
                                            menuItem,
                                            cartController,
                                          ),
                                    child: Container(
                                      height: 56.h,
                                      decoration: BoxDecoration(
                                        color: isAddingToCart
                                            ? AppColors.primaryColor.withValues(
                                                alpha: 0.6,
                                              )
                                            : AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      alignment: Alignment.center,
                                      child: isAddingToCart
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 20.w,
                                                  height: 20.w,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(
                                                          AppColors.whiteColor,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(width: 12.w),
                                                customText(
                                                  "Adding...",
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.whiteColor,
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                customText(
                                                  "Add to Cart",
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.whiteColor,
                                                ),
                                                customText(
                                                  formatToCurrency(
                                                    _calculateTotalPrice(menuItem),
                                                  ),
                                                  fontSize: 12.sp,
                                                  color: AppColors.whiteColor
                                                      .withValues(alpha: 0.9),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: AppColors.obscureTextColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          alignment: Alignment.center,
                          child: customText(
                            "Unavailable",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
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

  Widget _buildPackageSelector(CartController cartController) {
    final currentPackage = cartController.selectedPackageName ?? 'Pack 1';
    final packageCount = cartController.packageNames.length;

    return GestureDetector(
      onTap: () async {
        final result = await Get.dialog<String>(
          PackageSelectionDialog(
            existingPackages: cartController.packageNames,
            currentPackage: cartController.selectedPackageName,
          ),
          barrierDismissible: true,
        );

        if (result != null && result.isNotEmpty) {
          cartController.setSelectedPackage(result);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primaryColor,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    "Adding to:",
                    fontSize: 11.sp,
                    color: AppColors.greyColor,
                  ),
                  customText(
                    currentPackage,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: customText(
                "$packageCount ${packageCount == 1 ? 'pack' : 'packs'}",
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(width: 6.w),
            GestureDetector(
              onTap: () => _showPackageInfoBottomSheet(),
              child: Icon(
                Icons.info_outline,
                color: AppColors.greyColor,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryColor,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showPackageInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 24.sp,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 12.w),
                  customText(
                    'What is a Package?',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              customText(
                'A package is a group of items in your cart that will be delivered together. You can have multiple packages to organize orders for different recipients or delivery locations.',
                fontSize: 14.sp,
                color: AppColors.blackColor.withValues(alpha: 0.7),
                maxLines: 10,
              ),
              SizedBox(height: 12.h),
              customText(
                'When you add items to your cart, they are automatically added to your selected package.',
                fontSize: 14.sp,
                color: AppColors.blackColor.withValues(alpha: 0.7),
                maxLines: 5,
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () => Get.back(),
                  title: 'Got it',
                  backgroundColor: AppColors.primaryColor,
                  fontColor: AppColors.whiteColor,
                  height: 48.h,
                  borderRadius: 12.r,
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(label, fontSize: 14.sp, color: AppColors.obscureTextColor),
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

  void _handleAddToCartWithAddons(
    MenuItemModel menuItem,
    CartController cartController,
  ) async {
    if (isAddingToCart) return; // Prevent double-tap

    // Check if restaurant is open before adding to cart
    final restaurant = dashboardController.selectedRestaurant;
    debugPrint('Restaurant: ${restaurant?.name}, isOpen: ${restaurant?.isOpen()}');
    if (restaurant == null || !restaurant.isOpen()) {
      if (Get.context != null) {
        ModernSnackBar.showError(
          Get.context!,
          message: "${restaurant?.name ?? 'Restaurant'} is closed",
        );
      }
      return;
    }

    setState(() => isAddingToCart = true);

    try {
      // Debug logging
      debugPrint('=== ADD TO CART DEBUG ===');
      debugPrint('Menu Item ID: ${menuItem.id}');
      debugPrint('Menu Item Name: ${menuItem.name}');
      debugPrint('Quantity: $quantity');
      debugPrint('Selected Addon IDs: $selectedAddonIds');
      if (menuItem.addonMenus != null) {
        for (var addon in menuItem.addonMenus!) {
          debugPrint('Available Addon: id=${addon.id}, name=${addon.name}');
        }
      }
      debugPrint('=========================');

      // Use the correct API format with addons list and quantity
      await cartController.addToCart(
        menuItem.id,
        quantity, // Use the local quantity state
        addonIds: selectedAddonIds.isNotEmpty ? selectedAddonIds : null,
        restaurant: restaurant,
      );

      // Reset state after successful add
      setState(() {
        isAddingToCart = false;
        quantity = 1; // Reset quantity
        selectedAddonIds.clear(); // Clear selected addons
      });
    } catch (e) {
      setState(() => isAddingToCart = false);
      debugPrint('Error adding to cart: $e');
      showToast(
        isError: true,
        message: "Failed to add item to cart. Please try again.",
      );
    }
  }

  Widget _buildAddonItem(
    MenuItemModel addon,
    MenuItemModel mainItem,
  ) {
    // Check if this addon is already in the cart
    final isInCart = cartController.getCartItemByPurchasableId(addon.id) != null;
    final isAddingThisAddon = addingAddonId == addon.id;

    // Check if addon is available
    final isAddonAvailable = dashboardController.isMenuItemAvailable(addon);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isAddonAvailable ? AppColors.whiteColor : AppColors.whiteColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Addon image
          Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.backgroundColor,
                  image: addon.files.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(addon.files[0].url),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {},
                          colorFilter: isAddonAvailable
                              ? null
                              : ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.saturation,
                                ),
                        )
                      : null,
                ),
                child: addon.files.isEmpty
                    ? Icon(
                        Icons.restaurant,
                        color: AppColors.obscureTextColor,
                        size: 30.sp,
                      )
                    : null,
              ),
              // Unavailable overlay on image
              if (!isAddonAvailable)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: customText(
                          "Out of Stock",
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          // Addon details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  addon.name.capitalizeFirst ?? addon.name,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isAddonAvailable ? AppColors.blackColor : AppColors.obscureTextColor,
                  maxLines: 2,
                ),
                if (addon.description != null && addon.description!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  customText(
                    addon.description!.capitalizeFirst ?? addon.description!,
                    fontSize: 12.sp,
                    color: AppColors.obscureTextColor,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                SizedBox(height: 8.h),
                // Price without + prefix
                customText(
                  formatToCurrency(addon.price + (addon.packagingPrice ?? 0)),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isAddonAvailable ? AppColors.primaryColor : AppColors.obscureTextColor,
                ),
                SizedBox(height: 8.h),
                // Add button - disabled if addon is unavailable
                InkWell(
                  onTap: (!isAddonAvailable || isAddingThisAddon) ? null : () => _addAddonToCart(addon),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: !isAddonAvailable
                          ? AppColors.obscureTextColor.withValues(alpha: 0.3)
                          : isAddingThisAddon
                              ? AppColors.primaryColor.withValues(alpha: 0.7)
                              : isInCart
                                  ? AppColors.primaryColor
                                  : AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isAddonAvailable ? AppColors.primaryColor : AppColors.obscureTextColor,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isAddingThisAddon)
                          SizedBox(
                            width: 16.sp,
                            height: 16.sp,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.whiteColor,
                              ),
                            ),
                          )
                        else
                          Icon(
                            !isAddonAvailable
                                ? Icons.block
                                : isInCart
                                    ? Icons.check
                                    : Icons.add,
                            size: 16.sp,
                            color: !isAddonAvailable
                                ? AppColors.obscureTextColor
                                : isInCart
                                    ? AppColors.whiteColor
                                    : AppColors.primaryColor,
                          ),
                        SizedBox(width: 4.w),
                        customText(
                          !isAddonAvailable
                              ? "Unavailable"
                              : isAddingThisAddon
                                  ? "Adding..."
                                  : isInCart
                                      ? "Added"
                                      : "Add",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: !isAddonAvailable
                              ? AppColors.obscureTextColor
                              : (isAddingThisAddon || isInCart)
                                  ? AppColors.whiteColor
                                  : AppColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Add addon directly to cart as a separate item with quantity 1
  Future<void> _addAddonToCart(MenuItemModel addon) async {
    final restaurant = dashboardController.selectedRestaurant;

    if (restaurant == null || !restaurant.isOpen()) {
      if (Get.context != null) {
        ModernSnackBar.showError(
          Get.context!,
          message: "${restaurant?.name ?? 'Restaurant'} is closed",
        );
      }
      return;
    }

    // Set loading state for this specific addon
    setState(() {
      addingAddonId = addon.id;
    });

    try {
      // Add addon to cart with quantity 1
      // Uses the same package logic as main item (will use selected package or prompt for package selection)
      await cartController.addToCart(
        addon.id,
        1, // Quantity of 1 for addon
        restaurant: restaurant,
      );

      // Refresh UI to show "Added" state
      setState(() {
        addingAddonId = null;
      });
    } catch (e) {
      debugPrint('Error adding addon to cart: $e');
      setState(() {
        addingAddonId = null;
      });
      showToast(
        isError: true,
        message: "Failed to add item to cart. Please try again.",
      );
    }
  }
}
