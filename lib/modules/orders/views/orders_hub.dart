import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosharpsharp/core/utils/app_colors.dart' show AppColors;
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';
import 'package:gosharpsharp/modules/cart/views/cart_screen.dart';
import 'package:gosharpsharp/modules/orders/controllers/orders_controller.dart';

import '../../../core/utils/exports.dart';
import 'orders_home_screen.dart';

class OrdersHub extends StatelessWidget {
  const OrdersHub({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: Get.isRegistered<CartController>() ? null : CartController(),
      builder: (cartController) {
        return GetBuilder<OrdersController>(
          init: Get.isRegistered<OrdersController>() ? null : OrdersController(),
          builder: (ordersController) {
            return GetBuilder<DeliveriesController>(
              init: Get.isRegistered<DeliveriesController>() ? null : DeliveriesController(),
              builder: (deliveriesController) {
                return Scaffold(
                  backgroundColor: AppColors.backgroundColor,
                  appBar: defaultAppBar(
                    bgColor: AppColors.backgroundColor,
                    title: 'My Orders',
                    implyLeading: false,
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      children: [
                        // My Cart Card
                        _buildOrderCard(
                          icon: SvgAssets.cartIcon,
                          accentColor: AppColors.primaryColor,
                          title: 'My Cart',
                          subtitle: cartController.itemCount > 0
                              ? '${cartController.itemCount} ${cartController.itemCount == 1 ? 'item' : 'items'} in cart'
                              : 'Your cart is empty',
                          count: cartController.itemCount,
                          onTap: () {
                            Get.toNamed(Routes.CART_SCREEN);
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Order History Card
                        _buildOrderCard(
                          icon: SvgAssets.ordersIcon,
                          accentColor: AppColors.secondaryColor,
                          title: 'Order History',
                          subtitle: ordersController.allOrders.isNotEmpty
                              ? '${ordersController.allOrders.length} ${ordersController.allOrders.length == 1 ? 'order' : 'orders'}'
                              : 'No orders yet',
                          count: ordersController.allOrders.length,
                          onTap: () {
                            Get.to(() => OrdersHomeScreen());
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Parcel Deliveries Card
                        _buildOrderCard(
                          icon: SvgAssets.parcelIcon,
                          accentColor: Color(0xFF7C4DFF),
                          title: 'Parcel Deliveries',
                          subtitle: deliveriesController.allParcelDeliveries.isNotEmpty
                              ? '${deliveriesController.allParcelDeliveries.length} ${deliveriesController.allParcelDeliveries.length == 1 ? 'delivery' : 'deliveries'}'
                              : 'No parcel deliveries yet',
                          count: deliveriesController.allParcelDeliveries.length,
                          onTap: () {
                            Get.toNamed(Routes.PARCEL_DELIVERIES_HOME_SCREEN);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildOrderCard({
    required String icon,
    required Color accentColor,
    required String title,
    required String subtitle,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.greyColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container with accent color
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SvgPicture.asset(
                icon,
                height: 32.sp,
                width: 32.sp,
                colorFilter: ColorFilter.mode(
                  AppColors.whiteColor,
                  BlendMode.srcIn,
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    title,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 4.h),
                  customText(
                    subtitle,
                    fontSize: 13.sp,
                    color: AppColors.obscureTextColor,
                  ),
                ],
              ),
            ),

            // Count Badge and Arrow with accent color
            Column(
              children: [
                if (count > 0)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: customText(
                      count.toString(),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                SizedBox(height: 8.h),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18.sp,
                  color: AppColors.blackColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


