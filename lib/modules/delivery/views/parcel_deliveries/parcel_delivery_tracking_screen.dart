import 'package:gosharpsharp/core/utils/exports.dart';

class ParcelDeliveryTrackingScreen extends StatefulWidget {
  const ParcelDeliveryTrackingScreen({super.key});

  @override
  State<ParcelDeliveryTrackingScreen> createState() =>
      _ParcelDeliveryTrackingScreenState();
}

class _ParcelDeliveryTrackingScreenState
    extends State<ParcelDeliveryTrackingScreen> {
  SocketService? _socketService;
  late Map<String, dynamic> _currentDelivery;
  final DeliveriesController _deliveriesController =
      Get.find<DeliveriesController>();

  // Delivery status progression
  final List<String> _deliveryStatuses = [
    'pending',
    'confirmed',
    'accepted',
    'picked',
    'in_transit',
    'delivered',
  ];

  @override
  void initState() {
    super.initState();
    _currentDelivery = _deliveriesController.selectedParcelDelivery ?? {};
    _initializeTracking();
  }

  void _initializeTracking() {
    try {
      if (Get.isRegistered<SocketService>()) {
        _socketService = Get.find<SocketService>();

        final trackingId = _currentDelivery['tracking_id'];
        if (trackingId != null) {
          // Join parcel delivery tracking room
          _socketService?.joinParcelDeliveryTracking(trackingId);

          // Listen for delivery status updates
          _socketService?.listenForDeliveryStatusUpdate((data) {
            if (mounted) {
              final newStatus =
                  data['status']?.toString() ?? _currentDelivery['status'];

              setState(() {
                _currentDelivery['status'] = newStatus;
                // Update rider info if available
                if (data['rider'] != null) {
                  _currentDelivery['rider'] = data['rider'];
                }
              });

              showToast(
                message:
                    'Delivery status updated to ${_getStatusDisplayName(newStatus)}',
                isError: false,
              );
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing delivery tracking: $e');
    }
  }

  @override
  void dispose() {
    // Leave tracking room and stop listening when screen is closed
    final trackingId = _currentDelivery['tracking_id'];
    if (trackingId != null) {
      _socketService?.leaveParcelDeliveryTracking(trackingId);
      _socketService?.stopListeningForDeliveryStatusUpdate();
    }
    super.dispose();
  }

  int _getCurrentStatusIndex() {
    final currentStatus =
        _currentDelivery['status']?.toString().toLowerCase() ?? 'pending';
    final index = _deliveryStatuses.indexOf(currentStatus);
    return index >= 0 ? index : 0;
  }

  bool _isStatusCompleted(String status) {
    final currentIndex = _getCurrentStatusIndex();
    final statusIndex = _deliveryStatuses.indexOf(status.toLowerCase());
    return statusIndex <= currentIndex;
  }

  bool _isStatusCurrent(String status) {
    final currentStatus =
        _currentDelivery['status']?.toString().toLowerCase() ?? 'pending';
    return currentStatus == status.toLowerCase();
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'accepted':
        return 'Accepted by Rider';
      case 'picked':
        return 'Picked Up';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
      case 'canceled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.pending_outlined;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'accepted':
        return Icons.person_pin_circle_outlined;
      case 'picked':
        return Icons.shopping_bag_outlined;
      case 'in_transit':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.done_all;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'accepted':
        return AppColors.primaryColor;
      case 'picked':
        return AppColors.primaryColor;
      case 'in_transit':
        return AppColors.primaryColor;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
      case 'canceled':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStatusIndex = _getCurrentStatusIndex();
    final isCancelled =
        _currentDelivery['status']?.toString().toLowerCase() == 'cancelled' ||
        _currentDelivery['status']?.toString().toLowerCase() == 'canceled';

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
          'Track Delivery',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Delivery Info Card
            Container(
              margin: EdgeInsets.all(16.sp),
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackColor.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
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
                              'Tracking ID',
                              fontSize: 12.sp,
                              color: AppColors.obscureTextColor,
                            ),
                            SizedBox(height: 4.h),
                            customText(
                              _currentDelivery['tracking_id'] ?? 'N/A',
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
                          color: _getStatusColor(
                            _currentDelivery['status'] ?? 'pending',
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: customText(
                          _getStatusDisplayName(
                            _currentDelivery['status'] ?? 'pending',
                          ),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: AppColors.greyColor.withValues(alpha: 0.2)),
                  SizedBox(height: 16.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // From location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24.sp,
                            height: 24.sp,
                            decoration: BoxDecoration(
                              color: AppColors.greenColor.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.circle,
                              color: AppColors.greenColor,
                              size: 10.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  'From',
                                  fontSize: 12.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                                SizedBox(height: 4.h),
                                customText(
                                  _currentDelivery['pickup_location']?['name'] ??
                                      'N/A',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Dotted line connector
                      Padding(
                        padding: EdgeInsets.only(left: 11.w),
                        child: Container(
                          width: 2.w,
                          height: 20.h,
                          color: AppColors.greyColor.withValues(alpha: 0.3),
                        ),
                      ),
                      // To location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24.sp,
                            height: 24.sp,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: AppColors.primaryColor,
                              size: 14.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  'To',
                                  fontSize: 12.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                                SizedBox(height: 4.h),
                                customText(
                                  _currentDelivery['destination_location']?['name'] ??
                                      'N/A',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.blackColor,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            'Distance',
                            fontSize: 12.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          SizedBox(height: 4.h),
                          customText(
                            '${_currentDelivery['distance']?.toString() ?? '0'} km',
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
                            'Delivery Cost',
                            fontSize: 12.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          SizedBox(height: 4.h),
                          customText(
                            _formatCurrency(
                              _currentDelivery['cost']?.toString() ?? '0',
                            ),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delivery Verification Code Section
            if (_currentDelivery['delivery_code'] != null &&
                _currentDelivery['delivery_code'].toString().isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.sp),
                padding: EdgeInsets.all(16.sp),
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
                            _currentDelivery['delivery_code'].toString(),
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
                            "Share this code with the rider to confirm delivery of your parcel",
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

            if (_currentDelivery['delivery_code'] != null &&
                _currentDelivery['delivery_code'].toString().isNotEmpty)
              SizedBox(height: 16.h),

            // Rider Information Card (if rider is assigned)
            if (_currentDelivery['rider'] != null &&
                ['accepted', 'picked', 'in_transit'].contains(
                  _currentDelivery['status']?.toString().toLowerCase(),
                ))
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.sp),
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      'Rider Information',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: AppColors.backgroundColor,
                          child: Icon(
                            Icons.person,
                            size: 28.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                '${_currentDelivery['rider']?['first_name'] ?? ''} ${_currentDelivery['rider']?['last_name'] ?? ''}',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(height: 4.h),
                              customText(
                                _currentDelivery['rider']?['phone'] ?? 'N/A',
                                fontSize: 13.sp,
                                color: AppColors.obscureTextColor,
                              ),
                            ],
                          ),
                        ),
                        if (_currentDelivery['rider']?['phone'] != null)
                          InkWell(
                            onTap: () {
                              // TODO: Implement call rider functionality
                              showToast(
                                message: "Call rider feature coming soon",
                                isError: false,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.sp),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.phone,
                                color: AppColors.primaryColor,
                                size: 20.sp,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

            // Awaiting Rider Card (if no rider assigned yet)
            if (_currentDelivery['rider'] == null &&
                ['confirmed', 'pending'].contains(
                  _currentDelivery['status']?.toString().toLowerCase(),
                ))
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.sp),
                padding: EdgeInsets.all(20.sp),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.sp),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.orange,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            'Finding a rider',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          SizedBox(height: 4.h),
                          customText(
                            'We\'re connecting you to the nearest available rider',
                            fontSize: 13.sp,
                            color: AppColors.obscureTextColor,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 16.h),

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
                      color: AppColors.blackColor.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      'Delivery Progress',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 24.h),
                    // Timeline items
                    ..._deliveryStatuses.map((status) {
                      final isCompleted = _isStatusCompleted(status);
                      final isCurrent = _isStatusCurrent(status);
                      final isLast = status == _deliveryStatuses.last;

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
              // Cancelled State
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.sp),
                padding: EdgeInsets.all(24.sp),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
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
                      'Delivery Cancelled',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    customText(
                      'This delivery has been cancelled. Please contact support if you have any questions.',
                      fontSize: 14.sp,
                      color: AppColors.obscureTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 24.h),

            // Delivery Items
            if (_currentDelivery['items'] != null &&
                (_currentDelivery['items'] as List).isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.sp),
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      'Package Items (${(_currentDelivery['items'] as List).length})',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 16.h),
                    ...(_currentDelivery['items'] as List).map((item) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: AppColors.primaryColor,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    item['name'] ?? 'Item',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.blackColor,
                                  ),
                                  if (item['quantity'] != null) ...[
                                    SizedBox(height: 2.h),
                                    customText(
                                      'Qty: ${item['quantity']}',
                                      fontSize: 12.sp,
                                      color: AppColors.obscureTextColor,
                                    ),
                                  ],
                                ],
                              ),
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
                    : AppColors.greyColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : _getStatusIcon(status),
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
                    : AppColors.greyColor.withValues(alpha: 0.2),
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

  String _formatCurrency(String amount) {
    try {
      final value = double.parse(amount);
      return formatToCurrency(value);
    } catch (e) {
      return amount;
    }
  }
}
