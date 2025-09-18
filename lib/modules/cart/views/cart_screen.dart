import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosharpsharp/core/models/cart_model.dart';
import 'package:gosharpsharp/core/utils/app_colors.dart' show AppColors;
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
              children:[
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
                ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
              ),
            )
                : cartController.isCartEmpty
                ? _buildEmptyCart()
                : Column(
              children: [
                // Delivery Location
                Container(
                  padding: EdgeInsets.all(16.sp),
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.whiteColor,
                          size: 16.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              'Deliver to',
                              fontSize: 12.sp,
                              color: AppColors.greyColor,
                            ),
                            SizedBox(height: 2.h),
                            customText(
                              'Current location',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                            customText(
                              cartController.currentLocation.value,
                              fontSize: 12.sp,
                              color: AppColors.greyColor,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),

                // Order Summary
                Container(
                  padding: EdgeInsets.all(16.sp),
                  margin: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            'Order summary',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          customText(
                            '${cartController.itemCount} item${cartController.itemCount != 1 ? 's' : ''}',
                            fontSize: 12.sp,
                            color: AppColors.greyColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Subtotal
                      OrderSummaryItem(
                        label: "Subtotal",
                        amount: cartController.subtotal,
                      ),
                      SizedBox(height: 8.h),
                      OrderSummaryItem(
                        label: "Delivery fee",
                        amount: cartController.deliveryFee,
                      ),
                      SizedBox(height: 8.h),
                      OrderSummaryItem(
                        label: "Service charge",
                        amount: cartController.serviceCharge,
                      ),

                      SizedBox(height: 16.h),
                      Divider(),
                      SizedBox(height: 8.h),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            'Total',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          customText(
                            '₦${cartController.total.toStringAsFixed(2)}',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Cart Items Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      'Cart Items',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),

                // Cart Items List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];
                      return CartItemWidget(
                        item: item,
                        onQuantityChanged: (quantity) {
                          cartController.updateCartItemQuantity(item.id, quantity);
                        },
                        onRemove: () {
                          cartController.removeFromCart(item.id);
                        },
                        isUpdating: cartController.isUpdatingCart,
                        isRemoving: cartController.isRemovingFromCart,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: cartController.isCartEmpty
              ? null
              : Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
                height: 50.h,
                backgroundColor: AppColors.primaryColor,
                title: 'Place Order - ₦${cartController.total.toStringAsFixed(2)}',
                onPressed:  () {
                  if(!cartController.isLoading){
                    cartController.placeOrder();
                  }
                },
                isBusy: cartController.isLoading,
                borderRadius: 12.r,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontColor: AppColors.whiteColor,
              ),
            ),
          ),
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
                SvgAssets.emptyCartIcon
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
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                Get.back(); // Go back to browse restaurants
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: customText(
                "Browse Restaurants",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartController cartController) {
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

class OrderSummaryItem extends StatelessWidget {
  final String label;
  final double amount;

  const OrderSummaryItem({
    super.key,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(label, fontSize: 14.sp, color: AppColors.greyColor),
        customText(
          "₦${amount.toStringAsFixed(2)}",
          fontSize: 14.sp,
          color: AppColors.blackColor,
        ),
      ],
    );
  }
}