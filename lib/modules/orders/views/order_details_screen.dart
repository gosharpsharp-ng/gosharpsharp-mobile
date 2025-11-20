import 'package:gosharpsharp/core/models/order_model.dart';
import 'package:gosharpsharp/modules/orders/controllers/orders_controller.dart';
import 'package:gosharpsharp/modules/orders/views/widgets/order_detail_summary_item.dart';
import 'package:gosharpsharp/modules/orders/views/widgets/order_detail_package_item.dart';
import 'package:gosharpsharp/modules/orders/views/widgets/order_detail_menu_item.dart';
import 'package:gosharpsharp/modules/orders/views/order_status_tracking_screen.dart';
import 'package:url_launcher/url_launcher.dart';
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(
                                "Restaurant Information",
                                fontSize: 16.sp,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w600,
                              ),
                              // Call button
                              if (order.orderable!.phone.isNotEmpty)
                                InkWell(
                                  onTap: () =>
                                      _callRestaurant(order.orderable!.phone),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withAlpha(
                                        25,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: AppColors.primaryColor,
                                          size: 14.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        customText(
                                          "Call",
                                          color: AppColors.primaryColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        OrderDetailSummaryItem(
                          title: "Name",
                          value: order.orderable!.name,
                        ),
                        if (order.orderable!.phone.isNotEmpty)
                          OrderDetailSummaryItem(
                            title: "Phone",
                            value: order.orderable!.phone,
                          ),
                        if (order.orderable!.email.isNotEmpty)
                          OrderDetailSummaryItem(
                            title: "Email",
                            value: order.orderable!.email,
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

    // For pending orders, show Continue Payment, Cancel and Dispute options
    if (status == 'pending') {
      return Column(
        children: [
          CustomButton(
            title: 'Continue Payment',
            backgroundColor: AppColors.primaryColor,
            fontColor: AppColors.whiteColor,
            width: double.infinity,
            height: 50,
            fontSize: 16,
            onPressed: () {
              // Navigate to payment screen
              // TODO: Implement payment continuation
              showToast(
                message: "Payment continuation coming soon",
                isError: false,
              );
            },
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: 'Cancel Order',
                  backgroundColor: AppColors.whiteColor,
                  fontColor: AppColors.redColor,
                  height: 50,
                  fontSize: 14,
                  borderColor: AppColors.redColor,
                  onPressed: () {
                    _showCancelDialog(order);
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomButton(
                  title: 'Dispute Order',
                  backgroundColor: AppColors.whiteColor,
                  fontColor: AppColors.orangeColor,
                  height: 50,
                  fontSize: 14,
                  borderColor: AppColors.orangeColor,
                  onPressed: () {
                    _showDisputeDialog(order);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }

    // For cancelled/rejected orders, don't show any action buttons
    if (['cancelled', 'rejected'].contains(status)) {
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

  // Show cancel order dialog
  void _showCancelDialog(OrderModel order) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: customText(
          'Cancel Order',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              'Are you sure you want to cancel this order?',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
            SizedBox(height: 12.h),
            customText(
              'Order #${order.orderNumber}',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: customText(
              'Go Back',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // TODO: Implement cancel order logic
              showToast(
                message: "Cancel order feature coming soon",
                isError: false,
              );
            },
            child: customText(
              'Yes, Cancel',
              fontSize: 14.sp,
              color: AppColors.redColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Show dispute dialog
  void _showDisputeDialog(OrderModel order) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: customText(
          'Dispute Order',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              'Are you sure you want to dispute this order?',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
            SizedBox(height: 12.h),
            customText(
              'Order #${order.orderNumber}',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: customText(
              'Go Back',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // TODO: Implement dispute logic
              showToast(
                message: "Dispute feature coming soon",
                isError: false,
              );
            },
            child: customText(
              'Yes, Dispute',
              fontSize: 14.sp,
              color: AppColors.orangeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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

  void _callRestaurant(String phoneNumber) async {
    try {
      // Remove any non-numeric characters except + for international format
      String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

      // Ensure the number starts with a + for international format
      if (!cleanedNumber.startsWith('+')) {
        // Assuming Nigerian numbers, add country code if not present
        if (cleanedNumber.startsWith('0')) {
          cleanedNumber = '+234${cleanedNumber.substring(1)}';
        } else if (cleanedNumber.length == 10) {
          cleanedNumber = '+234$cleanedNumber';
        } else {
          cleanedNumber = '+$cleanedNumber';
        }
      }

      final Uri phoneUri = Uri(scheme: 'tel', path: cleanedNumber);

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        showToast(
          message:
              "Unable to make phone call. Please try again or contact manually: $cleanedNumber",
          isError: true,
        );
      }
    } catch (e) {
      showToast(
        message: "Error initiating phone call: ${e.toString()}",
        isError: true,
      );
    }
  }
}
