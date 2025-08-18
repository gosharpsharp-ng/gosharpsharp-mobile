import 'package:gosharpsharp/modules/delivery/views/widgets/delivery_instructions_bottom_sheet.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class DeliverySummaryScreen extends StatelessWidget {
  const DeliverySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      final settingController = Get.find<SettingsController>();
      return Form(
        // key: signInProvider.signInFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Order Summary",
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.sp),
            child: CustomButton(
              onPressed: () {
                // ordersController.submitShipment(context);
                showAnyBottomSheet(
                    child: DeliveryInstructionsBottomSheet(
                      onContinue: () {
                        ordersController.submitDelivery(context);
                      },
                      onTermsSelected: () {},
                      isLoading: ordersController.submittingDelivery,
                    ),
                    isControlled: true);
              },
              isBusy: ordersController.submittingDelivery,
              title: "Confirm",
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 15.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.sp, vertical: 5.sp),
                    margin: EdgeInsets.only(left: 5.sp, right: 5.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          children: [
                            DeliverySummaryDetailItem(
                              title: "Pick up address",
                              value:
                                  ordersController.senderAddressController.text,
                            ),
                            DeliverySummaryDetailItem(
                              title: "Sender",
                              value: ordersController.senderNameController.text,
                            ),
                            DeliverySummaryDetailItem(
                              title: "Phone number",
                              value: settingController.userProfile?.phone ?? "",
                            ),
                          ],
                        ),
                        SectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          children: [
                            DeliverySummaryDetailItem(
                              title: "Receiver",
                              value:
                                  ordersController.receiverNameController.text,
                            ),
                            DeliverySummaryDetailItem(
                              title: "Drop off address",
                              value: ordersController
                                  .receiverAddressController.text,
                            ),
                            DeliverySummaryDetailItem(
                              title: "Phone number",
                              value:
                                  ordersController.receiverPhoneController.text,
                            ),
                            DeliverySummaryDetailItem(
                              title: "Estimated distance",
                              value:
                                  "${ordersController.estimatedDistanceController.text} km",
                            ),
                          ],
                        ),
                        TitleSectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          title: "Delivery Items",
                          children: [
                            ...List.generate(
                                ordersController.deliveryItems.length,
                                (i) => DeliveryItemAccordion(
                                    shipmentItemData:
                                        ordersController.deliveryItems[i]))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
