import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryDisputeEntryBottomSheet extends StatelessWidget {
  const  DeliveryDisputeEntryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Form(
        key: ordersController.deliveryDisputeFormKey,
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
                "Open a dispute on this delivery",
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
                  "Our customer representatives will reach out to you, to resolve your dispute",
                  overflow: TextOverflow.visible,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal),
              SizedBox(
                height: 20.h,
              ),
              CustomOutlinedRoundedInputField(
                maxLines: 3,
                hasTitle: true,
                title: "Your message here",
                controller: ordersController.disputeMessageController,
                isRequired: true,
              ),
              SizedBox(
                height: 16.h,
              ),
              CustomButton(
                onPressed: () async{
                  await ordersController.submitDispute(context);
                  Navigator.pop(context);
                },
                title: "Submit",
                isBusy: ordersController.submittingDispute,
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      );
    }
    );
  }
}
