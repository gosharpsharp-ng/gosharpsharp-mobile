import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:gosharpsharp/core/models/available_rider_model.dart';
import 'package:gosharpsharp/core/models/payment_method_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class DeliveriesController extends GetxController {
  final deliveryService = serviceLocator<DeliveryService>();
  final sendingInfoFormKey = GlobalKey<FormState>();
  final itemDetailsFormKey = GlobalKey<FormState>();
  final deliveriesSearchFormKey = GlobalKey<FormState>();
  final deliveryTrackingFormKey = GlobalKey<FormState>();
  final deliveryRatingFormKey = GlobalKey<FormState>();
  final deliveryDisputeFormKey = GlobalKey<FormState>();
  final paymentMethodFormKey = GlobalKey<FormState>();

  // Lazy getter for SettingsController to avoid initialization order issues
  SettingsController get settingController => Get.find<SettingsController>();

  Set<String> shownStatusToasts = {};

  TextEditingController trackingIdController = TextEditingController();
  DeliveryModel? selectedDelivery;
  setSelectedDelivery(DeliveryModel sh) {
    statusDialogIsOpened = false;
    selectedDelivery = sh;
    shownStatusToasts.clear();
    update();
  }

  TextEditingController ratingReviewController = TextEditingController();
  double rating = 0.0;
  setDeliveryRating(double value) {
    rating = value;
    update();
  }

  bool ratingDelivery = false;
  resetRatingFields() {
    rating = 0.0;
    ratingReviewController.clear();
    update();
  }

  Future<void> rateDelivery(BuildContext context) async {
    if (deliveryRatingFormKey.currentState!.validate()) {
      ratingDelivery = true;
      update();
      final dynamic data = {
        "points": rating,
        "review": ratingReviewController.text,
      };
      // Call the API
      APIResponse response = await deliveryService.rateDelivery(
          data: data, deliveryId: selectedDelivery!.id);
      // Handle response
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
      ratingDelivery = false;
      update();
      if (response.status == "success") {
        rating = 0.0;
        ratingReviewController.clear();
        update();
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  TextEditingController disputeMessageController = TextEditingController();
  bool submittingDispute = false;
  Future<void> submitDispute(BuildContext context) async {
    if (deliveryDisputeFormKey.currentState!.validate()) {
      submittingDispute = true;
      update();
      final dynamic data = {
        "comment": disputeMessageController.text,
      };
      // Call the API
      APIResponse response = await deliveryService.raiseDispute(
        data: data,
      );
      // Handle response
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
      submittingDispute = false;
      update();
      if (response.status == "success") {
        disputeMessageController.clear();
        update();
      }
    }
  }

  bool cancellingDelivery = false;
  Future<void> cancelDelivery(BuildContext context) async {
    if (deliveryRatingFormKey.currentState!.validate()) {
      cancellingDelivery = true;
      update();
      final dynamic data = {
        "tracking_id": selectedDelivery!.trackingId,
        "action": "cancel",
      };
      // Call the API
      APIResponse response = await deliveryService.updateDeliveryStatus(data);
      // Handle response
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
      cancellingDelivery = false;
      update();
      if (response.status == "success") {
        selectedDelivery = DeliveryModel.fromJson(response.data);
        update();
      }
    }
  }

  String? distanceToDestination;
  String? durationToDestination;
  bool trackingDelivery = false;
  trackShipment(BuildContext context) async {
    if (deliveryTrackingFormKey.currentState!.validate()) {
      dynamic data = {'tracking_id': trackingIdController.text};
      trackingDelivery = true;
      update();
      APIResponse response = await deliveryService.trackDelivery(data);
      trackingDelivery = false;
      update();
      if (response.status == "success") {
        selectedDelivery = DeliveryModel.fromJson(response.data);
        if ([].contains(selectedDelivery?.status)) {
          drawPolyLineFromOriginToDestination(context,
              originLatitude: selectedDelivery!.originLocation.latitude,
              originLongitude: selectedDelivery!.originLocation.longitude,
              originAddress: selectedDelivery!.originLocation.name,
              destinationLatitude:
                  selectedDelivery!.destinationLocation.latitude,
              destinationLongitude:
                  selectedDelivery!.destinationLocation.longitude,
              destinationAddress: selectedDelivery!.destinationLocation.name);
          Get.toNamed(Routes.DELIVERY_TRACKING_SCREEN);
          trackingIdController.clear();
          update();
        }
      } else {
        showToast(
          message: response.message,
          isError: response.status != "success",
        );
      }
    }
  }

  BitmapDescriptor? bikeMarkerIcon;
  getBikeIcon() async {
    var icon = await BitmapDescriptor.asset(
        const ImageConfiguration(), PngAssets.motorCycleIcon,
        width: 35.sp, height: 35.sp);
    bikeMarkerIcon = icon;
    update();
  }

  resetDeliveriesSearchFields() {
    searchQueryController.clear();
    deliverySearchResults.clear();
    searchDeliveriesPageSize = 15;
    currentSearchDeliveriesPage = 1;
    totalSearchDeliveries = 0;
    update();
  }

  final ScrollController searchDeliveriesScrollController = ScrollController();
  bool searchingDeliveries = false;

  void _searchDeliveriesScrollListener() {
    if (searchDeliveriesScrollController.position.pixels >=
        searchDeliveriesScrollController.position.maxScrollExtent - 100) {
      searchDeliveries(isLoadMore: true);
    }
  }

  int searchDeliveriesPageSize = 15;
  int totalSearchDeliveries = 0;
  int currentSearchDeliveriesPage = 1;
  List<DeliveryModel> deliverySearchResults = [];

  TextEditingController searchQueryController = TextEditingController();

  setTotalSearchDeliveries(int val) {
    totalSearchDeliveries = val;
    update();
  }

  searchDeliveries({bool isLoadMore = false}) async {
    if (searchingDeliveries ||
        (isLoadMore && deliverySearchResults.length >= totalSearchDeliveries))
      return;

    if (!deliveriesSearchFormKey.currentState!.validate()) return;

    searchingDeliveries = true;
    update();

    if (!isLoadMore) {
      deliverySearchResults.clear(); // Clear only when not loading more
      currentSearchDeliveriesPage = 1;
    }

    dynamic data = {
      'search': searchQueryController.text,
      "page": currentSearchDeliveriesPage,
      "per_page": searchDeliveriesPageSize,
    };

    APIResponse response = await deliveryService.searchDeliveries(data);
    searchingDeliveries = false;
    update();

    if (response.status == "success") {
      List<DeliveryModel> newResults = (response.data['data'] as List)
          .map((sh) => DeliveryModel.fromJson(sh))
          .toList();

      if (isLoadMore) {
        deliverySearchResults.addAll(newResults);
      } else {
        deliverySearchResults = newResults;
      }

      setTotalSearchDeliveries(response.data['total']);
      currentSearchDeliveriesPage++; // Increment for next load more
      update();
    } else {
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
    }
  }

  final ScrollController deliveriesScrollController = ScrollController();
  bool fetchingDeliveries = false;

  void _deliveriesScrollListener() {
    if (deliveriesScrollController.position.pixels >=
        deliveriesScrollController.position.maxScrollExtent - 100) {
      fetchDeliveries(isLoadMore: true);
    }
  }

  int deliveriesPageSize = 15;
  int totalDeliveries = 0;
  int currentDeliveriesPage = 1;
  List<DeliveryModel> allDeliveries = [];

  setTotalDeliveries(int val) {
    totalDeliveries = val;
    update();
  }

  fetchDeliveries({bool isLoadMore = false}) async {
    if (fetchingDeliveries ||
        (isLoadMore && allDeliveries.length >= totalDeliveries)) return;

    fetchingDeliveries = true;
    update();

    if (!isLoadMore) {
      allDeliveries.clear(); // Clear only when not loading more
      currentDeliveriesPage = 1;
    }

    dynamic data = {
      "page": currentDeliveriesPage,
      "per_page": deliveriesPageSize,
    };
    final getStorage = GetStorage();
    APIResponse response = await deliveryService.getAllDeliveries(data);
    fetchingDeliveries = false;
    update();
    if (response.status == "success") {
      List<DeliveryModel> newDeliveries = (response.data['data'] as List)
          .map((sh) => DeliveryModel.fromJson(sh))
          .toList();
      if (isLoadMore) {
        allDeliveries.addAll(newDeliveries);
      } else {
        allDeliveries = newDeliveries;
      }

      setTotalDeliveries(response.data['total']);
      currentDeliveriesPage++; // Increment for next load more
      update();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  Future<void> getDelivery() async {
    fetchingDeliveries = true;
    update();

    APIResponse response =
        await deliveryService.getDelivery({'id': selectedDelivery!.id});
    fetchingDeliveries = false;
    update();
    if (response.status == "success") {
      selectedDelivery = DeliveryModel.fromJson(response.data);
      update();
    }
  }

  PaymentMethodModel? selectedPaymentMethod;
  setSelectedPaymentMethod(PaymentMethodModel pm) {
    selectedPaymentMethod = pm;
    paymentMethodController.text = pm.name;
    update();
  }

  CourierTypePrice? selectedCourierTypePrice;
  setSelectedCourierTypePrice(CourierTypePrice ct) {
    selectedCourierTypePrice = ct;
    update();
  }

  // Mock bike and payment selection
  String? selectedBikeType;
  String? selectedPaymentType;

  setSelectedBikeType(String bikeType) {
    selectedBikeType = bikeType;
    update();
  }

  setSelectedPaymentType(String paymentType) {
    selectedPaymentType = paymentType;
    update();
  }

  DeliveryResponseModel? selectedDeliveryResponseModel;
  static const CameraPosition kLagosPosition = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 14.4746,
  );
  ItemLocation? deliverySenderLocation;
  ItemLocation? deliveryReceiverLocation;
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  DirectionDetailsInfo? rideDirectionDetailsInfo;
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;
  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polyLineSet = {};
  Future<void> drawPolyLineFromOriginToDestination(BuildContext context,
      {required String originLatitude,
      required String originLongitude,
      required String destinationLatitude,
      required String destinationLongitude,
      required String originAddress,
      required String destinationAddress}) async {
    await googleMapController.future;
    var originLatLng =
        LatLng(double.parse(originLatitude), double.parse(originLongitude));
    var destinationLatLng = LatLng(
        double.parse(destinationLatitude), double.parse(destinationLongitude));

    var directionDetailsInfo = await obtainOriginToDestinationDirectionDetails(
        originLatLng, destinationLatLng);

    rideDirectionDetailsInfo = directionDetailsInfo;
    distanceToDestination = rideDirectionDetailsInfo!.distance_text;
    durationToDestination = rideDirectionDetailsInfo!.duration_text;

    // Navigator.pop(context);
    PolylinePoints pPoints = PolylinePoints(apiKey: Secret.apiKey);
    List<PointLatLng> decodePolyLinePointsResultList =
    PolylinePoints.decodePolyline(directionDetailsInfo.e_points!);
    pLineCoordinatedList.clear();
    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      update();
    }
    polyLineSet.clear();
    Polyline polyline = Polyline(
        polylineId: const PolylineId("PolyLineId"),
        jointType: JointType.round,
        color: AppColors.primaryColor,
        points: pLineCoordinatedList,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
        width: 5);

    polyLineSet.add(polyline);
    update();
    LatLngBounds latLngBounds;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, originLatLng.longitude));
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast:
              LatLng(originLatLng.latitude, destinationLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    if (newGoogleMapController != null) {
      newGoogleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 65));
    } else {
      print("================================================");
      print("GoogleMapController is not initialized yet.");
      print("================================================");
    }
    Marker originMarker = Marker(
      markerId: const MarkerId('OriginID'),
      infoWindow: InfoWindow(title: originAddress ?? "", snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationID'),
      infoWindow:
          InfoWindow(title: destinationAddress ?? "", snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    markerSet.add(originMarker);
    markerSet.add(destinationMarker);

    update();
  }

  Future<void> drawPolylineFromRiderToDestination(BuildContext context,
      {required LatLng destinationPosition,
      required LatLng currentRiderLocation,
      required double riderDegrees}) async {
    // Get the user's current location
    LatLng riderLatLng = currentRiderLocation;
    await googleMapController.future;
    // Fetch direction details
    var directionDetailsInfo = await obtainOriginToDestinationDirectionDetails(
        riderLatLng, destinationPosition);

    rideDirectionDetailsInfo = directionDetailsInfo;
    distanceToDestination = rideDirectionDetailsInfo!.distance_text;
    durationToDestination = rideDirectionDetailsInfo!.duration_text;

    // Decode the polyline points
    PolylinePoints polylinePoints = PolylinePoints(apiKey:Secret.apiKey);
    List<PointLatLng> decodedPolylinePoints =
    PolylinePoints.decodePolyline(directionDetailsInfo.e_points ?? "");

    pLineCoordinatedList.clear();
    if (decodedPolylinePoints.isNotEmpty) {
      decodedPolylinePoints.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      update();
    }

    // Create and add the polyline
    polyLineSet.clear();
    Polyline polyline = Polyline(
      polylineId: const PolylineId("UserToSenderPolyline"),
      jointType: JointType.mitered,
      color: Colors.green[700]!,
      points: pLineCoordinatedList,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
      width: 5,
    );

    polyLineSet.add(polyline);
    update();

    // Adjust camera bounds
    LatLngBounds latLngBounds;
    if (riderLatLng.latitude > destinationPosition.latitude &&
        riderLatLng.longitude > destinationPosition.longitude) {
      latLngBounds =
          LatLngBounds(southwest: destinationPosition, northeast: riderLatLng);
    } else if (riderLatLng.longitude > destinationPosition.longitude) {
      latLngBounds = LatLngBounds(
          southwest:
              LatLng(riderLatLng.latitude, destinationPosition.longitude),
          northeast:
              LatLng(destinationPosition.latitude, riderLatLng.longitude));
    } else if (riderLatLng.latitude > destinationPosition.latitude) {
      latLngBounds = LatLngBounds(
          southwest:
              LatLng(destinationPosition.latitude, riderLatLng.longitude),
          northeast:
              LatLng(riderLatLng.latitude, destinationPosition.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: riderLatLng, northeast: destinationPosition);
    }

    if (newGoogleMapController != null) {
      newGoogleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          latLngBounds,
          65,
        ),
      );
    } else {
      print("GoogleMapController is not initialized yet.");
    }

    // Add markers

    Marker originMarker = Marker(
      markerId: const MarkerId("Rider"),
      rotation: riderDegrees,
      infoWindow: const InfoWindow(title: "Rider", snippet: "Rider's location"),
      position: LatLng(
        riderLatLng.latitude,
        riderLatLng.longitude,
      ),
      icon: bikeMarkerIcon ?? BitmapDescriptor.defaultMarker,
    );
    Marker? destinationMarker;
    if (['accepted'].contains(selectedDelivery!.status)) {
      destinationMarker = Marker(
        markerId: const MarkerId('senderID'),
        infoWindow: InfoWindow(
            title: selectedDelivery?.originLocation.name ?? "",
            snippet: "Sender"),
        position: LatLng(
            double.parse(selectedDelivery!.originLocation.latitude),
            double.parse(selectedDelivery!.originLocation.longitude)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    } else if (['picked'].contains(selectedDelivery!.status)) {
      destinationMarker = Marker(
        markerId: const MarkerId('receiverID'),
        infoWindow: InfoWindow(
            title: selectedDelivery?.destinationLocation.name ?? "",
            snippet: "Receiver"),
        position: LatLng(
            double.parse(selectedDelivery!.destinationLocation.latitude),
            double.parse(selectedDelivery!.destinationLocation.longitude)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    }
    markerSet.clear();
    markerSet.add(originMarker);
    if (destinationMarker != null) {
      markerSet.add(destinationMarker);
    }
    update();
  }

  setDeliverySenderLocation(ItemLocation point) {
    deliverySenderLocation = point;
    senderAddressController.setText(point.formattedAddress!);
    update();
  }

  setDeliveryReceiverLocation(ItemLocation point) {
    deliveryReceiverLocation = point;
    receiverAddressController.setText(point.formattedAddress!);
    update();
  }

  List<DeliveryItemData> deliveryItems = [];
  DeliveryItemData? selectedDeliveryItemForItem;
  TextEditingController senderNameController = TextEditingController();
  TextEditingController senderAddressController = TextEditingController();
  TextEditingController receiverNameController = TextEditingController();
  TextEditingController estimatedDistanceController = TextEditingController();
  TextEditingController receiverEmailController = TextEditingController();
  TextEditingController receiverPhoneController = TextEditingController();
  TextEditingController receiverAddressController = TextEditingController();

  TextEditingController deliveryItemNameController = TextEditingController();
  TextEditingController deliveryItemDescriptionController =
      TextEditingController();
  TextEditingController deliveryItemCategoryController =
      TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController deliveryItemQuantityController =
      TextEditingController();
  setReceiverPhoneNumber(PhoneNumber num) {
    receiverPhoneController.text = num.number;
    update();
  }

  PhoneNumber? filledPhoneNumber;
  setFilledPhoneNumber(PhoneNumber num) {
    filledPhoneNumber = num;
    update();
  }

  List<File> deliveryItemImages = [];
  setDeliveryItemCategory(String cat) {
    deliveryItemCategoryController.setText(cat);
    update();
  }

  void clearFields() {
    senderNameController.clear();
    prefillDeliverySenderDetails();
    senderAddressController.clear();
    estimatedDistanceController.clear();
    receiverNameController.clear();
    receiverEmailController.clear();
    receiverPhoneController.clear();
    receiverAddressController.clear();
    deliveryItemNameController.clear();
    deliveryItemDescriptionController.clear();
    deliveryItemCategoryController.clear();
    deliveryItemQuantityController.clear();
    selectedCourierTypePrice = null;
    filledPhoneNumber = null;
    deliveryItems.clear();
    imageUploaded = false;
    parcelImage = null;
    deliveryItemImages.clear();
    deliverySenderLocation = null;
    deliveryReceiverLocation = null;
    update();
  }

  bool? imageUploaded;
  DeliveryItemData? deliveryData;
  addDeliveryItem() {
    if (parcelImage != null) {
      imageUploaded = true;
      update();
      if (itemDetailsFormKey.currentState!.validate()) {
        deliveryItems.clear();
        deliveryItems.add(DeliveryItemData(
            name: deliveryItemNameController.text,
            description: deliveryItemDescriptionController.text,
            category: deliveryItemCategoryController.text,
            weight: 1.5,
            height: 0.3,
            quantity: int.parse(deliveryItemQuantityController.text),
            image: parcelImage!));
        update();
      }
    } else {
      imageUploaded = false;
      update();
    }
    update();
  }
  // addDeliveryItem() {
  //   if (parcelImage != null) {
  //     imageUploaded = true;
  //     update();
  //     if (itemDetailsFormKey.currentState!.validate()) {
  //       deliveriesItems.add(DeliveryItemData(
  //           name: deliveryItemNameController.text,
  //           description: deliveryItemDescriptionController.text,
  //           category: deliveryItemCategoryController.text,
  //           weight: 1.5,
  //           height: 0.3,
  //           quantity: int.parse(deliveryItemQuantityController.text),
  //           image: parcelImage!));
  //       deliveryItemNameController.clear();
  //       deliveryItemDescriptionController.clear();
  //       deliveryItemCategoryController.clear();
  //       deliveryItemQuantityController.clear();
  //       deliveryItemImages.clear();
  //       parcelImage = null;
  //       imageUploaded = false;
  //       update();
  //     }
  //   } else {
  //     imageUploaded = false;
  //     update();
  //   }
  //   update();
  // }

  continueDelivery() {
    // Case 1: delivery items exist, but fields are empty
    if (deliveryItems.isNotEmpty && !_hasAnyFieldValue()) {
      Get.toNamed(Routes.DELIVERY_SUMMARY_SCREEN);
      return;
    }

    // Case 2: delivery items exist, and fields have data
    if (deliveryItems.isNotEmpty && _hasAnyFieldValue()) {
      if ((itemDetailsFormKey.currentState?.validate() ?? false) &&
          parcelImage != null) {
        addDeliveryItem();
        Get.toNamed(Routes.DELIVERY_SUMMARY_SCREEN);
      }
      return;
    }

    // Case 3: No delivery items, but fields have data
    if (deliveryItems.isEmpty && _hasAnyFieldValue()) {
      if ((itemDetailsFormKey.currentState?.validate() ?? false) &&
          parcelImage != null) {
        addDeliveryItem();
        Get.toNamed(Routes.DELIVERY_SUMMARY_SCREEN);
      } else {
        showToast(
            message: "Please fill all the required fields", isError: true);
      }
      return;
    }
  }

  prefillDeliverySenderDetails() {
    senderNameController.setText(
        "${settingController.userProfile?.fname ?? ''} ${settingController.userProfile?.lname ?? ''}");
    deliveryItemQuantityController.setText("1");
    receiverEmailController.setText("");
    setDeliveryItemCategory(parcelCategories[0]);
    update();
  }

  int? selectedDeliveryItemIndex;
  editDeliveryItem() {
    deliveryItemNameController.setText(selectedDeliveryItemForItem?.name ?? "");
    deliveryItemDescriptionController
        .setText(selectedDeliveryItemForItem?.description ?? "");
    deliveryItemCategoryController
        .setText(selectedDeliveryItemForItem?.category ?? "");
    deliveryItemQuantityController
        .setText((selectedDeliveryItemForItem?.quantity ?? 0).toString());
    parcelImage = selectedDeliveryItemForItem!.image;
    update();
  }

  bool submittingDelivery = false;
  submitDelivery(BuildContext context) async {
    // removeFocus();
    submittingDelivery = true;
    update();
    // Case 1: delivery items exist, but fields are empty
    if (deliveryItems.isNotEmpty &&
        parcelImage != null &&
        !_hasAnyFieldValue()) {
      await _callDeliveryEndpoint(context);
      return;
    }

    // Case 2: delivery items exist, and fields have data
    if (deliveryItems.isNotEmpty &&
        parcelImage != null &&
        _hasAnyFieldValue()) {
      if (itemDetailsFormKey.currentState?.validate() ?? false) {
        addDeliveryItem();
        await _callDeliveryEndpoint(context);
      }
      return;
    }

    // Case 3: No delivery items, but fields have data
    if (deliveryItems.isEmpty && parcelImage != null && _hasAnyFieldValue()) {
      if (itemDetailsFormKey.currentState?.validate() ?? false) {
        addDeliveryItem();
        await _callDeliveryEndpoint(context);
      }
      return;
    }
    submittingDelivery = false;
    update();
  }

  void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  bool gettingDistance = false;
  DirectionDetailsInfo? distanceDetails;
  getRideEstimatedDistance() async {
    gettingDistance = true;
    update();
    distanceDetails = await obtainOriginToDestinationDirectionDetails(
        LatLng(deliverySenderLocation!.latitude,
            deliverySenderLocation!.longitude),
        LatLng(deliveryReceiverLocation!.latitude,
            deliveryReceiverLocation!.longitude));
    gettingDistance = false;
    update();
    if (distanceDetails != null) {
      estimatedDistanceController.text =
          (distanceDetails!.distance_value! / 1000).toStringAsFixed(1);
      update();
    }
  }

  Future<void> _callDeliveryEndpoint(BuildContext context) async {
    submittingDelivery = true;
    update();
    final dynamic data = {
      'receiver': {
        "name": receiverNameController.text,
        "address": receiverAddressController.text,
        "phone_number": filledPhoneNumber?.completeNumber ?? '',
        "email": receiverEmailController.text,
      },
      "distance": double.parse(estimatedDistanceController.text),
      "origin_location": {
        "name": deliverySenderLocation?.formattedAddress ?? "",
        "latitude": deliverySenderLocation?.latitude ?? "",
        "longitude": deliverySenderLocation?.longitude ?? "",
      },
      "destination_location": {
        "name": deliveryReceiverLocation?.formattedAddress ?? "",
        "latitude": deliveryReceiverLocation?.latitude ?? "",
        "longitude": deliveryReceiverLocation?.longitude ?? "",
      },
      "items": deliveryItems.map((item) {
        final itemJson = item.toJson();
        // itemJson.remove('imageFiles'); // Remove the 'imageFiles' field
        return itemJson;
      }).toList(),
    };

    // Call the API
    APIResponse response = await deliveryService.createDelivery(data);
    // Handle response
    showToast(
      message: response.message,
      isError: response.status != "success",
    );
    submittingDelivery = false;
    update();
    if (response.status == "success") {
      selectedDeliveryResponseModel =
          DeliveryResponseModel.fromJson(response.data);
      selectedDelivery = DeliveryModel.fromJson(response.data);

      update();
      fetchDeliveries();
      clearFields();
      setSelectedPaymentMethod(
          selectedDeliveryResponseModel!.paymentMethods[0]);
      drawPolyLineFromOriginToDestination(context,
          originLatitude:
              selectedDeliveryResponseModel!.originLocation.latitude,
          originLongitude:
              selectedDeliveryResponseModel!.originLocation.longitude,
          originAddress: selectedDeliveryResponseModel!.originLocation.name,
          destinationLatitude:
              selectedDeliveryResponseModel!.destinationLocation.latitude,
          destinationLongitude:
              selectedDeliveryResponseModel!.destinationLocation.longitude,
          destinationAddress:
              selectedDeliveryResponseModel!.destinationLocation.name);
      Get.offNamed(Routes.RIDE_SELECTION_SCREEN);
    }
  }

  Future<void> confirmDelivery(BuildContext context) async {
    if (selectedCourierTypePrice != null) {
      if (paymentMethodFormKey.currentState!.validate()) {
        submittingDelivery = true;
        update();
        final dynamic data = {
          "tracking_id": ['pending'].contains(selectedDelivery?.status ?? '')
              ? selectedDelivery!.trackingId
              : selectedDeliveryResponseModel!.trackingId,
          "courier_id": selectedCourierTypePrice!.courierTypeId,
          "action": "confirm",
          "payment_method_id": selectedPaymentMethod!.id,
        };

        // Call the API
        APIResponse response = await deliveryService.confirmDelivery(data);
        // Handle response
        showToast(
          message: response.message,
          isError: response.status != "success",
        );
        submittingDelivery = false;
        update();
        if (response.status == "success") {
          selectedDelivery = DeliveryModel.fromJson(response.data);
          update();
          drawPolyLineFromOriginToDestination(context,
              originLatitude: selectedDelivery!.originLocation.latitude,
              originLongitude: selectedDelivery!.originLocation.longitude,
              originAddress: selectedDelivery!.originLocation.name,
              destinationLatitude:
                  selectedDelivery!.destinationLocation.latitude,
              destinationLongitude:
                  selectedDelivery!.destinationLocation.longitude,
              destinationAddress: selectedDelivery!.destinationLocation.name);
          fetchDeliveries();
          startLocationTracking(
              trackingId: selectedDelivery!.trackingId, context: Get.context!);
          Get.offNamed(Routes.DELIVERY_SUCCESS_SCREEN);
        }
      }
    } else {
      checkOrderConfirmationDialog(context);
    }
  }

  List<AvailableRiderModel> availableRiders = [];
  bool _hasAnyFieldValue() {
    return deliveryItemNameController.text.isNotEmpty ||
        deliveryItemCategoryController.text.isNotEmpty ||
        deliveryItemQuantityController.text.isNotEmpty ||
        deliveryItemImages.isNotEmpty ||
        parcelImage!.length > 5;
  }

  List<String> parcelCategories = [
    "non-fragile",
    "fragile",
  ];
  validateSendingInformation() {
    if (sendingInfoFormKey.currentState!.validate() &&
        receiverPhoneController.text.isNotEmpty) {
      Get.find<SocketService>().listenForAvailableRiders(onRiderOnline: (data) {
        availableRiders =
            (data as List).map((r) => AvailableRiderModel.fromJson(r)).toList();
        update();
        if ((availableRiders.isEmpty ||
            !(selectedDelivery!.courierTypePrices!.any((price) =>
                availableRiders
                    .map((rider) => rider.courierType.name.toLowerCase())
                    .contains(price.courierType.toLowerCase()))))) {
          selectedCourierTypePrice = null;
          update();
        }
      });
      Get.toNamed(Routes.DELIVERY_ITEM_INPUT_SCREEN);
    }
  }

  final ImagePicker _picker = ImagePicker();
  String? parcelImage;
  selectParcelImage({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      final croppedPhoto = await cropImage(photo);
      deliveryItemImages.clear();
      parcelImage = await convertImageToBase64(croppedPhoto.path);
      update();
    }
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: customText("Confirm Exit"),
          content: customText(
              "You have not confirmed this order. Are you sure you want to exit?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User chose not to exit
              },
              child: customText("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed exit
              },
              child: customText("Exit"),
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Return false if dialog is dismissed
  }

  checkOrderConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.info,
                color: AppColors.primaryColor,
                size: 25.sp,
              ),
            ],
          ),
          content: customText(
            "You need to select a courier to continue",
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // User confirmed exit
              },
              child: customText("OK",
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    ); // Return false if dialog is dismissed
  }

  bool statusDialogIsOpened = false;
  void checkProximityToLocations(
      LatLng currentRiderPosition, BuildContext context) {
    // Define sender's location
    LatLng senderLocation = LatLng(
      double.parse(selectedDelivery!.originLocation.latitude),
      double.parse(selectedDelivery!.originLocation.longitude),
    );

    // Define receiver's location
    LatLng receiverLocation = LatLng(
      double.parse(selectedDelivery!.destinationLocation.latitude),
      double.parse(selectedDelivery!.destinationLocation.longitude),
    );

    // Define a threshold distance (e.g., 50 meters)
    const double proximityThreshold = 40.0;

    // Calculate distances
    double distanceToSender = Geolocator.distanceBetween(
      currentRiderPosition.latitude,
      currentRiderPosition.longitude,
      senderLocation.latitude,
      senderLocation.longitude,
    );

    double distanceToReceiver = Geolocator.distanceBetween(
      currentRiderPosition.latitude,
      currentRiderPosition.longitude,
      receiverLocation.latitude,
      receiverLocation.longitude,
    );

    // Check if the rider has arrived at the sender's location
    if (distanceToSender <= proximityThreshold &&
        ['accepted'].contains(selectedDelivery!.status) &&
        !statusDialogIsOpened) {
      statusDialogIsOpened = true;
      update();
      FlutterRingtonePlayer().playNotification();
      showRiderAndDeliveryStatusDialog(
          context: context,
          title: "Rider is here",
          message: "The rider is here to pick your order",
          delivery: selectedDelivery!);
    }

    // Check if the rider has arrived at the receiver's location
    if (distanceToReceiver <= proximityThreshold &&
        ['picked'].contains(selectedDelivery!.status) &&
        !statusDialogIsOpened) {
      FlutterRingtonePlayer().playNotification();
      showRiderAndDeliveryStatusDialog(
          context: context,
          title: "Rider at receiver's location",
          message: "The rider has arrived with your delivery",
          delivery: selectedDelivery!);
      // Trigger receiver arrival logic here
    }
  }

  startLocationTracking(
      {required String trackingId, required BuildContext context}) async {
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>()
          .joinTrackingRoom(trackingId: trackingId, msg: "join_room");
      // Otherwise send location update
      Get.find<SocketService>().listenForParcelLocationUpdate(
          roomId: 'rider_tracking',
          onLocationUpdate: (data) async {
            updateMarkerPosition(
                currentRiderPosition: LatLng(
                    double.parse(data['lat'].toString()),
                    double.parse(data['lon'].toString())),
                degrees: double.parse(data['degrees'].toString()),
                context: context);
            checkProximityToLocations(
                LatLng(double.parse(data['lat'].toString()),
                    double.parse(data['lon'].toString())),
                context);
            if (data.containsKey('status')) {
              if (data['status'] != selectedDelivery!.status) {
                if (data['status'] == "delivered") {
                  Get.find<WalletController>().getWalletBalance();
                  Get.find<SettingsController>().getProfile();
                  Get.find<NotificationsController>().getNotifications();
                }
                await getDelivery();
                FlutterRingtonePlayer().playNotification();
                showRiderAndDeliveryStatusToast(
                    title: "Status change",
                    message:
                        "The current status of your delivery is: ${data['status']} ",
                    delivery: selectedDelivery!);
                fetchDeliveries();
              }
            }
          });
    } else {
      Get.find<SocketService>()
          .joinTrackingRoom(trackingId: trackingId, msg: "join_room");
      // Otherwise send location update
      Get.find<SocketService>().listenForParcelLocationUpdate(
          roomId: 'rider_tracking',
          onLocationUpdate: (data) async {
            updateMarkerPosition(
                currentRiderPosition: LatLng(
                    double.parse(data['lat'].toString()),
                    double.parse(data['lon'].toString())),
                degrees: double.parse(data['degrees'].toString()),
                context: context);
            checkProximityToLocations(
                LatLng(double.parse(data['lat'].toString()),
                    double.parse(data['lon'].toString())),
                context);
            if (data.containsKey('status')) {
              if (data['status'] != selectedDelivery!.status) {
                if (data['status'] == "delivered") {
                  Get.find<WalletController>().getWalletBalance();
                }
                await getDelivery();
                FlutterRingtonePlayer().playNotification();
                showRiderAndDeliveryStatusToast(
                    title: "Status change",
                    message:
                        "The current status of your delivery is: ${data['status']} ",
                    delivery: selectedDelivery!);
                fetchDeliveries();
              }
            }
          });
    }
  }

  void updateMarkerPosition(
      {required LatLng currentRiderPosition,
      required double degrees,
      required BuildContext context}) async {
    LatLng newPosition =
        LatLng(currentRiderPosition.latitude, currentRiderPosition.longitude);
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
    if (['accepted'].contains(selectedDelivery!.status)) {
      drawPolylineFromRiderToDestination(context,
          destinationPosition: LatLng(
              double.parse(selectedDelivery!.originLocation.latitude),
              double.parse(selectedDelivery!.originLocation.longitude)),
          currentRiderLocation: newPosition,
          riderDegrees: degrees);
    } else if (['picked'].contains(selectedDelivery!.status)) {
      drawPolylineFromRiderToDestination(context,
          destinationPosition: LatLng(
              double.parse(selectedDelivery!.destinationLocation.latitude),
              double.parse(selectedDelivery!.destinationLocation.longitude)),
          currentRiderLocation: newPosition,
          riderDegrees: degrees);
    } else {
      // Update marker and camera
      var markerId = const MarkerId("Rider");
      double rotation =
          calculateLocationDegrees(currentRiderPosition, newPosition);
      final marker = Marker(
        markerId: markerId,
        position: newPosition,
        icon: bikeMarkerIcon ?? BitmapDescriptor.defaultMarker,
        rotation: rotation,
        anchor: const Offset(0.5, 0.5),
      );

      markerSet.removeWhere((m) => m.markerId == markerId);
      markerSet.add(marker);

      if (newGoogleMapController != null) {
        newGoogleMapController!
            .animateCamera(CameraUpdate.newLatLng(newPosition));
      }

      currentRiderPosition = newPosition;
      update();
    }
  }

  LatLng getClosestPointOnPolyline(LatLng position) {
    double minDistance = double.infinity;
    LatLng closestPoint = position;

    for (LatLng point in pLineCoordinatedList) {
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

  void showDeliveryStatusDialog() {
    statusDialogIsOpened = true;
    Get.dialog(
      Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: GetBuilder<DeliveriesController>(
                builder: (deliveriesController) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customText(
                        'Rider is here!',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.sp, vertical: 10.sp),
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.sp, vertical: 10.sp),
                        width: 1.sw,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColors.greenColor.withOpacity(0.92)),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25.sp,
                            ),
                            const DottedLine(
                              dashLength: 3,
                              dashGapLength: 3,
                              lineThickness: 2,
                              dashColor: AppColors.whiteColor,
// lineLength: 150,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () async {
                                FlutterRingtonePlayer().stop();
                                statusDialogIsOpened = false;
                              },
                              title: "Ok",
                              backgroundColor: AppColors.greenColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onInit() {
    super.onInit();
    // deliveriesScrollController.addListener(_deliveriesScrollListener);
    // searchDeliveriesScrollController
    //     .addListener(_searchDeliveriesScrollListener);
    // fetchDeliveries();
    // getBikeIcon();
  }
}
