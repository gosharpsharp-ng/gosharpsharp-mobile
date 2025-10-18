import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryInvoiceDetailsScreen extends StatelessWidget {
  const DeliveryInvoiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
      builder: (ordersController) {
        return Form(
          // key: signInProvider.signInFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Order Invoice",
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SectionBox(
                      children: [
                        DeliveryInvoiceSummaryItem(
                          title: "Delivery Fee",
                          value: formatToCurrency(
                            double.parse(
                              ordersController.selectedDelivery?.cost ?? "0.0",
                            ),
                          ),
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Tracking number",
                          value: ordersController.selectedDelivery!.trackingId,
                        ),
                        const DeliveryInvoiceSummaryItem(
                          title: "Payment Method",
                          value: "GoWallet",
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Date",
                          value:
                              "${formatDate(ordersController.selectedDelivery!.createdAt)} ${formatTime(ordersController.selectedDelivery!.createdAt)} ",
                        ),
                        OrderInvoiceSummaryStatusItem(
                          title: "Status",
                          value:
                              ordersController.selectedDelivery?.status ?? "",
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 12.w),
                        customText(
                          "Delivery Items",
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ...List.generate(
                      ordersController.selectedDelivery!.items.length,
                      (i) => SectionBox(
                        children: [
                          Row(
                            children: [
                              customText(
                                "Item ${(i + 1).toString()}",
                                color: AppColors.blackColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                              ),
                              SizedBox(height: 8.h),
                            ],
                          ),
                          DeliveryInvoiceSummaryItem(
                            title: "Name",
                            value:
                                ordersController
                                    .selectedDelivery
                                    ?.items[i]
                                    .name ??
                                "",
                          ),
                          DeliveryInvoiceSummaryItem(
                            title: "Item category",
                            value:
                                ordersController
                                    .selectedDelivery
                                    ?.items[i]
                                    .category ??
                                "",
                          ),
                          DeliveryInvoiceSummaryItem(
                            title: "Quantity",
                            value:
                                ordersController
                                    .selectedDelivery
                                    ?.items[i]
                                    .quantity
                                    .toString() ??
                                "",
                          ),
                        ],
                      ),
                    ),
                    SectionBox(
                      children: [
                        DeliveryInvoiceSummaryItem(
                          title: "Sender's Name",
                          value:
                              "${ordersController.selectedDelivery?.sender?.firstName ?? ''} ${ordersController.selectedDelivery?.sender?.lastName ?? ''}",
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Phone Number",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.sender
                                  ?.phone ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Email",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.sender
                                  ?.email ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Address",
                          isVertical: true,
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.pickUpLocation
                                  ?.name ??
                              '',
                        ),
                      ],
                    ),
                    SectionBox(
                      children: [
                        DeliveryInvoiceSummaryItem(
                          title: "Receiver's Name",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.receiver
                                  .name ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Phone Number",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.receiver
                                  .phone ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Email",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.receiver
                                  .email ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Address",
                          isVertical: true,
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.destinationLocation
                                  .name ??
                              '',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
