import 'package:gosharpsharp/core/utils/exports.dart';

class CancelDeliveryBottomSheet extends StatelessWidget {
  const CancelDeliveryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Form(
        key: ordersController.deliveryRatingFormKey,
        child: Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.h,
              ),
              customText(
                "Are you sure?",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                color: AppColors.primaryColor,
                fontSize: 25.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                height: 5.h,
              ),
              customText(
                  "This means your delivery will no longer be processed\nPress continue to cancel the delivery",
                  overflow: TextOverflow.visible,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                onPressed: () async {
                  await ordersController.cancelDelivery(context);
                  ordersController.fetchDeliveries();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                title: "Submit",
                isBusy: ordersController.cancellingDelivery,
                width: 1.sw,
                backgroundColor: AppColors.redColor,
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      );
    });
  }
}
