import 'package:gosharpsharp/core/utils/exports.dart';

class PaymentMethodSelectionBottomsheet extends StatelessWidget {
  const PaymentMethodSelectionBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Container(
        margin: EdgeInsets.only(top: 5.sp),
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
        child: Column(
          children: [
            customText("Select Payment method",
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: AppColors.primaryColor),
            Container(
              height: 1.sh * 0.46,
              child: SingleChildScrollView(
                child: (ordersController.selectedDelivery!=null && ['pending'].contains(ordersController.selectedDelivery?.status??''))?Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(
                      ordersController
                          .selectedDelivery!.paymentMethods!.length,
                      (index) => InkWell(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 4.sp),
                              // height: 45.sp,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.sp, vertical: 6.sp),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        customText(
                                            ordersController
                                                .selectedDelivery!
                                                .paymentMethods![index]
                                                .name
                                                .capitalizeFirst!,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                            color: ordersController
                                                            .selectedDelivery!
                                                            .paymentMethods![
                                                        index] ==
                                                    ordersController
                                                        .selectedPaymentMethod
                                                ? AppColors.primaryColor
                                                : AppColors.blackColor),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        customText(
                                            ordersController
                                                .selectedDelivery!
                                                .paymentMethods![index]
                                                .description
                                                .capitalizeFirst!,
                                            fontSize: 14.sp,
                                            overflow: TextOverflow.visible,
                                            color: ordersController
                                                            .selectedDelivery!
                                                            .paymentMethods![
                                                        index] ==
                                                    ordersController
                                                        .selectedPaymentMethod
                                                ? AppColors.primaryColor
                                                : AppColors.blackColor),
                                      ],
                                    ),
                                  ),
                                  ordersController
                                              .selectedDelivery!
                                              .paymentMethods![index] ==
                                          ordersController.selectedPaymentMethod
                                      ? Icon(
                                          Icons.check_circle_outline,
                                          color: AppColors.primaryColor,
                                          size: 20.sp,
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                            Divider(
                              color: AppColors.primaryColor.withOpacity(0.1),
                            )
                          ],
                        ),
                        onTap: () {
                          ordersController.setSelectedPaymentMethod(
                              ordersController.selectedDelivery!
                                  .paymentMethods![index]);
                          Get.back();
                        },
                      ),
                    )
                  ],
                ):ordersController.selectedDeliveryResponseModel!=null?Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(
                      ordersController
                          .selectedDeliveryResponseModel!.paymentMethods.length,
                          (index) => InkWell(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 4.sp),
                              // height: 45.sp,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.sp, vertical: 6.sp),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        customText(
                                            ordersController
                                                .selectedDeliveryResponseModel!
                                                .paymentMethods[index]
                                                .name
                                                .capitalizeFirst!,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w500,
                                            color: ordersController
                                                .selectedDeliveryResponseModel!
                                                .paymentMethods[
                                            index] ==
                                                ordersController
                                                    .selectedPaymentMethod
                                                ? AppColors.primaryColor
                                                : AppColors.blackColor),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        customText(
                                            ordersController
                                                .selectedDeliveryResponseModel!
                                                .paymentMethods[index]
                                                .description
                                                .capitalizeFirst!,
                                            fontSize: 14.sp,
                                            overflow: TextOverflow.visible,
                                            color: ordersController
                                                .selectedDeliveryResponseModel!
                                                .paymentMethods[
                                            index] ==
                                                ordersController
                                                    .selectedPaymentMethod
                                                ? AppColors.primaryColor
                                                : AppColors.blackColor),
                                      ],
                                    ),
                                  ),
                                  ordersController
                                      .selectedDeliveryResponseModel!
                                      .paymentMethods[index] ==
                                      ordersController.selectedPaymentMethod
                                      ? Icon(
                                    Icons.check_circle_outline,
                                    color: AppColors.primaryColor,
                                    size: 20.sp,
                                  )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                            Divider(
                              color: AppColors.primaryColor.withOpacity(0.1),
                            )
                          ],
                        ),
                        onTap: () {
                          ordersController.setSelectedPaymentMethod(
                              ordersController.selectedDeliveryResponseModel!
                                  .paymentMethods[index]);
                          Get.back();
                        },
                      ),
                    )
                  ],
                ):Column(
                  children: [
                    
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
