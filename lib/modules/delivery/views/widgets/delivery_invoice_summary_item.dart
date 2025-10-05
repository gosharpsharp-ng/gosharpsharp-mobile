import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryInvoiceSummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isVertical;
  final bool isCurrency;
  const DeliveryInvoiceSummaryItem(
      {super.key, this.title = "", this.value = "", this.isVertical = false, this.isCurrency=false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: AppColors.whiteColor),
      child: isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(title,
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                SizedBox(
                  height: 8.h,
                ),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontFamily: isCurrency?'HelveticaNeue':'HelveticaNeue',
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(title,
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontFamily: isCurrency?'HelveticaNeue':'HelveticaNeue',
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
    );
  }
}

class OrderInvoiceSummaryStatusItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isVertical;
  const OrderInvoiceSummaryStatusItem(
      {super.key, this.title = "", this.value = "", this.isVertical = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: AppColors.whiteColor),
      child: isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(title,
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                SizedBox(
                  height: 8.h,
                ),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(title,
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                Container(
                    decoration: BoxDecoration(
                        color: value.toLowerCase() == 'delivered'
                            ? AppColors.primaryColor.withOpacity(0.4)
                            : value.toLowerCase() == 'in transit'
                                ? AppColors.deepAmberColor.withOpacity(0.4)
                                : AppColors.redColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(
                          8.r,
                        )),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                    child: customText(
                      value,
                      color: value.toLowerCase() == 'delivered'
                          ? AppColors.primaryColor
                          : value.toLowerCase() == 'in transit'
                              ? AppColors.deepAmberColor
                              : AppColors.redColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                    )),
              ],
            ),
    );
  }
}
