import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryItemWidget extends StatelessWidget {
  const DeliveryItemWidget(
      {super.key, required this.onSelected, required this.delivery});
  final Function onSelected;
  final DeliveryModel delivery;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.whiteColor,
      ),
      // height: 200.h,
      padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
      margin: EdgeInsets.symmetric(vertical: 5.sp),
      width: 1.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: getStatusColor(delivery.status),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 3.sp),
            child: customText(
              delivery.status!.capitalizeFirst ?? "",
              fontWeight: FontWeight.normal,
              color: getStatusTextColor(delivery.status),
              fontSize: 12.sp,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(
            height: 5.sp,
          ),
          customText(
            delivery.items[0].name,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
            overflow: TextOverflow.visible,
          ),
          SizedBox(
            height: 8.sp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                "Tracking number: ${delivery.trackingId}",
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                overflow: TextOverflow.visible,
              ),
              InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: delivery.trackingId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            customText("Tracking number copied to clipboard!"),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    SvgAssets.copyIcon,
                    color: AppColors.primaryColor,
                  )),
            ],
          ),
          SizedBox(
            height: 8.sp,
          ),
          InkWell(
            splashColor: AppColors.transparent,
            highlightColor: AppColors.transparent,
            onTap: () {
              onSelected();
            },
            child: Container(
              width: 1.sw,
              height: 0.15 * 1.sh,
              child: Row(
                children: [
                  Container(
                    width: 20.sp,
                    margin: EdgeInsets.only(right: 5.sp),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          SvgAssets.parcelIcon,
                        ),
                        const Expanded(
                          child: DottedLine(
                            dashLength: 3,
                            dashGapLength: 3,
                            lineThickness: 2,
                            dashColor: AppColors.primaryColor,
                            direction: Axis.vertical,
                            // lineLength: 150,
                          ),
                        ),
                        SvgPicture.asset(
                          SvgAssets.locationIcon,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: customText(
                                  delivery.originLocation.name,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.sp,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: customText(
                                  delivery.destinationLocation.name,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.sp,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    splashColor: AppColors.transparent,
                    highlightColor: AppColors.transparent,
                    onTap: () {
                      onSelected();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          SvgAssets.rightChevronIcon,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8.sp,
          ),
          Container(
            margin: EdgeInsets.only(top: 8.h),
            child: InkWell(
              splashColor: AppColors.transparent,
              highlightColor: AppColors.transparent,
              onTap: () {
                onSelected();
              },
              child: customText(
                  "${formatDate(delivery.originLocation.createdAt)} ${formatTime(delivery.originLocation.createdAt)}",
                  fontSize: 11.sp,
                  color: AppColors.obscureTextColor,
                  overflow: TextOverflow.visible),
            ),
          ),
          SizedBox(
            height: 8.sp,
          ),
        ],
      ),
    );
  }
}
