import 'package:flutter/material.dart';
import 'package:gosharpsharp/core/models/order_model.dart';
import '../../../core/utils/exports.dart';

class OrderStatusTrackingScreen extends StatefulWidget {
  final OrderModel order;

  const OrderStatusTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderStatusTrackingScreen> createState() => _OrderStatusTrackingScreenState();
}

class _OrderStatusTrackingScreenState extends State<OrderStatusTrackingScreen> {
  SocketService? _socketService;
  late OrderModel _currentOrder;

  // Order status progression
  final List<String> _orderStatuses = [
    'pending',
    'paid',
    'accepted',
    'preparing',
    'ready',
    'picked',
    'in_transit',
    'delivered',
  ];

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
    _initializeTracking();
  }

  void _initializeTracking() {
    try {
      if (Get.isRegistered<SocketService>()) {
        _socketService = Get.find<SocketService>();

        // Join order tracking room
        _socketService?.joinFoodOrderTracking(_currentOrder.orderNumber);

        // Listen for order status updates
        _socketService?.listenForOrderStatusUpdate((data) {
          if (mounted) {
            final newStatus = data['status']?.toString() ?? _currentOrder.status;

            setState(() {
              // Update order status from WebSocket
              _currentOrder = _currentOrder.copyWith(status: newStatus);
            });

            showToast(
              message: 'Order status updated to ${_getStatusDisplayName(newStatus)}',
              isError: false,
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error initializing order tracking: $e');
    }
  }

  @override
  void dispose() {
    // Leave tracking room and stop listening when screen is closed
    _socketService?.leaveFoodOrderTracking(_currentOrder.orderNumber);
    _socketService?.stopListeningForOrderStatusUpdate();
    super.dispose();
  }

  int _getCurrentStatusIndex() {
    final currentStatus = _currentOrder.status.toLowerCase();
    final index = _orderStatuses.indexOf(currentStatus);
    return index >= 0 ? index : 0;
  }

  bool _isStatusCompleted(String status) {
    final currentIndex = _getCurrentStatusIndex();
    final statusIndex = _orderStatuses.indexOf(status.toLowerCase());
    return statusIndex <= currentIndex;
  }

  bool _isStatusCurrent(String status) {
    return _currentOrder.status.toLowerCase() == status.toLowerCase();
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Payment';
      case 'paid':
        return 'Payment Confirmed';
      case 'accepted':
        return 'Order Accepted';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready for Pickup';
      case 'picked':
        return 'Picked Up';
      case 'in_transit':
        return 'On the Way';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending_outlined;
      case 'paid':
        return Icons.payment;
      case 'accepted':
        return Icons.check_circle_outline;
      case 'preparing':
        return Icons.restaurant_menu;
      case 'ready':
        return Icons.shopping_bag_outlined;
      case 'picked':
        return Icons.local_shipping_outlined;
      case 'in_transit':
        return Icons.delivery_dining;
      case 'delivered':
        return Icons.done_all;
      default:
        return Icons.circle_outlined;
    }
  }

  void _handlePendingStatus() {
    // Navigate to checkout for pending orders
    showToast(
      message: 'Please complete payment to continue',
      isError: false,
    );

    // Navigate to checkout screen
    Get.offNamed(Routes.CHECKOUT_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    // Handle pending status
    if (_currentOrder.status.toLowerCase() == 'pending') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handlePendingStatus();
      });
    }

    final currentStatusIndex = _getCurrentStatusIndex();
    final isCancelled = _currentOrder.status.toLowerCase() == 'cancelled' ||
        _currentOrder.status.toLowerCase() == 'rejected';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: () => Get.back(),
        ),
        title: customText(
          'Track Order',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order Info Card
            Container(
              margin: EdgeInsets.all(16.sp),
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              'Order Number',
                              fontSize: 12.sp,
                              color: AppColors.obscureTextColor,
                            ),
                            SizedBox(height: 4.h),
                            customText(
                              _currentOrder.orderNumber,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(_currentOrder.status),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: customText(
                          _getStatusDisplayName(_currentOrder.status),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: getStatusTextColor(_currentOrder.status),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: AppColors.greyColor.withOpacity(0.2)),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            'Restaurant',
                            fontSize: 12.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          SizedBox(height: 4.h),
                          customText(
                            _currentOrder.restaurantName,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          customText(
                            'Total Amount',
                            fontSize: 12.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          SizedBox(height: 4.h),
                          customText(
                            formatToCurrency(_currentOrder.total),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (_currentOrder.deliveryLocation != null) ...[
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16.sp,
                          color: AppColors.obscureTextColor,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: customText(
                            _currentOrder.deliveryLocation!.name,
                            fontSize: 12.sp,
                            color: AppColors.obscureTextColor,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Status Timeline
            if (!isCancelled) ...[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.sp),
                padding: EdgeInsets.all(20.sp),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      'Order Progress',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 24.h),
                    // Timeline items - skip pending if already past it
                    ..._orderStatuses.skip(1).map((status) {
                      final isCompleted = _isStatusCompleted(status);
                      final isCurrent = _isStatusCurrent(status);
                      final isLast = status == _orderStatuses.last;

                      return _buildTimelineItem(
                        status: status,
                        isCompleted: isCompleted,
                        isCurrent: isCurrent,
                        isLast: isLast,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ] else ...[
              // Cancelled/Rejected State
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.sp),
                padding: EdgeInsets.all(24.sp),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.cancel_outlined,
                      size: 64.sp,
                      color: AppColors.redColor,
                    ),
                    SizedBox(height: 16.h),
                    customText(
                      'Order ${_getStatusDisplayName(_currentOrder.status)}',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    customText(
                      'This order has been ${_currentOrder.status.toLowerCase()}. Please contact support if you have any questions.',
                      fontSize: 14.sp,
                      color: AppColors.obscureTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 24.h),

            // Order Items
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.sp),
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    'Order Items (${_currentOrder.totalItems})',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 16.h),
                  ..._currentOrder.items.map((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Row(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.h,
                            decoration: BoxDecoration(
                              color: AppColors.greyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: item.image.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      item.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.restaurant, color: AppColors.greyColor),
                                    ),
                                  )
                                : Icon(Icons.restaurant, color: AppColors.greyColor),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  item.name,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                ),
                                SizedBox(height: 4.h),
                                customText(
                                  'Qty: ${item.quantity}',
                                  fontSize: 12.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                              ],
                            ),
                          ),
                          customText(
                            formatToCurrency(item.totalPrice),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            SizedBox(height: 80.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String status,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted
                    ? Icons.check
                    : _getStatusIcon(status),
                size: 20.sp,
                color: isCompleted || isCurrent
                    ? AppColors.whiteColor
                    : AppColors.greyColor,
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color: isCompleted
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withOpacity(0.2),
              ),
          ],
        ),
        SizedBox(width: 16.w),
        // Status info
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  _getStatusDisplayName(status),
                  fontSize: 15.sp,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                  color: isCompleted || isCurrent
                      ? AppColors.blackColor
                      : AppColors.obscureTextColor,
                ),
                if (isCurrent) ...[
                  SizedBox(height: 4.h),
                  customText(
                    'Current Status',
                    fontSize: 12.sp,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
