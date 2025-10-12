import 'package:gosharpsharp/core/models/order_model.dart';
import 'package:gosharpsharp/modules/orders/controllers/orders_controller.dart';
import '../../../core/utils/exports.dart';
import '../../../core/widgets/skeleton_loaders.dart';

class OrdersHomeScreen extends GetView<OrdersController> {
  const OrdersHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
      builder: (ordersController) {
        return Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              implyLeading: true,
              centerTitle: true,
              title: "Orders",
              onPop: () {
                // Navigate back to APP_NAVIGATION to avoid controller errors
                Get.offAllNamed(Routes.APP_NAVIGATION);
              },
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
                    onRefresh: () async {
                      await ordersController.refreshOrders();
                    },
                    color: AppColors.primaryColor,
                    backgroundColor: AppColors.whiteColor,
                    strokeWidth: 2.5,
                    displacement: 40.0,
                    child: ordersController.isLoadingOrders
                        ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              child: SkeletonLoaders.orderItem(count: 1),
                            ),
                          )
                        : ordersController.filteredOrders.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 100.h),
                              _buildEmptyState(ordersController.selectedOrderStatus),
                            ],
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: ordersController.filteredOrders.length,
                            separatorBuilder: (context, index) => SizedBox(height: 12.h),
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
      default:
        return status.toUpperCase();
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.payment;
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
      case 'paid':
        return 'Paid orders will appear here when payment is confirmed';
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

// Beautiful Flat OrderCard Widget
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: _getStatusColor(order.status).withOpacity(0.15),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section: Status badge and amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(order.status),
                          color: AppColors.whiteColor,
                          size: 14.sp,
                        ),
                        SizedBox(width: 6.w),
                        customText(
                          _getStatusDisplayText(order.status),
                          color: AppColors.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  customText(
                    controller.formatCurrency(order.total),
                    color: AppColors.blackColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Order reference and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    "Order #${order.ref}",
                    color: AppColors.blackColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  customText(
                    controller.formatOrderTime(order.createdAt),
                    color: AppColors.greyColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Customer info section
              Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: customText(
                        _getCustomerInitial(),
                        color: _getStatusColor(order.status),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          _getCustomerName(),
                          color: AppColors.blackColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        if (order.items.isNotEmpty)
                          customText(
                            "${order.items.length} item${order.items.length > 1 ? 's' : ''} • ${order.items.map((e) => e.quantity).reduce((a, b) => a + b)} qty",
                            color: AppColors.greyColor,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              // Items preview
              if (order.items.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        color: AppColors.greyColor,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: customText(
                          order.items.first.orderable.name +
                          (order.items.length > 1 ? " + ${order.items.length - 1} more" : ""),
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Delivery address or notes
              if (order.deliveryLocation != null || order.notes.isNotEmpty) ...[
                SizedBox(height: 8.h),
                if (order.deliveryLocation != null)
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.greyColor,
                        size: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: customText(
                          order.deliveryLocation!.name,
                          color: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                if (order.notes.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.sticky_note_2,
                        color: AppColors.greyColor,
                        size: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: customText(
                          order.notes,
                          color: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.payment;
      case 'pending':
        return Icons.schedule;
      case 'preparing':
        return Icons.restaurant;
      case 'ready':
        return Icons.check_circle;
      case 'in_transit':
        return Icons.local_shipping;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
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

  // Helper methods to get customer info from current user profile
  String _getCustomerName() {
    final settingsController = Get.find<SettingsController>();
    final profile = settingsController.userProfile;
    return profile != null ? "${profile.fname} ${profile.lname}".trim() : "Customer";
  }

  String _getCustomerInitial() {
    final settingsController = Get.find<SettingsController>();
    final profile = settingsController.userProfile;
    return (profile?.fname.isNotEmpty == true ? profile!.fname[0] : 'U').toUpperCase();
  }
}