import 'package:gosharpsharp/core/models/order_model.dart';
import 'package:gosharpsharp/modules/orders/controllers/orders_controller.dart';
import 'package:gosharpsharp/modules/orders/views/widgets/order_detail_summary_item.dart';
import 'package:gosharpsharp/modules/orders/views/widgets/order_detail_package_item.dart';
import 'package:gosharpsharp/modules/orders/views/widgets/order_detail_menu_item.dart';
import 'package:gosharpsharp/modules/orders/views/order_status_tracking_screen.dart';
import '../../../core/utils/exports.dart';
import 'package:gosharpsharp/core/widgets/animated_star_rating.dart';

class OrderDetailsScreen extends GetView<OrdersController> {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (ordersController) {
        final order = ordersController.selectedOrder;

        if (order == null) {
          return Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              onPop: () => Get.back(),
              title: "Order Details",
            ),
            body: const Center(child: Text("Order not found")),
          );
        }

        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Order Details",
            implyLeading: true,
            centerTitle: false,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Main Order Details Section
                  SectionBox(
                    children: [
                      OrderDetailSummaryItem(
                        title: "Order Number",
                        value: order.orderNumber,
                      ),
                      OrderDetailSummaryStatusItem(
                        title: "Status",
                        value: _getStatusDisplayText(order.status),
                        status: order.status,
                      ),
                      OrderDetailSummaryItem(
                        title: "Total",
                        value: formatToCurrency(order.total),
                      ),
                      OrderDetailSummaryItem(
                        title: "Order Date",
                        value:
                            "${formatDate(order.createdAt.toIso8601String())} ${formatTime(order.createdAt.toIso8601String())}",
                      ),
                      if (order.paymentMethodString != null &&
                          order.paymentMethodString!.isNotEmpty)
                        OrderDetailSummaryItem(
                          title: "Payment Method",
                          value: order.paymentMethodName,
                        ),
                      if (order.notes.isNotEmpty)
                        OrderDetailSummaryItem(
                          title: "Notes",
                          value: order.notes,
                          isVertical: true,
                        ),
                      if (order.deliveryCode != null &&
                          order.deliveryCode!.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(top: 12.h),
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.primaryColor.withAlpha(100),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified_user_rounded,
                                    color: AppColors.primaryColor,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  customText(
                                    "Delivery Verification Code",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customText(
                                      order.deliveryCode!,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primaryColor,
                                      letterSpacing: 4,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: AppColors.greyColor,
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  Expanded(
                                    child: customText(
                                      "Show this code to the rider to confirm delivery of your order",
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.greyColor,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Rating Section - Rider (show only when status is completed and not yet rated)
                  if (order.status.toLowerCase() == 'completed' &&
                      order.riderRating == null)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.greyColor.withAlpha(50),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: AppColors.primaryColor,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              customText(
                                "Rate your rider",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          AnimatedStarRating(
                            onRatingSelected: (rating) {
                              ordersController.setRiderRating(rating.toDouble());
                            },
                          ),
                          SizedBox(height: 16.h),
                          CustomButton(
                            title: 'Submit Rating',
                            backgroundColor: AppColors.primaryColor,
                            fontColor: AppColors.whiteColor,
                            width: double.infinity,
                            height: 45,
                            fontSize: 14,
                            isBusy: ordersController.ratingOrder,
                            onPressed: () {
                              if (ordersController.riderRating > 0) {
                                ordersController.rateOrder(context, 'delivery');
                              } else {
                                ModernSnackBar.showInfo(
                                  context,
                                  message: "Please select a rating",
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                  if (order.status.toLowerCase() == 'completed' &&
                      order.riderRating == null)
                    SizedBox(height: 12.h),

                  // Rating Section - Restaurant (show only when status is completed and not yet rated)
                  if (order.status.toLowerCase() == 'completed' &&
                      order.restaurantRating == null)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.greyColor.withAlpha(50),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: AppColors.primaryColor,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              customText(
                                "Rate ${order.orderable?.name ?? 'restaurant'}",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          AnimatedStarRating(
                            onRatingSelected: (rating) {
                              ordersController.setRestaurantRating(rating.toDouble());
                            },
                          ),
                          SizedBox(height: 16.h),
                          CustomButton(
                            title: 'Submit Rating',
                            backgroundColor: AppColors.primaryColor,
                            fontColor: AppColors.whiteColor,
                            width: double.infinity,
                            height: 45,
                            fontSize: 14,
                            isBusy: ordersController.ratingOrder,
                            onPressed: () {
                              if (ordersController.restaurantRating > 0) {
                                ordersController.rateOrder(context, 'order');
                              } else {
                                ModernSnackBar.showInfo(
                                  context,
                                  message: "Please select a rating",
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 12.h),

                  // Order Items Section
                  if (order.packages.isNotEmpty)
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: customText(
                            "Order Items (${order.packages.length} Package${order.packages.length > 1 ? 's' : ''})",
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Display packages
                        ...order.packages.map((package) {
                          return Column(
                            children: [
                              // Package header
                              OrderDetailPackageItem(
                                packageName: package.name,
                                quantity: package.quantity,
                                price: formatToCurrency(package.total),
                              ),
                              SizedBox(height: 4.h),

                              // Package items
                              ...package.items.map((item) {
                                return OrderDetailMenuItem(
                                  name: item.orderable.name,
                                  imageUrl: item.orderable.files.isNotEmpty
                                      ? item.orderable.files.first.url
                                      : null,
                                  quantity: item.quantity,
                                  price: formatToCurrency(item.total),
                                  description: item.orderable.description,
                                  plateSize: item.orderable.plateSize,
                                );
                              }),

                              SizedBox(height: 8.h),
                            ],
                          );
                        }),
                      ],
                    )
                  else if (order.allItems.isNotEmpty)
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: customText(
                            "Order Items (${order.allItems.length})",
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        // Display all items
                        ...order.allItems.map((item) {
                          return OrderDetailMenuItem(
                            name: item.name,
                            imageUrl: item.image,
                            quantity: item.quantity,
                            price: formatToCurrency(item.total),
                            description: item.orderable.description,
                            plateSize: item.orderable.plateSize,
                          );
                        }),
                      ],
                    ),

                  SizedBox(height: 12.h),

                  // Price Breakdown Section
                  SectionBox(
                    children: [
                      // Section Header
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 12.h,
                        ),
                        child: customText(
                          "Price Breakdown",
                          fontSize: 16.sp,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      OrderDetailSummaryItem(
                        title: "Subtotal",
                        value: formatToCurrency(order.subtotal),
                      ),
                      if (order.tax > 0)
                        OrderDetailSummaryItem(
                          title: "Tax",
                          value: formatToCurrency(order.tax),
                        ),
                      if (order.deliveryFee > 0)
                        OrderDetailSummaryItem(
                          title: "Delivery Fee",
                          value: formatToCurrency(order.deliveryFee),
                        ),
                      if (order.discountAmount > 0)
                        OrderDetailSummaryItem(
                          title: "Discount",
                          value: "- ${formatToCurrency(order.discountAmount)}",
                        ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        height: 1,
                        color: AppColors.greyColor.withAlpha(50),
                      ),
                      OrderDetailSummaryItem(
                        title: "Total",
                        value: formatToCurrency(order.total),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Restaurant Information Section
                  if (order.orderable != null)
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: customText(
                            "Restaurant Information",
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        OrderDetailSummaryItem(
                          title: "Name",
                          value: order.orderable!.name,
                        ),
                        if (order.orderable!.cuisineType?.isNotEmpty ?? false)
                          OrderDetailSummaryItem(
                            title: "Cuisine Type",
                            value: order.orderable!.cuisineType!,
                          ),
                      ],
                    ),

                  SizedBox(height: 12.h),

                  // Delivery Information Section
                  if (order.deliveryLocation != null)
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: customText(
                            "Delivery Information",
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        OrderDetailSummaryItem(
                          title: "Delivery Type",
                          value: order.deliveryType.toUpperCase(),
                        ),
                        OrderDetailSummaryItem(
                          title: "Delivery Address",
                          value: order.deliveryLocation!.name,
                          isVertical: true,
                        ),
                        if (order.deliveryInstructions != null &&
                            order.deliveryInstructions!.isNotEmpty)
                          OrderDetailSummaryItem(
                            title: "Delivery Instructions",
                            value: order.deliveryInstructions!,
                            isVertical: true,
                          ),
                      ],
                    ),

                  SizedBox(height: 12.h),

                  // Action Buttons based on order status
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _buildActionButtons(order, ordersController),
                  ),

                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build action buttons based on order status
  Widget _buildActionButtons(OrderModel order, OrdersController ordersController) {
    final status = order.status.toLowerCase();

    // For pending, failed, cancelled, or rejected orders, don't show any action buttons
    if (['pending', 'failed', 'cancelled', 'rejected'].contains(status)) {
      return const SizedBox.shrink();
    }

    // For paid and active orders (preparing, ready, in_transit, etc.), show Track Order button
    return CustomButton(
      title: 'Track Order',
      backgroundColor: AppColors.primaryColor,
      fontColor: AppColors.whiteColor,
      width: double.infinity,
      height: 50,
      fontSize: 16,
      isBusy: ordersController.isLoadingOrderDetails,
      onPressed: () async {
        // Fetch latest order details before tracking
        await _fetchLatestOrderAndTrack(order, ordersController);
      },
    );
  }

  // Fetch latest order details and navigate to tracking
  Future<void> _fetchLatestOrderAndTrack(OrderModel order, OrdersController ordersController) async {
    try {
      // Show loading state
      ordersController.setLoadingOrderDetails(true);

      // Fetch latest order details
      await ordersController.getOrderById(order.id);

      // Get the updated order
      final updatedOrder = ordersController.selectedOrder;

      if (updatedOrder != null) {
        // Navigate to tracking with latest data
        Get.to(
          () => OrderStatusTrackingScreen(order: updatedOrder),
          transition: Transition.rightToLeft,
        );
      } else {
        showToast(
          message: "Could not load latest order details",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Error fetching latest order details: $e');
      showToast(
        message: "Could not load latest order details. Please try again.",
        isError: true,
      );
    } finally {
      ordersController.setLoadingOrderDetails(false);
    }
  }

  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready';
      case 'in_transit':
        return 'In Transit';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

}
