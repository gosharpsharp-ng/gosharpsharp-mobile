import 'package:gosharpsharp/modules/delivery/controllers/deliveries_controller.dart';
import '../../../../core/utils/exports.dart';
import '../../../../core/widgets/skeleton_loaders.dart';

class ParcelDeliveriesHomeScreen extends GetView<DeliveriesController> {
  const ParcelDeliveriesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
      builder: (deliveriesController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            implyLeading: true,
            centerTitle: true,
            title: "Parcel Deliveries",
            onPop: () {
              Get.back();
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

                // Parcel Deliveries List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await deliveriesController.refreshParcelDeliveries();
                    },
                    color: AppColors.primaryColor,
                    backgroundColor: AppColors.whiteColor,
                    strokeWidth: 2.5,
                    displacement: 40.0,
                    child: deliveriesController.isLoadingParcelDeliveries
                        ? ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              child: SkeletonLoaders.orderItem(count: 1),
                            ),
                          )
                        : deliveriesController.allParcelDeliveries.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 100.h),
                              _buildEmptyState(),
                            ],
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: deliveriesController.allParcelDeliveries.length,
                            separatorBuilder: (context, index) => SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final parcelDelivery = deliveriesController.allParcelDeliveries[index];
                              return ParcelDeliveryCard(
                                parcelDelivery: parcelDelivery,
                                onTap: () {
                                  deliveriesController.setSelectedParcelDelivery(parcelDelivery);
                                  Get.toNamed(Routes.PARCEL_DELIVERY_DETAILS_SCREEN);
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

  Widget _buildEmptyState() {
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
              Icons.local_shipping_outlined,
              size: 40.sp,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 16.h),
          customText(
            "No parcel deliveries",
            color: AppColors.greyColor,
            overflow: TextOverflow.visible,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 8.h),
          customText(
            "Your parcel deliveries will appear here",
            color: AppColors.greyColor,
            overflow: TextOverflow.visible,
            fontSize: 14.sp,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Parcel Delivery Card Widget
class ParcelDeliveryCard extends StatelessWidget {
  final Map<String, dynamic> parcelDelivery;
  final VoidCallback onTap;

  const ParcelDeliveryCard({
    super.key,
    required this.parcelDelivery,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              color: _getStatusColor(parcelDelivery['status'] ?? 'pending').withOpacity(0.15),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section: Status badge and cost
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(parcelDelivery['status'] ?? 'pending'),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getStatusIcon(parcelDelivery['status'] ?? 'pending'),
                          color: AppColors.whiteColor,
                          size: 14.sp,
                        ),
                        SizedBox(width: 6.w),
                        customText(
                          _getStatusDisplayText(parcelDelivery['status'] ?? 'pending'),
                          color: AppColors.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  customText(
                    _formatCurrency(parcelDelivery['cost'] ?? '0'),
                    color: AppColors.blackColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Tracking ID and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    parcelDelivery['tracking_id'] ?? '',
                    color: AppColors.blackColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  customText(
                    _formatTime(parcelDelivery['created_at'] ?? ''),
                    color: AppColors.greyColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Pickup and Destination
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.primaryColor,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "Pickup: ${parcelDelivery['pickup_location']?['name'] ?? 'N/A'}",
                          color: AppColors.blackColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        customText(
                          "Destination: ${parcelDelivery['destination_location']?['name'] ?? 'N/A'}",
                          color: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Items preview
              if (parcelDelivery['items'] != null && (parcelDelivery['items'] as List).isNotEmpty) ...[
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
                        Icons.inventory_2_outlined,
                        color: AppColors.greyColor,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: customText(
                          _getItemsSummary(parcelDelivery['items']),
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

              // Receiver info
              if (parcelDelivery['receiver'] != null) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: AppColors.greyColor,
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: customText(
                        "Receiver: ${parcelDelivery['receiver']?['name'] ?? 'N/A'}",
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
          ),
        ),
      ),
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

  String _formatCurrency(String amount) {
    try {
      final value = double.parse(amount);
      return formatToCurrency(value);
    } catch (e) {
      return amount;
    }
  }

  String _formatTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes}m ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours}h ago";
      } else {
        return "${difference.inDays}d ago";
      }
    } catch (e) {
      return dateString;
    }
  }

  String _getItemsSummary(List<dynamic> items) {
    if (items.isEmpty) return "No items";

    final firstItem = items[0];
    final firstName = firstItem['name'] ?? 'Item';

    if (items.length == 1) {
      return firstName;
    } else {
      return "$firstName + ${items.length - 1} more";
    }
  }
}
