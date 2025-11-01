import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:gosharpsharp/modules/delivery/views/widgets/cancel_delivery_bottomsheet.dart';
import 'package:gosharpsharp/modules/delivery/views/widgets/delivery_contact_option_bottomsheet.dart';
import 'package:gosharpsharp/modules/delivery/views/widgets/phone_number_widget.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  DraggableScrollableController? draggableScrollableController;
  final ordersController = Get.find<DeliveriesController>();
  final settingsController = Get.find<SettingsController>();
  SocketService? _socketService;

  @override
  void initState() {
    super.initState();
    // checkIfLocationPermissionIsAllowed();
    if (![
      'delivered',
      'rejected',
      'canceled',
      'cancelled',
    ].contains(ordersController.selectedDelivery!.status)) {
      startLocationTracking(
        trackingId: ordersController.selectedDelivery!.trackingId,
      );
    }
  }

  @override
  void dispose() {
    // Clean up WebSocket connection when screen is closed
    if (ordersController.selectedDelivery?.trackingId != null) {
      _socketService?.leaveParcelDeliveryTracking(
        ordersController.selectedDelivery!.trackingId,
      );
      _socketService?.stopListeningForDeliveryStatusUpdate();
    }
    super.dispose();
  }

  startLocationTracking({required String trackingId}) async {
    if (Get.isRegistered<SocketService>()) {
      _socketService = Get.find<SocketService>();

      // Join parcel delivery tracking room with new method
      _socketService?.joinParcelDeliveryTracking(trackingId);

      print("Listening to Parcel Delivery Tracking");

      // Listen for delivery status updates using new event
      _socketService?.listenForDeliveryStatusUpdate((data) {
        if (!mounted) return;

        // Handle location update from delivery:status-update event
        if (data.containsKey('lat') && data.containsKey('lon')) {
          updateMarkerPosition(
            currentRiderPosition: LatLng(
              double.parse(data['lat'].toString()),
              double.parse(data['lon'].toString()),
            ),
            degrees: double.parse(data['degrees'].toString()),
          );
          ordersController.checkProximityToLocations(
            LatLng(
              double.parse(data['lat'].toString()),
              double.parse(data['lon'].toString()),
            ),
            context,
          );
          if (data.containsKey('status')) {
            String newStatus = data['status'];
            if (data['status'] != ordersController.selectedDelivery!.status &&
                !ordersController.shownStatusToasts.contains(newStatus)) {
              FlutterRingtonePlayer().playNotification();
              showRiderAndDeliveryStatusDialog(
                title: "Status change",
                message:
                    "The current status of your delivery is: ${data['status']} ",
                delivery: ordersController.selectedDelivery!,
                context: context,
              );
              ordersController.shownStatusToasts.add(newStatus);
              ordersController.fetchDeliveries();
              ordersController.getDelivery();
            }
          }
        }
      });
    }
  }

  void updateMarkerPosition({
    required LatLng currentRiderPosition,
    required double degrees,
  }) async {
    if (!mounted) return;

    LatLng newPosition = LatLng(
      currentRiderPosition.latitude,
      currentRiderPosition.longitude,
    );
    LatLng closestPoint = getClosestPointOnPolyline(newPosition);

    double deviation = Geolocator.distanceBetween(
      newPosition.latitude,
      newPosition.longitude,
      closestPoint.latitude,
      closestPoint.longitude,
    );

    // Threshold for recalculating the route
    const double deviationThreshold = 50.0; // in meters

    // Recalculate the route
    if (['accepted'].contains(ordersController.selectedDelivery!.status)) {
      ordersController.drawPolylineFromRiderToDestination(
        context,
        destinationPosition: LatLng(
          double.parse(
            ordersController.selectedDelivery!.pickUpLocation.latitude,
          ),
          double.parse(
            ordersController.selectedDelivery!.pickUpLocation.longitude,
          ),
        ),
        currentRiderLocation: newPosition,
        riderDegrees: degrees,
      );
    } else if (['picked'].contains(ordersController.selectedDelivery!.status)) {
      ordersController.drawPolylineFromRiderToDestination(
        context,
        destinationPosition: LatLng(
          double.parse(
            ordersController.selectedDelivery!.destinationLocation.latitude,
          ),
          double.parse(
            ordersController.selectedDelivery!.destinationLocation.longitude,
          ),
        ),
        currentRiderLocation: newPosition,
        riderDegrees: degrees,
      );
    } else {
      // Update marker and camera
      setState(() {
        var markerId = const MarkerId("Rider");
        double rotation = calculateLocationDegrees(
          currentRiderPosition,
          newPosition,
        );

        final marker = Marker(
          markerId: markerId,
          position: newPosition,
          icon:
              ordersController.bikeMarkerIcon ?? BitmapDescriptor.defaultMarker,
          rotation: rotation,
          anchor: const Offset(0.5, 0.5),
        );

        ordersController.markerSet.removeWhere((m) => m.markerId == markerId);
        ordersController.markerSet.add(marker);

        if (ordersController.newGoogleMapController != null) {
          ordersController.newGoogleMapController!.animateCamera(
            CameraUpdate.newLatLng(newPosition),
          );
        }

        currentRiderPosition = newPosition;
      });
    }
  }

  LatLng getClosestPointOnPolyline(LatLng position) {
    double minDistance = double.infinity;
    LatLng closestPoint = position;

    for (LatLng point in ordersController.pLineCoordinatedList) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        point.latitude,
        point.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestPoint = point;
      }
    }

    return closestPoint;
  }

  LocationPermission? _locationPermission;
  checkIfLocationPermissionIsAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  LatLng? pickLocation;
  static const CameraPosition _kLagosPosition = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 14.4746,
  );
  Position? userCurrentPosition;
  locateUserPosition() async {
    final ordersController = Get.find<DeliveriesController>();

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );
    Position cPosition = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    userCurrentPosition = cPosition;
    LatLng latLngPosition = LatLng(
      userCurrentPosition!.latitude,
      userCurrentPosition!.longitude,
    );
    CameraPosition cameraPosition = CameraPosition(
      target: latLngPosition,
      zoom: 13,
    );
    ordersController.newGoogleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
      builder: (ordersController) {
        return Scaffold(
          appBar: flatAppBar(),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 0.sp),
            height: 1.sh,
            width: 1.sw,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 1.sw,
                    margin: EdgeInsets.symmetric(horizontal: 0.sp),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: GoogleMap(
                        myLocationEnabled: true,
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        polylines: ordersController.polyLineSet,
                        markers: ordersController.markerSet,
                        circles: ordersController.circleSet,
                        initialCameraPosition: _kLagosPosition,
                        scrollGesturesEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          if (!ordersController
                              .googleMapController
                              .isCompleted) {
                            ordersController.googleMapController.complete(
                              controller,
                            );
                          }
                          ordersController.newGoogleMapController = controller;
                          setState(() {});
                          // locateUserPosition();
                        },
                        onCameraMove: (CameraPosition? position) {
                          if (pickLocation != position!.target) {
                            pickLocation = position.target;
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex:
                      [
                        'delivered',
                      ].contains(ordersController.selectedDelivery!.status)
                      ? 2
                      : 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          MediaQuery.of(context).size.height *
                          0.63, // Ensure content does not exceed max size
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Container(
                        // height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.obscureTextColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              height: 5.sp,
                              width: 100.w,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.sp,
                                vertical: 10.sp,
                              ),
                              margin: EdgeInsets.only(
                                left: 10.sp,
                                right: 10.sp,
                                top: 10.sp,
                              ),
                              width: 1.sw,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.primaryColor,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4.sp),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.transparent,
                                          border: Border.all(
                                            color: AppColors.whiteColor,
                                            width: 1.sp,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          SvgAssets.parcelIcon,
                                          color: AppColors.whiteColor,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customText(
                                              "Pick up Address",
                                              color: AppColors.whiteColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.normal,
                                              overflow: TextOverflow.visible,
                                            ),
                                            SizedBox(height: 5.h),
                                            customText(
                                              ordersController
                                                      .selectedDelivery
                                                      ?.pickUpLocation
                                                      .name ??
                                                  "",
                                              color: AppColors.whiteColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  const DottedLine(
                                    dashLength: 3,
                                    dashGapLength: 3,
                                    lineThickness: 2,
                                    dashColor: AppColors.whiteColor,
                                    // lineLength: 150,
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4.sp),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.transparent,
                                          border: Border.all(
                                            color: AppColors.whiteColor,
                                            width: 1.sp,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          SvgAssets.locationIcon,
                                          color: AppColors.secondaryColor,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customText(
                                              "Drop off Address",
                                              color: AppColors.whiteColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.normal,
                                              overflow: TextOverflow.visible,
                                            ),
                                            SizedBox(height: 5.h),
                                            customText(
                                              ordersController
                                                      .selectedDelivery
                                                      ?.destinationLocation
                                                      .name ??
                                                  "",
                                              color: AppColors.whiteColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.sp,
                                vertical:
                                    ['delivered', 'confirmed'].contains(
                                      ordersController.selectedDelivery!.status,
                                    )
                                    ? 0
                                    : 10.sp,
                              ),
                              margin:
                                  ordersController.selectedDelivery?.rider ==
                                      null
                                  ? EdgeInsets.symmetric(
                                      horizontal: 10.sp,
                                      vertical:
                                          ['delivered', 'confirmed'].contains(
                                            ordersController
                                                .selectedDelivery!
                                                .status,
                                          )
                                          ? 0
                                          : 10.sp,
                                    )
                                  : EdgeInsets.symmetric(
                                      horizontal: 0.sp,
                                      vertical: 0.sp,
                                    ),
                              width: 1.sw,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.whiteColor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        ['accepted'].contains(
                                              ordersController
                                                  .selectedDelivery!
                                                  .status,
                                            )
                                            ? "The rider is on the way to pickup your item"
                                            : ['picked'].contains(
                                                ordersController
                                                    .selectedDelivery!
                                                    .status,
                                              )
                                            ? "The rider is on the way to deliver your item"
                                            : "",
                                        color: AppColors.primaryColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.normal,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: !['delivered', 'confirmed']
                                        .contains(
                                          ordersController
                                              .selectedDelivery!
                                              .status,
                                        ),
                                    child: SizedBox(height: 15.h),
                                  ),
                                  (ordersController.selectedDelivery?.rider !=
                                              null &&
                                          !['cancelled', 'canceled'].contains(
                                            ordersController
                                                .selectedDelivery!
                                                .status,
                                          ))
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                Visibility(
                                                  visible:
                                                      ordersController
                                                          .selectedDelivery
                                                          ?.rider
                                                          ?.avatar !=
                                                      null,
                                                  replacement: CircleAvatar(
                                                    radius: 20.r,
                                                    backgroundColor: AppColors
                                                        .backgroundColor,
                                                    child: customText(
                                                      "${ordersController.selectedDelivery?.rider?.firstName?.substring(0, 1) ?? ""}${ordersController.selectedDelivery?.rider?.lastName?.substring(0, 1) ?? ""}",
                                                      fontSize: 8.sp,
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                          ordersController
                                                                  .selectedDelivery
                                                                  ?.rider
                                                                  ?.avatar ??
                                                              '',
                                                        ),
                                                    radius: 20.r,
                                                  ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      customText(
                                                        "${ordersController.selectedDelivery?.rider?.firstName ?? ""} ${ordersController.selectedDelivery?.rider?.lastName ?? ""}",
                                                        color: AppColors
                                                            .blackColor,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      customText(
                                                        "Rider",
                                                        color: AppColors
                                                            .obscureTextColor,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        overflow: TextOverflow
                                                            .visible,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    right: 5.sp,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      showAnyBottomSheet(
                                                        isControlled: false,
                                                        child:
                                                            DeliveryContactOptionBottomSheet(),
                                                      );
                                                    },
                                                    child: SvgPicture.asset(
                                                      SvgAssets.callIcon,
                                                      height: 30.sp,
                                                      width: 30.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: customText(
                                                "We're working hard to assign a rider that will pick your delivery in no time",
                                                color: AppColors.primaryColor,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.normal,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          ],
                                        ),
                                  SizedBox(height: 15.h),
                                  const DottedLine(
                                    dashLength: 3,
                                    dashGapLength: 3,
                                    lineThickness: 2,
                                    dashColor: AppColors.primaryColor,
                                    // lineLength: 150,
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DeliveryTrackingMiniInfoItem(
                                        title: "Delivery status",
                                        value:
                                            ordersController
                                                .selectedDelivery
                                                ?.status!
                                                .capitalizeFirst ??
                                            "",
                                        isStatus: true,
                                      ),
                                      DeliveryTrackingMiniInfoItem(
                                        title: "Estimated distance",
                                        value:
                                            ordersController
                                                .distanceToDestination ??
                                            "",
                                      ),
                                      DeliveryTrackingMiniInfoItem(
                                        title: "ETA",
                                        value:
                                            ordersController
                                                .durationToDestination ??
                                            "",
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  const DottedLine(
                                    dashLength: 3,
                                    dashGapLength: 3,
                                    lineThickness: 2,
                                    dashColor: AppColors.primaryColor,
                                    // lineLength: 150,
                                  ),
                                  SizedBox(height: 16.h),
                                  Visibility(
                                    visible: ['delivered'].contains(
                                      ordersController.selectedDelivery!.status,
                                    ),
                                    child: SizedBox(height: 22.h),
                                  ),
                                  Visibility(
                                    visible:
                                        ordersController
                                                .selectedDelivery!
                                                .status ==
                                            "delivered" &&
                                        ordersController
                                                .selectedDelivery
                                                ?.rating ==
                                            null,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomButton(
                                        onPressed: () {
                                          ordersController.resetRatingFields();
                                          showAnyBottomSheet(
                                            isControlled: false,
                                            child: const RatingBottomSheet(),
                                          );
                                        },
                                        // isBusy: signInProvider.isLoading,
                                        title: "Rate",
                                        width: 1.sw,
                                        backgroundColor: AppColors.primaryColor,
                                        fontColor: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                  // Visibility(
                                  //   visible:!['picked','delivered','canceled'].contains(
                                  //       ordersController
                                  //           .selectedDelivery!.status),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(8.0),
                                  //     child: CustomButton(
                                  //       onPressed: () {
                                  //         showAnyBottomSheet(
                                  //             isControlled: false,
                                  //             child: const CancelDeliveryBottomSheet());
                                  //       },
                                  //       // isBusy: signInProvider.isLoading,
                                  //       title: "Cancel Ride",
                                  //       width: 1.sw,
                                  //       backgroundColor: AppColors.redColor,
                                  //       fontColor: AppColors.whiteColor,
                                  //     ),
                                  //   ),
                                  // ),
                                  Visibility(
                                    visible:
                                        ![
                                          'picked',
                                          'delivered',
                                          'canceled',
                                          'cancelled',
                                        ].contains(
                                          ordersController
                                              .selectedDelivery!
                                              .status,
                                        ),
                                    child: InkWell(
                                      onTap: () {
                                        showAnyBottomSheet(
                                          isControlled: false,
                                          child:
                                              const CancelDeliveryBottomSheet(),
                                        );
                                      },
                                      child: customText(
                                        "Cancel Ride",
                                        color: AppColors.redColor,
                                      ),
                                    ),
                                  ),
                                  [
                                        'delivered',
                                        'cancelled',
                                        'canceled',
                                      ].contains(
                                        ordersController
                                            .selectedDelivery!
                                            .status,
                                      )
                                      ? const SizedBox.shrink()
                                      : SizedBox(height: 5.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
