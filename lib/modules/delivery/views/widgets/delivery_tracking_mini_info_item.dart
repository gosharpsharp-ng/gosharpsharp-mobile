import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryTrackingMiniInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isStatus;
  const DeliveryTrackingMiniInfoItem(
      {super.key,
      required this.title,
      required this.value,
      this.isStatus = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        customText(title, fontSize: 12.sp, color: AppColors.obscureTextColor),
        SizedBox(
          height: 4.h,
        ),
        isStatus
            ? Container(
                decoration: BoxDecoration(
                  color: getStatusColor(value),
                  borderRadius: BorderRadius.circular(
                    8.r,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                child: customText(
                  value.capitalizeFirst!,
                  color: getStatusTextColor(value),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ))
            : Container(
                decoration: BoxDecoration(
                    color: AppColors.transparent,
                    borderRadius: BorderRadius.circular(
                      8.r,
                    )),
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 8.w),
                child: customText(value,
                    fontSize: 15.sp,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w500),
              )
      ],
    );
  }
}
