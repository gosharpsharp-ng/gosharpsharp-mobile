import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveriesHomeScreen extends StatelessWidget {
  const DeliveriesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
      builder: (ordersController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Deliveries",
            implyLeading: false,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: RefreshIndicator(
            backgroundColor: AppColors.primaryColor,
            color: AppColors.whiteColor,
            onRefresh: () async {
              ordersController.fetchDeliveries();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.sp),
              height: 1.sh,
              width: 1.sw,
              color: AppColors.backgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClickableCustomRoundedInputField(
                    label: "Enter a query e.g: Xd391B",
                    isSearch: true,
                    color: AppColors.obscureTextColor,
                    hasTitle: true,
                    readOnly: true,
                    prefixWidget: Container(
                      padding: EdgeInsets.all(12.sp),
                      child: SvgPicture.asset(SvgAssets.searchIcon),
                    ),
                    suffixWidget: CustomGreenTextButton(
                      title: "Go",
                      onPressed: () {
                        ordersController.resetDeliveriesSearchFields();
                        showAnyBottomSheet(child: SearchDeliveriesScreen());
                      },
                    ),
                    onPressed: () {
                      ordersController.resetDeliveriesSearchFields();
                      showAnyBottomSheet(child: SearchDeliveriesScreen());
                    },
                  ),
                  SizedBox(height: 5.h),
                  const SectionHeader(title: "Deliveries"),
                  SizedBox(height: 10.h),
                  Visibility(
                    visible: ordersController.allDeliveries.isNotEmpty,
                    replacement: Container(
                      width: 1.sw,
                      height: 1.sh * 0.674,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customText(
                            ordersController.fetchingDeliveries
                                ? "Loading..."
                                : "No shipments yet",
                          ),
                        ],
                      ),
                    ),
                    child: Expanded(
                      child: SingleChildScrollView(
                        controller: ordersController.deliveriesScrollController,
                        child: Column(
                          children: [
                            ...List.generate(
                              ordersController.allDeliveries.length,
                              (i) => DeliveryItemWidget(
                                onSelected: () async {
                                  ordersController.setSelectedDelivery(
                                    ordersController.allDeliveries[i],
                                  );
                                  if (![
                                    'delivered',
                                    'canceled',
                                    'cancelled',
                                    'pending',
                                  ].contains(
                                    ordersController.selectedDelivery!.status,
                                  )) {
                                    // Navigate to tracking screen - WebSocket joining handled by screen's initState
                                    Get.toNamed(
                                      Routes.DELIVERY_TRACKING_SCREEN,
                                    );
                                    ordersController
                                        .drawPolyLineFromOriginToDestination(
                                          context,
                                          originLatitude: ordersController
                                              .selectedDelivery!
                                              .pickUpLocation
                                              .latitude,
                                          originLongitude: ordersController
                                              .selectedDelivery!
                                              .pickUpLocation
                                              .longitude,
                                          originAddress: ordersController
                                              .selectedDelivery!
                                              .pickUpLocation
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
                                              .name,
                                        );
                                  } else {
                                    Get.toNamed(
                                      Routes.PROCESSED_DELIVERY_SUMMARY_SCREEN,
                                    );
                                  }
                                },
                                delivery: ordersController.allDeliveries[i],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Visibility(
                              visible:
                                  ordersController.fetchingDeliveries &&
                                  ordersController.allDeliveries.isNotEmpty,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: customText(
                                    "Loading more...",
                                    color: AppColors.blueColor,
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  ordersController.allDeliveries.length ==
                                  ordersController.totalDeliveries,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: customText(
                                    "No more data to load",
                                    color: AppColors.blueColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
