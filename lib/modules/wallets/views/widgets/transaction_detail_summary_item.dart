import 'package:gosharpsharp/core/utils/exports.dart';

class TransactionDetailSummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isVertical;
  const TransactionDetailSummaryItem(
      {super.key, this.title = "", this.value = "", this.isVertical = false});

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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal),
                SizedBox(
                  height: 8.h,
                ),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontFamily: title == "Amount"
                      ? 'HelveticaNeue'
                      : "HelveticaNeue",
                  fontSize: 14.sp,
                  fontWeight:
                      title == "Amount" ? FontWeight.w600 : FontWeight.w500,
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
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 14.sp,
                  fontFamily: title == "Amount"
                      ? 'HelveticaNeue'
                      : "HelveticaNeue",
                  fontWeight:
                      title == "Amount" ? FontWeight.w600 : FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
    );
  }
}

class TransactionDetailSummaryTypeItem extends StatelessWidget {
  final String title;
  final String value;
  const TransactionDetailSummaryTypeItem(
      {super.key, this.title = "", this.value = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: AppColors.whiteColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(title,
              color: AppColors.obscureTextColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.normal),
          Row(
            children: [
              customText(
                value,
                color: value.toLowerCase() == 'withdrawal'
                    ? AppColors.redColor
                    : AppColors.primaryColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.visible,
              ),
              SizedBox(
                width: 5.w,
              ),
              value.toLowerCase() == 'withdrawal'
                  ? SvgPicture.asset(SvgAssets.outflowIcon)
                  : SvgPicture.asset(SvgAssets.inflowIcon)
            ],
          ),
        ],
      ),
    );
  }
}

class TransactionDetailSummaryStatusItem extends StatelessWidget {
  final String title;
  final String value;
  const TransactionDetailSummaryStatusItem(
      {super.key, this.title = "", this.value = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: AppColors.whiteColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(title,
              color: AppColors.obscureTextColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.normal),
          Container(
            decoration: BoxDecoration(
              color: value.toLowerCase() == 'successful'
                  ? AppColors.primaryColor.withOpacity(0.4)
                  : value.toLowerCase() == 'pending'
                      ? AppColors.deepAmberColor.withOpacity(0.4)
                      : AppColors.redColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(
                8.r,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            child: customText(
              value,
              color: value.toLowerCase() == 'successful'
                  ? AppColors.primaryColor
                  : value.toLowerCase() == 'pending'
                      ? AppColors.deepAmberColor
                      : AppColors.redColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
