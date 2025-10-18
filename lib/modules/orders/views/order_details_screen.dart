import 'package:gosharpsharp/core/models/order_model.dart';
import 'package:gosharpsharp/modules/orders/controllers/orders_controller.dart';
import 'package:gosharpsharp/modules/orders/views/widgets/order_detail_summary_item.dart';
import 'package:gosharpsharp/modules/orders/views/widgets/order_detail_package_item.dart';
import 'package:gosharpsharp/modules/orders/views/widgets/order_detail_menu_item.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/utils/exports.dart';

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
                    ],
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

                  // Order Status Actions - only show if not completed or cancelled
                  if (![
                    'completed',
                    'cancelled',
                  ].contains(order.status.toLowerCase()))
                    SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return AppColors.greenColor;
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return AppColors.greenColor;
      case 'in_transit':
        return AppColors.primaryColor;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }

  IconData _getNextActionIcon(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        return Icons.restaurant_menu;
      case 'preparing':
        return Icons.check_circle_outline;
      case 'ready':
        return Icons.local_shipping_outlined;
      case 'in_transit':
        return Icons.done_all;
      default:
        return Icons.arrow_forward;
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
