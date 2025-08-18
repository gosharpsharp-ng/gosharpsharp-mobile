import 'package:gosharpsharp/modules/delivery/views/widgets/delivery_contact_option_bottomsheet.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class DeliverySummaryDetailItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isVertical;
  final bool isCurrency;
  final bool isPhone;
  const DeliverySummaryDetailItem(
      {super.key, this.title = "", this.value = "", this.isVertical = true,this.isCurrency = false, this.isPhone=false});

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
                Row(
                  children: [
                    Expanded(
                      child: customText(
                        value,
                        color: AppColors.blackColor,
                        fontSize: 15.sp,
                        fontFamily: isCurrency?GoogleFonts.montserrat().fontFamily!:'Satoshi',
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Visibility(
                      visible: isPhone,
                      child: Container(
                        padding:
                        EdgeInsets.only(right: 5.sp),
                        child: InkWell(
                          highlightColor: AppColors.transparent,
                          splashColor: AppColors.transparent,
                          onTap: () {
                            showAnyBottomSheet(
                                isControlled: false,
                                child:
                                const DeliveryContactOptionBottomSheet());
                          },
                          child: SvgPicture.asset(
                            SvgAssets.callIcon,
                            height: 25.sp,
                            width: 25.sp,
                          ),),),
                    )
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText("$title:",
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontFamily: isCurrency?GoogleFonts.montserrat().fontFamily!:'Satoshi',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
    );
  }
}

class CopyAbleAndClickAbleOrderSummaryDetailItem extends StatelessWidget {
  final String title;
  final String clickableTitle;
  final Function onClick;
  final Function onCopy;
  final String value;
  const CopyAbleAndClickAbleOrderSummaryDetailItem(
      {super.key,
      this.title = "",
      required this.onClick,
      required this.onCopy,
      this.value = "",
      this.clickableTitle = "View invoice"});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.whiteColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(title,
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                InkWell(
                  onTap: () {
                    onClick();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      customText(capitalizeText(clickableTitle),
                          color: AppColors.primaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                      SizedBox(
                        width: 8.sp,
                      ),
                      SvgPicture.asset(
                        SvgAssets.rightChevronIcon,
                        color: AppColors.primaryColor,
                        height: 12.sp,
                        width: 12.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
                InkWell(
                    onTap: () {
                      onCopy();
                    },
                    child: SvgPicture.asset(
                      SvgAssets.copyIcon,
                      color: AppColors.primaryColor,
                    )),
              ],
            ),
          ],
        ));
  }
}

class ClickAbleOrderSummaryDetailItem extends StatelessWidget {
  final String title;
  final String clickableTitle;
  final Function onClick;
  final String value;
  const ClickAbleOrderSummaryDetailItem(
      {super.key,
      this.title = "",
      required this.onClick,
      this.value = "",
      this.clickableTitle = "View invoice"});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.whiteColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(title,
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                InkWell(
                  onTap: () {
                    onClick();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      customText(capitalizeText(clickableTitle),
                          color: AppColors.primaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500),
                      SizedBox(
                        width: 8.sp,
                      ),
                      SvgPicture.asset(
                        SvgAssets.rightChevronIcon,
                        color: AppColors.primaryColor,
                        height: 12.sp,
                        width: 12.sp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            customText(
              value,
              color: AppColors.blackColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.visible,
            ),
          ],
        ));
  }
}

class CopyAbleOrderSummaryDetailItem extends StatelessWidget {
  final String title;
  final Function onCopy;
  final String value;
  const CopyAbleOrderSummaryDetailItem(
      {super.key, this.title = "", required this.onCopy, this.value = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: AppColors.whiteColor),
        child: Column(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
                InkWell(
                    onTap: () {
                      onCopy();
                    },
                    child: SvgPicture.asset(
                      SvgAssets.copyIcon,
                      color: AppColors.primaryColor,
                    )),
              ],
            ),
          ],
        ));
  }
}

class OrderSummaryStatusDetailItem extends StatelessWidget {
  final String title;
  final String value;
  const OrderSummaryStatusDetailItem(
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
        child: Column(
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
            Container(
                decoration: BoxDecoration(
                    color: getStatusColor(value.toLowerCase()),
                    borderRadius: BorderRadius.circular(
                      8.r,
                    )),
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                child: customText(
                  value.capitalizeFirst!,
                  color: getStatusTextColor(value.toLowerCase()),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                )),
          ],
        ));
  }
}
