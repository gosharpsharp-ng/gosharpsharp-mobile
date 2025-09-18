import 'package:gosharpsharp/core/models/order_model.dart';
import 'package:gosharpsharp/modules/orders/controllers/orders_controller.dart';
import '../../../core/utils/exports.dart';

class OrdersHomeScreen extends GetView<OrdersController> {
  const OrdersHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (ordersController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            implyLeading: false,
            centerTitle: true,
            title: "Orders",
            actionItem: IconButton(
              onPressed: () {
                // Refresh orders
                ordersController.refreshOrders();
              },
              icon: Icon(
                Icons.refresh,
                color: AppColors.blackColor,
                size: 24.sp,
              ),
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp),
            height: 1.sh,
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // Status Filter Tabs
                Container(
                  height: 45.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: ordersController.orderStatuses.length,
                    separatorBuilder: (context, index) => SizedBox(width: 16.w),
                    itemBuilder: (context, index) {
                      final status = ordersController.orderStatuses[index];
                      final isSelected = ordersController.selectedOrderStatus == status;
                      final orderCount = ordersController.getOrderCountByStatus(status);
                      final displayName = _getStatusDisplayName(status);

                      return InkWell(
                        onTap: () {
                          ordersController.setSelectedOrderStatus(status);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.greyColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              customText(
                                displayName,
                                color: isSelected
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              if (orderCount > 0) ...[
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.whiteColor
                                        : AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: customText(
                                    orderCount.toString(),
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.whiteColor,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 24.h),

                // Orders List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ordersController.refreshOrders(),
                    color: AppColors.primaryColor,
                    child: ordersController.isLoadingOrders
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                        : ordersController.filteredOrders.isEmpty
                        ? _buildEmptyState(ordersController.selectedOrderStatus)
                        : ListView.separated(
                      itemCount: ordersController.filteredOrders.length,
                      separatorBuilder: (context, index) => SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final order = ordersController.filteredOrders[index];
                        return OrderCard(
                          order: order,
                          onTap: () {
                            ordersController.setSelectedOrder(order);
                            Get.toNamed(Routes.ORDER_DETAILS_SCREEN);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(status),
              size: 40.sp,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 16.h),
          customText(
            "No ${_getStatusDisplayName(status).toLowerCase()} orders",
            color: AppColors.greyColor,
            overflow: TextOverflow.visible,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          customText(
            _getEmptyStateMessage(status),
            color: AppColors.greyColor,
            overflow: TextOverflow.visible,
            fontSize: 14.sp,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
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
      default:
        return status.toUpperCase();
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.check_circle_outline;
      case 'in_transit':
        return Icons.local_shipping;
      case 'completed':
        return Icons.done_all;
      default:
        return Icons.receipt;
    }
  }

  String _getEmptyStateMessage(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'New orders will appear here when customers place them';
      case 'preparing':
        return 'Orders you\'ve accepted will show here while being prepared';
      case 'ready':
        return 'Completed orders ready for pickup/delivery will appear here';
      case 'in_transit':
        return 'Orders out for delivery will be tracked here';
      case 'completed':
        return 'Successfully completed orders will be listed here';
      default:
        return 'Orders will appear here when customers place them';
    }
  }
}

// Updated OrderCard Widget
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _getStatusColor(order.status).withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: customText(
                            (order.user.fname.isNotEmpty ? order.user.fname[0] : 'U').toUpperCase(),
                            color: AppColors.primaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: customText(
                          order.user.fname.isNotEmpty ? order.user.fname : 'Customer',
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    customText(
                      controller.formatCurrency(order.total),
                      color: AppColors.blackColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    customText(
                      controller.formatOrderTime(order.createdAt),
                      color: AppColors.greyColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // Order ID and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  "Order #${order.ref}",
                  color: AppColors.greyColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: customText(
                    _getStatusDisplayText(order.status),
                    color: _getStatusColor(order.status),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Order items preview
            if (order.items.isNotEmpty) ...[
              Row(
                children: [
                  // Items description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          order.items.first.orderable.name,
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        customText(
                          "${order.items.length} item${order.items.length > 1 ? 's' : ''} • ${order.items.map((e) => e.quantity).reduce((a, b) => a + b)} qty",
                          color: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),
            ],

            // Delivery address (if available)
            if (order.deliveryLocation != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.greyColor,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: customText(
                      order.deliveryLocation!.name,
                      color: AppColors.greyColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            // Optional: Show order notes if available
            if (order.notes.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.note_outlined,
                    color: AppColors.greyColor,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: customText(
                      "Note: ${order.notes}",
                      color: AppColors.greyColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.normal,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'preparing':
        return Colors.blue;
      case 'ready':
        return Colors.green;
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

  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
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