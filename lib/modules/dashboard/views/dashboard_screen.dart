import 'dart:io';

import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:upgrader/upgrader.dart';

// TODO: Rebuild the dashboard screen

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return GetBuilder<DeliveriesController>(builder: (ordersController) {
        return UpgradeAlert(
          barrierDismissible: false,
          showIgnore: false,
          showLater: false,
          showReleaseNotes: true,
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
          upgrader: Upgrader(
              messages: UpgraderMessages(code: "Kindly update your app")),
          child: Scaffold(
            appBar: flatAppBar(
              bgColor: AppColors.backgroundColor,
              navigationColor: AppColors.backgroundColor,
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(55.sp),
                child: Container(
                  width: 1.sw,
                  color: AppColors.backgroundColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<SettingsController>(
                          builder: (settingsController) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.sp),
                          color: AppColors.transparent,
                          child: Row(
                            children: [
                              Visibility(
                                visible:
                                    settingsController.userProfile?.avatar !=
                                        null,
                                replacement: CircleAvatar(
                                  radius: 22.r,
                                  backgroundColor: AppColors.backgroundColor,
                                  child: customText(
                                    "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                                    fontSize: 14.sp,
                                  ),
                                ),
                                child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                      settingsController.userProfile?.avatar ??
                                          '',
                                    ),
                                    radius: 22.r),
                              ),
                              SizedBox(
                                width: 8.sp,
                              ),
                              customText(
                                  "Hi ${settingsController.userProfile?.fname ?? ''}",
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600),
                            ],
                          ),
                        );
                      }),
                      GetBuilder<SettingsController>(
                          builder: (settingsController) {
                        return Row(
                          children: [
                            InkWell(
                              splashColor: AppColors.transparent,
                              highlightColor: AppColors.transparent,
                              onTap: () {
                                // Get.toNamed(Routes.NOTIFICATIONS_HOME);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.sp),
                                child: Badge(
                                  textColor: AppColors.whiteColor,
                                  backgroundColor: AppColors.primaryColor,
                                  isLabelVisible: true,
                                  label: customText(
                                    settingsController.userProfile?.leaf
                                            .toString() ??
                                        "0",
                                    fontSize: 12.sp,
                                  ),
                                  child: SvgPicture.asset(
                                    SvgAssets.leafIcon,
                                    color: AppColors.greenColor,
                                    height: 20.sp,
                                    width: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: AppColors.transparent,
                              highlightColor: AppColors.transparent,
                              onTap: () {
                                Get.toNamed(Routes.NOTIFICATIONS_HOME);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.sp),
                                child: Badge(
                                  textColor: AppColors.whiteColor,
                                  backgroundColor: AppColors.redColor,
                                  isLabelVisible: true,
                                  label: customText(
                                    settingsController.isLoadingNotification
                                        ? ''
                                        : settingsController
                                                    .notifications.length >
                                                10
                                            ? '10+'
                                            : settingsController
                                                .notifications.length
                                                .toString(),
                                    fontSize: 12.sp,
                                  ),
                                  child: SvgPicture.asset(
                                    SvgAssets.notificationIcon,
                                    color: AppColors.obscureTextColor,
                                    height: 20.sp,
                                    width: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              body: RefreshIndicator(
                backgroundColor: AppColors.primaryColor,
                color: AppColors.whiteColor,
                onRefresh: () async {
                  ordersController.fetchDeliveries();
                  Get.find<WalletController>().getWalletBalance();
                  Get.find<WalletController>().getTransactions();
                  Get.find<SettingsController>().getProfile();
                  Get.find<NotificationsController>().getNotifications();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                  color: AppColors.backgroundColor,
                  child: RefreshIndicator(
                    backgroundColor: AppColors.primaryColor,
                    onRefresh: () async {
                      ordersController.fetchDeliveries();
                      Get.find<WalletController>().getWalletBalance();
                      Get.find<WalletController>().getTransactions();
                      Get.find<SettingsController>().getProfile();
                      Get.find<NotificationsController>().getNotifications();
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 12.sp,
                              horizontal: 10.sp,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepAmberColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  "Track your parcel",
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 25.sp,
                                ),
                                SizedBox(
                                  height: 5.sp,
                                ),
                                Form(
                                  key: ordersController.deliveryTrackingFormKey,
                                  child: CustomRoundedInputField(
                                    label: "Enter your tracking number",
                                    title: "Tracking number",
                                    fontSize: 11.sp,
                                    controller:
                                        ordersController.trackingIdController,
                                    showLabel: true,
                                    prefixWidget: Container(
                                        padding: EdgeInsets.all(12.sp),
                                        child: SvgPicture.asset(
                                          SvgAssets.searchIcon,
                                        )),
                                    suffixWidget: CustomGreenTextButton(
                                      title: "Go",
                                      isLoading:
                                          ordersController.trackingDelivery,
                                      onPressed: () {
                                        ordersController.trackShipment(context);
                                      },
                                    ),
                                    // controller: signInProvider.emailController,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            width: 1.sw,
                            padding: EdgeInsets.symmetric(
                              vertical: 25.sp,
                              horizontal: 10.sp,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightRedColor,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: AppColors.whiteColor,
                                      shape: BoxShape.circle),
                                  padding: EdgeInsets.all(10.sp),
                                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                                  child: SvgPicture.asset(
                                    SvgAssets.parcelIcon,
                                  ),
                                ),
                                SizedBox(
                                  width: 4.sp,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        "Send an Item",
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 22.sp,
                                      ),
                                      SizedBox(
                                        height: 2.sp,
                                      ),
                                      customText(
                                        "Click Create to start",
                                        overflow: TextOverflow.visible,
                                        color: AppColors.blackColor,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                CustomGreenTextButton(
                                  title: "Create",
                                  onPressed: () {
                                    ordersController
                                        .prefillDeliverySenderDetails();
                                    Get.toNamed(
                                        Routes.INITIATE_DELIVERY_SCREEN);
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          ordersController.allDeliveries.isEmpty
                              ? const SectionHeader(
                                  title: "Deliveries",
                                )
                              : PartialViewHeader(
                                  title: "Deliveries",
                                  onPressed: () {
                                    Get.toNamed(Routes.DELIVERIES_HOME);
                                  },
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          ordersController.allDeliveries.isEmpty
                              ? Container(
                                  width: 1.sw,
                                  height: 1.sh * 0.4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customText(
                                        ordersController.fetchingDeliveries
                                            ? "Loading..."
                                            : "No deliveries yet",
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: List.generate(
                                    ordersController.allDeliveries.length,
                                    (i) => DeliveryItemWidget(
                                      onSelected: () async {
                                        await ordersController
                                            .setSelectedDelivery(
                                                ordersController
                                                    .allDeliveries[i]);
                                        if (![
                                          'delivered',
                                          'cancelled',
                                          'pending',
                                          'canceled'
                                        ].contains(ordersController
                                            .allDeliveries[i].status!
                                            .toLowerCase())) {
                                          await Get.find<SocketService>()
                                              .joinTrackingRoom(
                                                  trackingId: ordersController
                                                          .selectedDelivery
                                                          ?.trackingId ??
                                                      "",
                                                  msg: "join_room");

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
                                              destinationLatitude:
                                                  ordersController
                                                      .selectedDelivery!
                                                      .destinationLocation
                                                      .latitude,
                                              destinationLongitude:
                                                  ordersController
                                                      .selectedDelivery!
                                                      .destinationLocation
                                                      .longitude,
                                              destinationAddress:
                                                  ordersController
                                                      .selectedDelivery!
                                                      .destinationLocation
                                                      .name);
                                        } else {
                                          Get.toNamed(Routes
                                              .PROCESSED_DELIVERY_SUMMARY_SCREEN);
                                        }
                                      },
                                      delivery:
                                          ordersController.allDeliveries[i],
                                    ),
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
              ),
            ),
          ),
        );
      });
    });
  }
}
