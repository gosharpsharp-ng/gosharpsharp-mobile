import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          ),
          body: Column(
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
                    customText(
                      'Order summary',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 16.h),

                    // Delivery fee
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
                          color: AppColors.blackColor,
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
                        cartController.updateCartItemQuantity(
                          item.id,
                          quantity,
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
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: CustomButton(
              width: double.infinity,
              height: 58.h,
              backgroundColor: AppColors.primaryColor,
              title:
                  'Place Order - ₦${cartController.total.toStringAsFixed(2)}',
              onPressed: () {
                cartController.placeOrder();
              },
              isBusy: cartController.isLoading.value,
              borderRadius: 8.r,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontColor: AppColors.whiteColor,
            ),
          ),
        );
      },
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
          formatToCurrency(amount),
          fontSize: 14.sp,
          color: AppColors.blackColor,
        ),
      ],
    );
  }
}
