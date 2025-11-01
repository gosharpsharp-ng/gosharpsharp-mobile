import 'package:flutter/material.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';

import '../../../core/utils/exports.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String? orderNumber; // Pass order number to track specific order

  const OrderTrackingScreen({super.key, this.orderNumber});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  SocketService? _socketService;
  String _currentStatus = 'preparing';

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  void _initializeTracking() {
    try {
      // Get socket service if available
      if (Get.isRegistered<SocketService>()) {
        _socketService = Get.find<SocketService>();

        // Join order tracking room if orderNumber is provided
        if (widget.orderNumber != null) {
          _socketService?.joinFoodOrderTracking(widget.orderNumber!);

          // Listen for order status updates
          _socketService?.listenForOrderStatusUpdate((data) {
            if (mounted) {
              setState(() {
                _currentStatus = data['status'] ?? 'preparing';
              });

              // Show toast notification for status change
              if (data['previousStatus'] != null) {
                showToast(
                  message: 'Order status updated to ${data['status']}',
                  isError: false,
                );
              }
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing order tracking: $e');
    }
  }

  @override
  void dispose() {
    // Leave tracking room and stop listening when screen is closed
    if (widget.orderNumber != null && _socketService != null) {
      _socketService?.leaveFoodOrderTracking(widget.orderNumber!);
      _socketService?.stopListeningForOrderStatusUpdate();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: Stack(
            children: [
              // Map Container (Mock)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withOpacity(0.2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map,
                        size: 100.sp,
                        color: AppColors.greyColor.withOpacity(0.5),
                      ),
                      SizedBox(height: 16.h),
                      customText(
                        'Map View',
                        fontSize: 18.sp,
                        color: AppColors.greyColor,
                      ),
                      customText(
                        'Tracking your delivery',
                        fontSize: 14.sp,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
              ),

              // Top Right Location Button
              Positioned(
                top: 60.h,
                right: 20.w,
                child: Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.my_location,
                    size: 20.sp,
                    color: AppColors.blackColor,
                  ),
                ),
              ),

              // Bottom Sheet
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(20.sp),
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
                      customText(
                        'Picking up your order...',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(height: 20.h),

                      // Order Status Timeline
                      Row(
                        children: [
                          // Preparing
                          Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.restaurant,
                              size: 16.sp,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2.h,
                              color: AppColors.primaryColor,
                            ),
                          ),

                          // Out for delivery
                          Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.delivery_dining,
                              size: 16.sp,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2.h,
                              color: AppColors.greyColor.withOpacity(0.3),
                            ),
                          ),

                          // Delivered
                          Container(
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: AppColors.greyColor.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 16.sp,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            'Preparing items',
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          customText(
                            'Out for delivery',
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          customText(
                            'Delivered',
                            fontSize: 12.sp,
                            color: AppColors.greyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // Delivery Person Info
                      Container(
                        padding: EdgeInsets.all(16.sp),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            // Delivery person avatar
                            CircleAvatar(
                              radius: 25.r,
                              backgroundColor: AppColors.greyColor.withOpacity(0.3),
                              child: Icon(
                                Icons.person,
                                size: 25.sp,
                                color: AppColors.greyColor,
                              ),
                            ),
                            SizedBox(width: 16.w),

                            // Delivery person details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    cartController.deliveryPersonName.value,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 16.sp,
                                        color: AppColors.secondaryColor,
                                      ),
                                      SizedBox(width: 4.w),
                                      customText(
                                        cartController.deliveryPersonRating.value.toString(),
                                        fontSize: 14.sp,
                                        color: AppColors.blackColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  customText(
                                    'Arriving at ${cartController.estimatedArrival.value}',
                                    fontSize: 12.sp,
                                    color: AppColors.greyColor,
                                  ),
                                ],
                              ),
                            ),

                            // Action buttons
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.message,
                                    size: 20.sp,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.all(8.sp),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.call,
                                    size: 20.sp,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ],
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
        );
      },
    );
  }
}