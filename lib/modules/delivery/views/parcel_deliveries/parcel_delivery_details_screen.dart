import 'package:gosharpsharp/core/utils/exports.dart';

class ParcelDeliveryDetailsScreen extends GetView<DeliveriesController> {
  const ParcelDeliveryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
      builder: (deliveriesController) {
        final parcelDelivery = deliveriesController.selectedParcelDelivery;

        if (parcelDelivery == null) {
          return Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              onPop: () => Get.back(),
              title: "Delivery Details",
            ),
            body: const Center(child: Text("Delivery not found")),
          );
        }

        // For active deliveries, automatically redirect to tracking screen with status timeline
        final status = parcelDelivery['status']?.toString().toLowerCase() ?? '';
        if ([
          'confirmed',
          'accepted',
          'picked',
          'in_transit',
        ].contains(status)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Redirect to parcel delivery tracking screen (status timeline, not map)
            Get.offNamed(Routes.PARCEL_DELIVERY_TRACKING_SCREEN);
          });
        }

        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Delivery Details",
            implyLeading: true,
            centerTitle: false,
            onPop: () => Get.back(),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tracking ID and Status Card
                  Container(
                    width: 1.sw,
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: _getStatusColor(
                          parcelDelivery['status'] ?? 'pending',
                        ).withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              "Tracking ID",
                              color: AppColors.greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  parcelDelivery['status'] ?? 'pending',
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getStatusIcon(
                                      parcelDelivery['status'] ?? 'pending',
                                    ),
                                    color: AppColors.whiteColor,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 6.w),
                                  customText(
                                    _getStatusDisplayText(
                                      parcelDelivery['status'] ?? 'pending',
                                    ),
                                    color: AppColors.whiteColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        customText(
                          parcelDelivery['tracking_id'] ?? '',
                          color: AppColors.blackColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(height: 16.h),
                        Divider(
                          color: AppColors.greyColor.withValues(alpha: 0.2),
                          height: 1,
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                              "Delivery Cost",
                              color: AppColors.greyColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            customText(
                              _formatCurrency(
                                parcelDelivery['cost']?.toString() ?? '0',
                              ),
                              color: AppColors.primaryColor,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Location Details Card
                  Container(
                    width: 1.sw,
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "Location Details",
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 16.h),

                        // Pickup Location
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.location_on,
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
                                    "Pickup Location",
                                    color: AppColors.greyColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 4.h),
                                  customText(
                                    parcelDelivery['pickup_location']?['name'] ??
                                        'N/A',
                                    color: AppColors.blackColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Divider with connecting line
                        Container(
                          padding: EdgeInsets.only(left: 18.sp),
                          child: Container(
                            width: 2,
                            height: 24.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primaryColor,
                                  AppColors.primaryColor.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Destination Location
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.sp),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.flag,
                                color: Colors.green,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    "Destination Location",
                                    color: AppColors.greyColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 4.h),
                                  customText(
                                    parcelDelivery['destination_location']?['name'] ??
                                        'N/A',
                                    color: AppColors.blackColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16.h),

                        // Distance
                        Container(
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.straighten,
                                color: AppColors.greyColor,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              customText(
                                "Distance: ",
                                color: AppColors.greyColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              customText(
                                "${parcelDelivery['distance']?.toString() ?? '0'} km",
                                color: AppColors.blackColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Items Details Card
                  if (parcelDelivery['items'] != null &&
                      (parcelDelivery['items'] as List).isNotEmpty)
                    Container(
                      width: 1.sw,
                      padding: EdgeInsets.all(20.sp),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            "Package Items",
                            color: AppColors.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 16.h),
                          ...(parcelDelivery['items'] as List).map((item) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              padding: EdgeInsets.all(12.sp),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    color: AppColors.primaryColor,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customText(
                                          item['name'] ?? 'Item',
                                          color: AppColors.blackColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        if (item['description'] != null &&
                                            item['description']
                                                .toString()
                                                .isNotEmpty) ...[
                                          SizedBox(height: 4.h),
                                          customText(
                                            item['description'],
                                            color: AppColors.greyColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (item['quantity'] != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryColor
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: customText(
                                        "x${item['quantity']}",
                                        color: AppColors.primaryColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),

                  SizedBox(height: 16.h),

                  // Receiver Information Card
                  if (parcelDelivery['receiver'] != null)
                    Container(
                      width: 1.sw,
                      padding: EdgeInsets.all(20.sp),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customText(
                            "Receiver Information",
                            color: AppColors.blackColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          SizedBox(height: 16.h),
                          _buildInfoRow(
                            icon: Icons.person_outline,
                            label: "Name",
                            value: parcelDelivery['receiver']?['name'] ?? 'N/A',
                          ),
                          SizedBox(height: 12.h),
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: "Phone",
                            value:
                                parcelDelivery['receiver']?['phone'] ?? 'N/A',
                          ),
                          if (parcelDelivery['receiver']?['email'] != null) ...[
                            SizedBox(height: 12.h),
                            _buildInfoRow(
                              icon: Icons.email_outlined,
                              label: "Email",
                              value: parcelDelivery['receiver']?['email'] ?? '',
                            ),
                          ],
                        ],
                      ),
                    ),

                  SizedBox(height: 16.h),

                  // Tracking Information Card
                  Container(
                    width: 1.sw,
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "Tracking Information",
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 16.h),
                        _buildTrackingInfoRow(
                          label: "Created",
                          value: _formatDateTime(
                            parcelDelivery['created_at'] ?? '',
                          ),
                        ),
                        if (parcelDelivery['updated_at'] != null) ...[
                          SizedBox(height: 12.h),
                          _buildTrackingInfoRow(
                            label: "Last Updated",
                            value: _formatDateTime(
                              parcelDelivery['updated_at'] ?? '',
                            ),
                          ),
                        ],
                        SizedBox(height: 12.h),
                        _buildTrackingInfoRow(
                          label: "Payment Status",
                          value: _getPaymentStatusText(
                            parcelDelivery['payment_status'] ?? 'pending',
                          ),
                          isPaymentStatus: true,
                          paymentStatus:
                              parcelDelivery['payment_status'] ?? 'pending',
                        ),
                      ],
                    ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.greyColor, size: 18.sp),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                label,
                color: AppColors.greyColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 2.h),
              customText(
                value,
                color: AppColors.blackColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingInfoRow({
    required String label,
    required String value,
    bool isPaymentStatus = false,
    String? paymentStatus,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          color: AppColors.greyColor,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        if (isPaymentStatus)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getPaymentStatusColor(
                paymentStatus ?? 'pending',
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: customText(
              value,
              color: _getPaymentStatusColor(paymentStatus ?? 'pending'),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          )
        else
          Flexible(
            child: customText(
              value,
              color: AppColors.blackColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.right,
              overflow: TextOverflow.visible,
            ),
          ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'picked':
        return Icons.local_shipping;
      case 'in_transit':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'picked':
        return AppColors.primaryColor;
      case 'in_transit':
        return AppColors.primaryColor;
      case 'delivered':
        return Colors.green;
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
      case 'confirmed':
        return 'Confirmed';
      case 'picked':
        return 'Picked Up';
      case 'in_transit':
        return 'In Transit';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  String _getPaymentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      default:
        return status.toUpperCase();
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }

  String _formatCurrency(String amount) {
    try {
      final value = double.parse(amount);
      return formatToCurrency(value);
    } catch (e) {
      return amount;
    }
  }

  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${formatDate(date.toIso8601String())} ${formatTime(date.toIso8601String())}";
    } catch (e) {
      return dateString;
    }
  }
}
