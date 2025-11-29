import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryContactOptionBottomSheet extends StatelessWidget {
  const DeliveryContactOptionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Container(
        width: 1.sw,
        padding: EdgeInsets.only(
            left: 15.sp, right: 15.sp, top: 10.sp, bottom: 40.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 5.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  "Contact options",
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.start,
                  color: AppColors.blackColor,
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w700,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    size: 25.sp,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            customText("Your network provider might charge you for this",
                overflow: TextOverflow.visible,
                color: AppColors.blackColor,
                textAlign: TextAlign.start,
                fontSize: 16.sp,
                fontWeight: FontWeight.normal),
            SizedBox(
              height: 20.h,
            ),
            const Divider(),
            SizedBox(
              height: 5.h,
            ),
            Container(
              child: InkWell(
                highlightColor: AppColors.transparent,
                splashColor: AppColors.transparent,
                onTap: () {
                  makePhoneCall(
                      ordersController.selectedDelivery?.rider?.phone ?? "");
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      SvgAssets.callIcon,
                      height: 35.sp,
                      width: 35.sp,
                    ),
                    SizedBox(
                      width: 25.sp,
                    ),
                    customText("Call by phone",
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
