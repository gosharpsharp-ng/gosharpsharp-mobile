import 'package:gosharpsharp/core/models/available_rider_model.dart';
import 'package:gosharpsharp/modules/delivery/views/widgets/delivery_dispute_entry_bottom_sheet.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class ProcessedDeliverySummaryScreen extends StatelessWidget {
  const ProcessedDeliverySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Form(
        // key: signInProvider.signInFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Order Summary",
          ),
          bottomNavigationBar: ['cancelled', 'canceled']
                  .contains(ordersController.selectedDelivery!.status)
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ['pending']
                          .contains(ordersController.selectedDelivery!.status)
                      ? CustomButton(
                          onPressed: () async {
                            final selectedDelivery =
                                ordersController.selectedDelivery;

                            // Null safety check for selectedDelivery before proceeding
                            if (selectedDelivery == null) {
                              Get.snackbar('Error', 'No delivery selected');
                              return;
                            }

                            // Listen for available riders
                            Get.find<SocketService>().listenForAvailableRiders(
                              onRiderOnline: (data) {
                                final riders = (data as List)
                                    .map((r) => AvailableRiderModel.fromJson(r))
                                    .toList();

                                ordersController.availableRiders = riders;

                                // Check if there are compatible riders for the selected delivery
                                final hasCompatibleRiders = riders.isNotEmpty &&
                                    (selectedDelivery.courierTypePrices
                                            ?.any((price) {
                                          final availableCourierTypes = riders
                                              .map((rider) =>
                                                  rider.courierType.name ?? "")
                                              .map((type) => type.toLowerCase())
                                              .toSet(); // Use Set for faster lookup
                                          return availableCourierTypes.contains(
                                              price.courierType.toLowerCase());
                                        }) ??
                                        false);

                                if (!hasCompatibleRiders) {
                                  ordersController
                                      .selectedDeliveryResponseModel = null;
                                }

                                ordersController.update();
                              },
                            );

                            // Payment method setup - moved after null check for selectedDelivery
                            if (selectedDelivery.paymentMethods?.isNotEmpty ??
                                false) {
                              ordersController.setSelectedPaymentMethod(
                                  selectedDelivery.paymentMethods![0]);
                            }

                            // Navigate to ride selection screen
                            Get.toNamed(Routes.RIDE_SELECTION_SCREEN);

                            // Draw polyline - no need for null check since we've already checked above
                            ordersController
                                .drawPolyLineFromOriginToDestination(
                              context,
                              originLatitude:
                                  selectedDelivery.originLocation.latitude,
                              originLongitude:
                                  selectedDelivery.originLocation.longitude,
                              originAddress:
                                  selectedDelivery.originLocation.name,
                              destinationLatitude:
                                  selectedDelivery.destinationLocation.latitude,
                              destinationLongitude: selectedDelivery
                                  .destinationLocation.longitude,
                              destinationAddress:
                                  selectedDelivery.destinationLocation.name,
                            );
                          },
                          title: "Continue",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        )
                      : [
                          'delivered',
                        ].contains(ordersController.selectedDelivery!.status)
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Visibility(
                                  visible: ordersController
                                          .selectedDelivery?.rating ==
                                      null,
                                  child: CustomButton(
                                    onPressed: () async {
                                      ordersController.resetRatingFields();
                                      showAnyBottomSheet(
                                          isControlled: false,
                                          child: const RatingBottomSheet());
                                    },
                                    // isBusy: signInProvider.isLoading,
                                    title: "Rate",
                                    width: 1.sw,
                                    backgroundColor: AppColors.primaryColor,
                                    fontColor: AppColors.whiteColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                CustomButton(
                                  onPressed: () async {
                                    showAnyBottomSheet(
                                        isControlled: false,
                                        child:
                                            const DeliveryDisputeEntryBottomSheet());
                                  },
                                  // isBusy: signInProvider.isLoading,
                                  title: "Raise a dispute",
                                  width: 1.sw,
                                  backgroundColor: AppColors.transparent,
                                  fontColor: AppColors.redColor,
                                ),
                              ],
                            )
                          : CustomButton(
                              onPressed: () async {
                                if (![
                                  'delivered',
                                  'rejected',
                                  'canceled',
                                ].contains(ordersController
                                    .selectedDelivery!.status)) {
                                  await Get.find<SocketService>()
                                      .joinTrackingRoom(
                                          trackingId: ordersController
                                                  .selectedDelivery
                                                  ?.trackingId ??
                                              "",
                                          msg: "join_room");
                                }
                                Get.toNamed(Routes.DELIVERY_TRACKING_SCREEN);
                                ordersController.drawPolyLineFromOriginToDestination(
                                    context,
                                    originLatitude: ordersController
                                        .selectedDelivery!
                                        .originLocation
                                        .latitude,
                                    originLongitude: ordersController
                                        .selectedDelivery!
                                        .originLocation
                                        .longitude,
                                    originAddress: ordersController
                                        .selectedDelivery!.originLocation.name,
                                    destinationLatitude: ordersController
                                        .selectedDelivery!
                                        .destinationLocation
                                        .latitude,
                                    destinationLongitude: ordersController
                                        .selectedDelivery!
                                        .destinationLocation
                                        .longitude,
                                    destinationAddress: ordersController
                                        .selectedDelivery!
                                        .destinationLocation
                                        .name);
                              },
                              // isBusy: signInProvider.isLoading,
                              title: "View Progress",
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
                            OrderSummaryStatusDetailItem(
                              title: "Status",
                              value:
                                  ordersController.selectedDelivery?.status ??
                                      "",
                            ),
                            ['pending', 'canceled'].contains(
                                    ordersController.selectedDelivery!.status)
                                ? OrderSummaryStatusDetailItem(
                                    title: "Tracking ID",
                                    value: ordersController
                                            .selectedDelivery?.trackingId
                                            .toUpperCase() ??
                                        "",
                                  )
                                : CopyAbleAndClickAbleOrderSummaryDetailItem(
                                    title: "Tracking ID",
                                    onCopy: () {
                                      Clipboard.setData(ClipboardData(
                                          text: ordersController
                                                  .selectedDelivery?.trackingId
                                                  .toUpperCase() ??
                                              ""));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: customText(
                                              "Tracking number copied to clipboard!"),
                                        ),
                                      );
                                    },
                                    onClick: () async {
                                      if (!['delivered', 'canceled', 'pending']
                                          .contains(ordersController
                                              .selectedDelivery!.status)) {
                                        await Get.find<SocketService>()
                                            .joinTrackingRoom(
                                                trackingId: ordersController
                                                        .selectedDelivery
                                                        ?.trackingId ??
                                                    "",
                                                msg: "join_room");
                                      }
                                      Get.toNamed(
                                          Routes.DELIVERY_TRACKING_SCREEN);
                                      ordersController.drawPolyLineFromOriginToDestination(
                                          context,
                                          originLatitude: ordersController
                                              .selectedDelivery!
                                              .originLocation
                                              .latitude,
                                          originLongitude: ordersController
                                              .selectedDelivery!
                                              .originLocation
                                              .longitude,
                                          originAddress: ordersController
                                              .selectedDelivery!
                                              .originLocation
                                              .name,
                                          destinationLatitude: ordersController
                                              .selectedDelivery!
                                              .destinationLocation
                                              .latitude,
                                          destinationLongitude: ordersController
                                              .selectedDelivery!
                                              .destinationLocation
                                              .longitude,
                                          destinationAddress: ordersController
                                              .selectedDelivery!
                                              .destinationLocation
                                              .name);
                                    },
                                    clickableTitle: "Track",
                                    value: ordersController
                                            .selectedDelivery?.trackingId ??
                                        "",
                                  ),
                            Visibility(
                              visible: !['pending'].contains(
                                  ordersController.selectedDelivery!.status),
                              child: ClickAbleOrderSummaryDetailItem(
                                  title: "Invoice number",
                                  onClick: () {
                                    Get.to(
                                        const DeliveryInvoiceDetailsScreen());
                                  },
                                  clickableTitle: "View Invoice",
                                  value: ordersController
                                          .selectedDelivery?.trackingId ??
                                      ""),
                            ),
                            DeliverySummaryDetailItem(
                                title: "Total cost",
                                isCurrency: true,
                                value: formatToCurrency(double.parse(
                                    ordersController.selectedDelivery?.cost ??
                                        "0.0"))),
                          ],
                        ),
                        SectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          children: [
                            DeliverySummaryDetailItem(
                              title: "Pick up address",
                              value: ordersController
                                      .selectedDelivery?.originLocation.name ??
                                  "",
                            ),
                            DeliverySummaryDetailItem(
                              title: "Sender",
                              value:
                                  '${ordersController.selectedDelivery?.sender?.firstName ?? Get.find<SettingsController>().userProfile?.fname ?? ""} ${ordersController.selectedDelivery?.sender?.lastName ?? Get.find<SettingsController>().userProfile?.lname ?? ""}',
                            ),
                            DeliverySummaryDetailItem(
                              title: "Phone number",
                              value: ordersController
                                      .selectedDelivery?.sender?.phone ??
                                  Get.find<SettingsController>()
                                      .userProfile
                                      ?.phone ??
                                  "",
                            ),
                          ],
                        ),
                        SectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          children: [
                            DeliverySummaryDetailItem(
                              title: "Receiver",
                              value: ordersController
                                      .selectedDelivery?.receiver.name ??
                                  "",
                            ),
                            DeliverySummaryDetailItem(
                              title: "Drop off address",
                              value: ordersController.selectedDelivery
                                      ?.destinationLocation.name ??
                                  "",
                            ),
                            DeliverySummaryDetailItem(
                              title: "Phone number",
                              value: ordersController
                                      .selectedDelivery?.receiver.phone ??
                                  "",
                            ),
                            Visibility(
                              visible: !['canceled', 'pending'].contains(
                                  ordersController.selectedDelivery!.status),
                              child: DeliverySummaryDetailItem(
                                  title: "Total amount",
                                  isCurrency: true,
                                  // value: formatToCurrency(double.parse(ordersController.selectedShipment?. ?? "")),
                                  value: formatToCurrency(double.parse(
                                      ordersController.selectedDelivery?.cost ??
                                          "0.0"))),
                            ),
                          ],
                        ),
                        TitleSectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          title: "Delivery Items",
                          children: [
                            ...List.generate(
                              ordersController.selectedDelivery!.items.length,
                              (i) => OrderItemSummaryAccordion(
                                shipmentItemData:
                                    ordersController.selectedDelivery!.items[i],
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: ![
                            'canceled',
                            'pending',
                            'confirmed'
                          ].contains(
                              ordersController.selectedDelivery!.status ?? ""),
                          child: TitleSectionBox(
                            backgroundColor: AppColors.backgroundColor,
                            title: "Rider",
                            children: [
                              DeliverySummaryDetailItem(
                                title: "Name",
                                value:
                                    '${ordersController.selectedDelivery?.rider?.firstName ?? ""} ${ordersController.selectedDelivery?.rider?.lastName ?? ""}',
                              ),
                              DeliverySummaryDetailItem(
                                title: "Rider's phone number",
                                isPhone: true,
                                value: ordersController
                                        .selectedDelivery?.rider?.phone ??
                                    "",
                              ),
                              SizedBox(height: 5.h),
                            ],
                          ),
                        ),
                      ],
                    ),
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
