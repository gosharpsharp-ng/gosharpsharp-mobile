import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';
import 'package:gosharpsharp/core/models/menu_item_model.dart';
import 'package:gosharpsharp/modules/dashboard/views/widgets/addon_selection_bottom_sheet.dart';

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
  MenuItemModel? selectedAddon;

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
            Icon(Icons.check_circle, color: Colors.green, size: 48.sp),
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
                      Get.offNamedUntil(
                        Routes.APP_NAVIGATION,
                        (route) => false,
                      );
                      // Ensure the controller is available and set cart tab
                      Future.delayed(Duration(milliseconds: 100), () {
                        try {
                          final appNavController =
                              Get.find<AppNavigationController>();
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
                                        menuItem.name,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blackColor,
                                      ),

                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          if (menuItem.plateSize != null &&
                                              menuItem
                                                  .plateSize!
                                                  .isNotEmpty) ...[
                                            customText(
                                              menuItem.plateSize!,
                                              fontSize: 12.sp,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      customText(
                                        formatToCurrency(menuItem.price),
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.blackColor,
                                      ),
                                      // customText(
                                      //   "per plate",
                                      //   fontSize: 12.sp,
                                      //   color: AppColors.obscureTextColor,
                                      // ),
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
                                  if (menuItem.prepTimeMinutes != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                        vertical: 6.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 8.h,
                                ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildCartControls(
                                  menuItem,
                                  cartController,
                                  isAvailable,
                                  isCurrentlyAdding,
                                  cartController.getItemQuantityInCart(
                                    menuItem.id,
                                  ),
                                ),
                              ],
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
                                      "Available Add-ons (${menuItem.addonMenus!.length})",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(height: 12.h),
                                    GetBuilder<CartController>(
                                      builder: (cartCtrl) => Column(
                                        children: menuItem.addonMenus!
                                            .map(
                                              (addon) => _buildAddonItem(
                                                addon,
                                                cartCtrl,
                                                menuItem,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                  ],

                                  SizedBox(height: 8.h),
                                  if (menuItem.plateSize != null &&
                                      menuItem.plateSize!.isNotEmpty) ...[
                                    _buildDetailRow(
                                      "Plate Size",
                                      menuItem.plateSize!,
                                    ),
                                    SizedBox(height: 8.h),
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
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: isAvailable
                      ? CustomButton(
                          width: double.infinity,
                          height: 56.h,
                          backgroundColor: AppColors.primaryColor,
                          title:
                              "Add to Cart - ${formatToCurrency(menuItem.price + (selectedAddon?.price ?? 0))}",
                          onPressed: () => _handleAddToCartFromButton(
                            menuItem,
                            cartController,
                          ),
                          borderRadius: 12.r,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontColor: AppColors.whiteColor,
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

  void _addToCart(MenuItemModel menuItem, CartController cartController) async {
    try {
      // Check if menu item has addons
      if (menuItem.addonMenus != null && menuItem.addonMenus!.isNotEmpty) {
        // Show addon selection bottom sheet
        Get.bottomSheet(
          AddonSelectionBottomSheet(
            menuItem: menuItem,
            onAddToCart: (int? addonMenuId) async {
              await cartController.addToCart(
                menuItem.id,
                1,
                addonMenuId: addonMenuId,
              );
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

  void _handleAddToCartFromButton(
    MenuItemModel menuItem,
    CartController cartController,
  ) async {
    try {
      // Check if menu item has addons
      if (menuItem.addonMenus != null && menuItem.addonMenus!.isNotEmpty) {
        // Show addon selection bottom sheet
        final result = await Get.bottomSheet<int?>(
          AddonSelectionBottomSheet(
            menuItem: menuItem,
            onAddToCart: (int? addonMenuId) async {
              await cartController.addToCart(
                menuItem.id,
                1,
                addonMenuId: addonMenuId,
              );
              Get.back(result: addonMenuId); // Pass addon ID back
            },
          ),
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
        );

        // Pop the food detail screen after adding to cart
        if (result != null || result == null) {
          // Addon selected or skipped
          Get.back(); // Close food detail screen
        }
      } else {
        // No addons, add directly to cart and close screen
        await cartController.addToCart(menuItem.id, 1);
        Get.back(); // Close food detail screen
      }
    } catch (e) {
      debugPrint('Error adding to cart from button: $e');
    }
  }

  Widget _buildAddonItem(
    MenuItemModel addon,
    CartController cartController,
    MenuItemModel mainItem,
  ) {
    // Check if addon is in cart
    final isInCart = cartController.isAddonInCart(mainItem.id, addon.id);
    final addonQuantity = cartController.getAddonQuantityInCart(mainItem.id, addon.id);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isInCart ? AppColors.primaryColor.withOpacity(0.1) : AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isInCart ? AppColors.primaryColor : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () async {
              if (isInCart) {
                // Remove from cart
                await cartController.removeAddonFromCart(mainItem.id, addon.id);
              } else {
                // Add to cart
                await cartController.addToCart(
                  mainItem.id,
                  1,
                  addonMenuId: addon.id,
                );
              }
            },
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isInCart ? AppColors.primaryColor : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: isInCart ? AppColors.primaryColor : AppColors.greyColor,
                  width: 2,
                ),
              ),
              child: isInCart
                  ? Icon(
                      Icons.check,
                      size: 16.sp,
                      color: AppColors.whiteColor,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),
          // Addon details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  addon.name,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 2.h),
                customText(
                  formatToCurrency(addon.price),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.normal,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ),
          // Quantity controls - always visible
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: addonQuantity > 0
                      ? () async {
                          if (addonQuantity > 1) {
                            await cartController.decreaseAddonQuantity(mainItem.id, addon.id);
                          } else {
                            await cartController.removeAddonFromCart(mainItem.id, addon.id);
                          }
                        }
                      : null,
                  child: Icon(
                    addonQuantity > 1 ? Icons.remove : Icons.delete_outline,
                    size: 16.sp,
                    color: addonQuantity > 0
                        ? (addonQuantity > 1 ? AppColors.blackColor : AppColors.redColor)
                        : AppColors.greyColor,
                  ),
                ),
                SizedBox(width: 8.w),
                customText(
                  addonQuantity.toString(),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () async {
                    if (addonQuantity > 0) {
                      await cartController.increaseAddonQuantity(mainItem.id, addon.id);
                    } else {
                      // Add to cart for the first time
                      await cartController.addToCart(
                        mainItem.id,
                        1,
                        addonMenuId: addon.id,
                      );
                    }
                  },
                  child: Icon(
                    Icons.add,
                    size: 16.sp,
                    color: AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
