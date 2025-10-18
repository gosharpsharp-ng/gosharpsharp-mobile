import 'package:gosharpsharp/core/utils/exports.dart';

class OrderDetailSummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isVertical;

  const OrderDetailSummaryItem({
    super.key,
    required this.title,
    required this.value,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              title,
              fontSize: 13.sp,
              color: AppColors.greyColor,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(height: 6.h),
            customText(
              value,
              fontSize: 14.sp,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: customText(
              title,
              fontSize: 13.sp,
              color: AppColors.greyColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: customText(
              value,
              fontSize: 14.sp,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDetailSummaryStatusItem extends StatelessWidget {
  final String title;
  final String value;
  final String status;

  const OrderDetailSummaryStatusItem({
    super.key,
    required this.title,
    required this.value,
    required this.status,
  });

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: customText(
              title,
              fontSize: 13.sp,
              color: AppColors.greyColor,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: _getStatusColor(status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: customText(
                value,
                fontSize: 14.sp,
                color: _getStatusColor(status),
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

