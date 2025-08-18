import 'package:gosharpsharp/modules/delivery/views/widgets/payment_method_selection_bottomsheet.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class RideSelectionScreen extends StatefulWidget {
  const RideSelectionScreen({super.key});

  @override
  State<RideSelectionScreen> createState() => _CreateRideScreenState();
}

class _CreateRideScreenState extends State<RideSelectionScreen> {
  checkIfLocationPermissionIsAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  DraggableScrollableController? draggableScrollableController;
  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionIsAllowed();
  }

  LatLng? pickLocation;
  static const CameraPosition _kLagosPosition = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 10.4746,
  );

  LocationPermission? _locationPermission;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return WillPopScope(
        onWillPop: () async {
          Get.back();
          Get.back();
          return true;
        },
        child: Scaffold(
          appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor, title: "Select Courier"),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
            child: CustomButton(
              title: "Continue",
              backgroundColor: (ordersController.availableRiders.isEmpty ||
                      !(ordersController.selectedDelivery!.courierTypePrices!
                          .any((price) => ordersController.availableRiders
                              .map((rider) =>
                                  rider.courierType.name.toLowerCase())
                              .contains(price.courierType.toLowerCase()))))
                  ? AppColors.disabledColor
                  : AppColors.primaryColor,
              onPressed: () {
                if (!(ordersController.availableRiders.isEmpty ||
                    !(ordersController.selectedDelivery!.courierTypePrices!.any(
                        (price) => ordersController.availableRiders
                            .map(
                                (rider) => rider.courierType.name.toLowerCase())
                            .contains(price.courierType.toLowerCase()))))) {
                  ordersController.confirmDelivery(context);
                }
              },
              isBusy: ordersController.submittingDelivery,
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            height: 1.sh,
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 5.sp),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
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
                        onMapCreated: (GoogleMapController controller) {
                          if (!ordersController
                              .googleMapController.isCompleted) {
                            ordersController.googleMapController
                                .complete(controller);
                          }
                          ordersController.newGoogleMapController = controller;
                          setState(() {});
                        },
                        onCameraMove: (CameraPosition? position) {
                          if (pickLocation != position!.target) {
                            pickLocation = position.target;
                          }
                        }),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Form(
                      key: ordersController.paymentMethodFormKey,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          width: 1.sw,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.sp,
                            vertical: 5.sp,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15.r),
                                  topLeft: Radius.circular(15.r))),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                customText("Select your preferred courier",
                                    color: AppColors.blackColor,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600),
                                Visibility(
                                  visible: (ordersController
                                          .availableRiders.isEmpty ||
                                      !(ordersController
                                          .selectedDelivery!.courierTypePrices!
                                          .any((price) => ordersController
                                              .availableRiders
                                              .map((rider) => rider
                                                  .courierType.name
                                                  .toLowerCase())
                                              .contains(price.courierType
                                                  .toLowerCase())))),
                                  child: customText(
                                      "Our Riders are currently busy",
                                      color: AppColors.redColor,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: customText("Estimated distance: ",
                                          color: AppColors.blackColor,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    // customText(
                                    //     " ${ordersController.selectedShipmentResponseModel!.distance.toPrecision(2).toString()}km",
                                    //     color: AppColors.blackColor,
                                    //     fontSize: 18.sp,
                                    //     fontWeight: FontWeight.w600),
                                    customText(
                                        " ${ordersController.rideDirectionDetailsInfo?.distance_text ?? "km"}",
                                        color: AppColors.blackColor,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                ['pending'].contains(ordersController
                                            .selectedDelivery?.status ??
                                        '')
                                    ? Column(
                                        children: [
                                          ...List.generate(
                                            ordersController.selectedDelivery!
                                                .courierTypePrices!.length,
                                            (i) => CurrierTypeContainer(
                                              isSelectable: !(ordersController
                                                      .availableRiders
                                                      .isEmpty ||
                                                  !(ordersController
                                                      .availableRiders
                                                      .map((i) => i
                                                          .courierType.name
                                                          .toLowerCase())
                                                      .toList()
                                                      .contains(ordersController
                                                          .selectedDelivery!
                                                          .courierTypePrices![i]
                                                          .courierType
                                                          .toLowerCase()))),
                                              currierType: ordersController
                                                  .selectedDelivery!
                                                  .courierTypePrices![i],
                                              isSelected: ordersController
                                                      .selectedDelivery!
                                                      .courierTypePrices![i] ==
                                                  ordersController
                                                      .selectedCourierTypePrice,
                                              onSelected: () {
                                                ordersController
                                                    .setSelectedCourierTypePrice(
                                                        ordersController
                                                            .selectedDelivery!
                                                            .courierTypePrices![i]);
                                              },
                                            ),
                                          )
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          ...List.generate(
                                            ordersController
                                                    .selectedDeliveryResponseModel
                                                    ?.courierTypePrices
                                                    .length ??
                                                0,
                                            (i) => CurrierTypeContainer(
                                              currierType: ordersController
                                                  .selectedDeliveryResponseModel!
                                                  .courierTypePrices[i],
                                              isSelectable: !(ordersController
                                                      .availableRiders
                                                      .isEmpty ||
                                                  !(ordersController
                                                      .availableRiders
                                                      .map((i) => i
                                                          .courierType.name
                                                          .toLowerCase())
                                                      .toList()
                                                      .contains(ordersController
                                                          .selectedDelivery!
                                                          .courierTypePrices![i]
                                                          .courierType
                                                          .toLowerCase()))),
                                              isSelected: ordersController
                                                      .selectedDeliveryResponseModel!
                                                      .courierTypePrices[i] ==
                                                  ordersController
                                                      .selectedCourierTypePrice,
                                              onSelected: () {
                                                ordersController
                                                    .setSelectedCourierTypePrice(
                                                        ordersController
                                                            .selectedDeliveryResponseModel!
                                                            .courierTypePrices[i]);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5.0, top: 5),
                                  child: ClickableCustomRoundedInputField(
                                    title: "Payment method",
                                    label: "Payment Method",
                                    readOnly: true,
                                    showLabel: true,
                                    hasTitle: true,
                                    onPressed: () {
                                      showAnyBottomSheet(
                                          isControlled: true,
                                          child:
                                              const PaymentMethodSelectionBottomsheet());
                                    },
                                    isRequired: true,
                                    controller: ordersController
                                        .paymentMethodController,
                                    suffixWidget: IconButton(
                                      onPressed: () {
                                        showAnyBottomSheet(
                                            isControlled: true,
                                            child:
                                                const PaymentMethodSelectionBottomsheet());
                                      },
                                      icon: SvgPicture.asset(
                                        SvgAssets.downChevronIcon,
                                        // h: 20.sp,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
