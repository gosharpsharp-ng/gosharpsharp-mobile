import 'package:gosharpsharp/core/models/parcel_delivery_model.dart';
import '../../../core/utils/exports.dart';

class ParcelStatusTrackingScreen extends StatefulWidget {
  final ParcelDeliveryModel delivery;

  const ParcelStatusTrackingScreen({
    super.key,
    required this.delivery,
  });

  @override
  State<ParcelStatusTrackingScreen> createState() => _ParcelStatusTrackingScreenState();
}

class _ParcelStatusTrackingScreenState extends State<ParcelStatusTrackingScreen> {
  SocketService? _socketService;
  late ParcelDeliveryModel _currentDelivery;
  String? _estimatedTime;
  double? _estimatedDistance;

  // Parcel delivery status progression
  final List<String> _deliveryStatuses = [
    'pending',
    'paid',
    'accepted',
    'picked',
    'in_transit',
    'delivered',
  ];

  @override
  void initState() {
    super.initState();
    _currentDelivery = widget.delivery;
    _initializeTracking();
  }

  void _initializeTracking() {
    try {
      if (Get.isRegistered<SocketService>()) {
        _socketService = Get.find<SocketService>();

        // Join delivery tracking room
        _socketService?.joinParcelDeliveryTracking(_currentDelivery.trackingId);

        // Listen for delivery status updates
        _socketService?.listenForDeliveryStatusUpdate((data) {
          if (mounted) {
            final newStatus = data['status']?.toString() ?? _currentDelivery.status;
            final eta = data['eta']?.toString();
            final distance = data['distance'];

            setState(() {
              _currentDelivery = ParcelDeliveryModel(
                id: _currentDelivery.id,
                orderId: _currentDelivery.orderId,
                trackingId: _currentDelivery.trackingId,
                status: newStatus,
                paymentStatus: _currentDelivery.paymentStatus,
                distance: _currentDelivery.distance,
                cost: _currentDelivery.cost,
                userId: _currentDelivery.userId,
                riderId: _currentDelivery.riderId,
                currencyId: _currentDelivery.currencyId,
                paymentMethodId: _currentDelivery.paymentMethodId,
                courierTypeId: _currentDelivery.courierTypeId,
                createdAt: _currentDelivery.createdAt,
                updatedAt: _currentDelivery.updatedAt,
                receiver: _currentDelivery.receiver,
                items: _currentDelivery.items,
                user: _currentDelivery.user,
                rider: _currentDelivery.rider,
                currency: _currentDelivery.currency,
                paymentMethod: _currentDelivery.paymentMethod,
                pickupLocation: _currentDelivery.pickupLocation,
                destinationLocation: _currentDelivery.destinationLocation,
              );

              if (eta != null) _estimatedTime = eta;
              if (distance != null) {
                _estimatedDistance = double.tryParse(distance.toString());
              }
            });

            showToast(
              message: 'Delivery status updated to ${_getStatusDisplayName(newStatus)}',
              isError: false,
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error initializing delivery tracking: $e');
    }
  }

  @override
  void dispose() {
    // Leave tracking room and stop listening when screen is closed
    _socketService?.leaveParcelDeliveryTracking(_currentDelivery.trackingId);
    _socketService?.stopListeningForDeliveryStatusUpdate();
    super.dispose();
  }

  int _getCurrentStatusIndex() {
    final currentStatus = _currentDelivery.status.toLowerCase();
    final index = _deliveryStatuses.indexOf(currentStatus);
    return index >= 0 ? index : 0;
  }

  bool _isStatusCompleted(String status) {
    final currentIndex = _getCurrentStatusIndex();
    final statusIndex = _deliveryStatuses.indexOf(status.toLowerCase());
    return statusIndex <= currentIndex;
  }

  bool _isStatusCurrent(String status) {
    return _currentDelivery.status.toLowerCase() == status.toLowerCase();
  }

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Payment';
      case 'paid':
        return 'Payment Confirmed';
      case 'accepted':
        return 'Accepted';
      case 'picked':
        return 'Picked Up';
      case 'in_transit':
        return 'In Transit';
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
      case 'picked':
        return Icons.inventory_2_outlined;
      case 'in_transit':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.done_all;
      default:
        return Icons.circle_outlined;
    }
  }

  void _handlePendingStatus() {
    // Navigate to ride selection screen for pending parcels
    showToast(
      message: 'Please complete ride and payment selection',
      isError: false,
    );

    // Navigate to ride selection screen (which includes payment method selection)
    Get.offNamed(Routes.RIDE_SELECTION_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    // Handle pending status
    if (_currentDelivery.status.toLowerCase() == 'pending' ||
        _currentDelivery.paymentStatus.toLowerCase() == 'pending') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handlePendingStatus();
      });
    }

    final isCancelled = _currentDelivery.status.toLowerCase() == 'cancelled' ||
        _currentDelivery.status.toLowerCase() == 'rejected';

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
                              'Tracking ID',
                              fontSize: 12.sp,
                              color: AppColors.obscureTextColor,
                            ),
                            SizedBox(height: 4.h),
                            customText(
                              _currentDelivery.trackingId,
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
                          color: getStatusColor(_currentDelivery.status),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: customText(
                          _getStatusDisplayName(_currentDelivery.status),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: getStatusTextColor(_currentDelivery.status),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: AppColors.greyColor.withOpacity(0.2)),
                  SizedBox(height: 16.h),

                  // ETA and Distance
                  if (_estimatedTime != null || _estimatedDistance != null) ...[
                    Row(
                      children: [
                        if (_estimatedTime != null) ...[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 4.w),
                                    customText(
                                      'ETA',
                                      fontSize: 12.sp,
                                      color: AppColors.obscureTextColor,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                customText(
                                  _estimatedTime!,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (_estimatedDistance != null) ...[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.route,
                                      size: 16.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                    SizedBox(width: 4.w),
                                    customText(
                                      'Distance',
                                      fontSize: 12.sp,
                                      color: AppColors.obscureTextColor,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                customText(
                                  '${_estimatedDistance!.toStringAsFixed(1)} km',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Divider(color: AppColors.greyColor.withOpacity(0.2)),
                    SizedBox(height: 16.h),
                  ],

                  // Locations
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 2.w,
                            height: 40.h,
                            color: AppColors.greyColor.withOpacity(0.3),
                          ),
                          Container(
                            width: 12.w,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customText(
                              'Pickup Location',
                              fontSize: 12.sp,
                              color: AppColors.obscureTextColor,
                            ),
                            SizedBox(height: 2.h),
                            customText(
                              _currentDelivery.pickupLocation.name,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                            ),
                            SizedBox(height: 20.h),
                            customText(
                              'Destination',
                              fontSize: 12.sp,
                              color: AppColors.obscureTextColor,
                            ),
                            SizedBox(height: 2.h),
                            customText(
                              _currentDelivery.destinationLocation.name,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                            ),
                          ],
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
                            'Receiver',
                            fontSize: 12.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          SizedBox(height: 4.h),
                          customText(
                            _currentDelivery.receiver.name,
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
                            'Cost',
                            fontSize: 12.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          SizedBox(height: 4.h),
                          customText(
                            formatToCurrency(double.tryParse(_currentDelivery.cost) ?? 0),
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
                      'Delivery Progress',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 24.h),
                    // Timeline items - skip pending if already past it
                    ..._deliveryStatuses.skip(1).map((status) {
                      final isCompleted = _isStatusCompleted(status);
                      final isCurrent = _isStatusCurrent(status);
                      final isLast = status == _deliveryStatuses.last;

                      return _buildTimelineItem(
                        status: status,
                        isCompleted: isCompleted,
                        isCurrent: isCurrent,
                        isLast: isLast,
                      );
                    }),
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
                      'Delivery ${_getStatusDisplayName(_currentDelivery.status)}',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    customText(
                      'This delivery has been ${_currentDelivery.status.toLowerCase()}. Please contact support if you have any questions.',
                      fontSize: 14.sp,
                      color: AppColors.obscureTextColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 24.h),

            // Parcel Items
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
                    'Parcel Items (${_currentDelivery.items.length})',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 16.h),
                  ..._currentDelivery.items.map((item) {
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
                            child: item.image != null && item.image!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      item.image!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.inventory_2, color: AppColors.greyColor),
                                    ),
                                  )
                                : Icon(Icons.inventory_2, color: AppColors.greyColor),
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
                                  'Category: ${item.category}',
                                  fontSize: 12.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                                customText(
                                  'Weight: ${item.weight} • Qty: ${item.quantity}',
                                  fontSize: 12.sp,
                                  color: AppColors.obscureTextColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Rider Info (if available)
            if (_currentDelivery.rider != null) ...[
              SizedBox(height: 16.h),
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
                      'Rider Information',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25.r,
                          backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                          child: Icon(
                            Icons.person,
                            size: 25.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                '${_currentDelivery.rider!.fname} ${_currentDelivery.rider!.lname}',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(height: 4.h),
                              customText(
                                _currentDelivery.rider!.phone,
                                fontSize: 12.sp,
                                color: AppColors.obscureTextColor,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.call,
                            size: 20.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

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
