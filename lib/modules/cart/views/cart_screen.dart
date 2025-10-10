import 'package:gosharpsharp/core/models/cart_model.dart';
import 'package:gosharpsharp/core/widgets/skeleton_loaders.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';
import 'package:gosharpsharp/modules/cart/views/widgets/cart_item_widget.dart';

import '../../../core/utils/exports.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: 'My Cart',
            implyLeading: false,
            centerTitle: true,
            actionItem: Row(
              children: [
                if (!cartController.isCartEmpty)
                  TextButton(
                    onPressed: cartController.isLoading
                        ? null
                        : () => _showClearCartDialog(context, cartController),
                    child: customText(
                      'Clear',
                      fontSize: 14.sp,
                      color: AppColors.redColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          body: RefreshIndicator(
            backgroundColor: AppColors.primaryColor,
            color: AppColors.whiteColor,
            onRefresh: () => cartController.refreshCart(),
            child: cartController.isLoading
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        // Cart items skeleton
                        SkeletonLoaders.cartItem(count: 3),
                      ],
                    ),
                  )
                : cartController.isCartEmpty
                ? _buildEmptyCart()
                : Column(
                    children: [
                      // Packages List - Grouped by package
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          itemCount: cartController.packages.length,
                          itemBuilder: (context, packageIndex) {
                            final package = cartController.packages[packageIndex];
                            return _buildPackageSection(
                              context,
                              cartController,
                              package,
                              packageIndex,
                            );
                          },
                        ),
                      ),

                      // Simple Total Summary
                      _buildSimpleTotalSummary(cartController),
                    ],
                  ),
          ),
          bottomNavigationBar: cartController.isCartEmpty
              ? null
              : _buildCheckoutButton(cartController),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        width: 1.sw,
        height: 0.7.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              SvgAssets.cartIcon,
              height: 100.sp,
              colorFilter: ColorFilter.mode(
                AppColors.deepAmberColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 20.h),
            customText(
              "Your Cart is Empty",
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 10.h),
            customText(
              "Add some delicious items to your cart\nto get started",
              fontSize: 16.sp,
              color: AppColors.obscureTextColor,
              textAlign: TextAlign.center,
            ),
            // SizedBox(height: 30.h),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to dashboard tab (index 0) in app navigation
            //     try {
            //       final appNavController = Get.find<AppNavigationController>();
            //       appNavController.changeScreenIndex(0);
            //     } catch (e) {
            //       // Fallback if controller not found
            //       Get.offNamedUntil(
            //         Routes.APP_NAVIGATION,
            //         (route) => false,
            //         arguments: {'initialIndex': 0},
            //       );
            //     }
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.primaryColor,
            //     padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12.r),
            //     ),
            //   ),
            //   child: customText(
            //     "Browse Restaurants",
            //     fontSize: 16.sp,
            //     fontWeight: FontWeight.w600,
            //     color: AppColors.whiteColor,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleTotalSummary(CartController cartController) {
    return SizedBox.shrink();
  }

  Widget _buildCheckoutButton(CartController cartController) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(
          top: BorderSide(
            color: AppColors.greyColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Total Amount Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  customText(
                    'Total',
                    fontSize: 13.sp,
                    color: AppColors.obscureTextColor,
                  ),
                  SizedBox(height: 2.h),
                  customText(
                    formatToCurrency(cartController.total),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ],
              ),
            ),

            SizedBox(width: 16.w),

            // Checkout Button
            CustomButton(
              width: 140.w,
              height: 50.h,
              backgroundColor: AppColors.primaryColor,
              title: 'Checkout',
              onPressed: () {
                // Navigate to checkout screen
                Get.toNamed(Routes.CHECKOUT_SCREEN);
              },
              borderRadius: 12.r,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontColor: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildPackageSection(
    BuildContext context,
    CartController cartController,
    CartPackage package,
    int packageIndex,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Package Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.lightGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 20.sp,
                  color: AppColors.greyColor,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: customText(
                    package.name,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                // Package cost
                customText(
                  formatToCurrency(double.tryParse(package.cost) ?? 0.0),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ],
            ),
          ),

          // Package Actions
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      cartController.duplicatePackage(package.id);
                    },
                    icon: Icon(
                      Icons.content_copy,
                      size: 14.sp,
                      color: AppColors.greyColor,
                    ),
                    label: customText(
                      'Duplicate Pack',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor,
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      backgroundColor: AppColors.lightGreyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      // Set selected package and navigate to dashboard
                      cartController.setSelectedPackage(package.name);
                      Get.toNamed(Routes.DASHBOARD);
                      showToast(
                        message: "Select items to add to ${package.name}",
                        isError: false,
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      size: 14.sp,
                      color: AppColors.greyColor,
                    ),
                    label: customText(
                      'Add Items',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyColor,
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      backgroundColor: AppColors.lightGreyColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1.h, thickness: 1, color: AppColors.lightGreyColor),

          // Package Items
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(12.w),
            itemCount: package.items.length,
            separatorBuilder: (context, index) => Divider(height: 16.h),
            itemBuilder: (context, itemIndex) {
              final item = package.items[itemIndex];
              return CartItemWidget(
                item: item,
                onQuantityChanged: (quantity) {
                  cartController.updateCartItemQuantity(
                    item.id,
                    quantity: int.parse(quantity.toString()),
                    packageName: package.name,
                  );
                },
                onRemove: () {
                  cartController.removeFromCart(item.id);
                },
                isUpdating: cartController.isUpdatingCart,
                isRemoving: cartController.isRemovingFromCart,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(
    BuildContext context,
    CartController cartController,
  ) {
    Get.dialog(
      AlertDialog(
        title: customText(
          'Clear Cart',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        content: customText(
          'Are you sure you want to remove all items from your cart?',
          fontSize: 14.sp,
          color: AppColors.greyColor,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: customText(
              'Cancel',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              cartController.clearCart();
            },
            child: customText(
              'Clear',
              fontSize: 14.sp,
              color: AppColors.redColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

