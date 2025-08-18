import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:dio/dio.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({
    super.key,
  });

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? selectedLocation;
  List<Prediction> _suggestedLocations = [];
  Set<Marker> _markers = {};
  ItemLocation? location;
  LatLng? initialPosition;
  // OverlayEntry? _overlayEntry;
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.requestPermission();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          showToast(
              isError: true,
              message:
                  "Your location is needed, kindly enable location from Settings.");
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showToast(
            isError: true,
            message:
                "Your location is needed, kindly enable location from Settings.");
      }
    }
    final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Update every 100 meters
    ));

    initialPosition = LatLng(position.latitude, position.longitude);
    setState(() {});
  }

  Future<void> _useCurrentLocation() async {
    await _determinePosition(); // Get current position

    if (initialPosition != null) {
      // Call _showLocationDetails to get the formatted address
      _showLocationDetails(initialPosition!);
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _textEditingController.addListener(_onSearchTextChanged);
    // _textFieldFocusNode.addListener(_onTextFieldFocusChanged);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return initialPosition != null
        ? Scaffold(
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: GoogleMap(
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      onCameraMoveStarted: () {
                        setState(() {
                          location = null;
                        });
                      },
                      onTap: (LatLng latLng) async {
                        // _removeOverlay();
                        _textEditingController.clear();
                        _textFieldFocusNode.unfocus();
                        setState(() {
                          _markers = {
                            Marker(
                              markerId: MarkerId(latLng.toString()),
                              position: latLng,
                            ),
                          };
                        });
                        final controller = await _controller.future;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                              CameraPosition(target: latLng, zoom: 14)),
                        );

                        _showLocationDetails(latLng);
                      },
                      initialCameraPosition:
                          CameraPosition(target: initialPosition!, zoom: 14),
                      markers: _markers),
                ),
                // if (_suggestedLocations.isNotEmpty) ...[
                //   const SizedBox(height: 8),
                //   _buildSuggestionsOverlay(),
                // ],

                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _textEditingController,
                          focusNode: _textFieldFocusNode,
                          onTapOutside: ((event) {
                            //FocusScope.of(context).unfocus();
                          }),
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            prefixIcon: Icon(
                              Icons.search,
                              color: _textFieldFocusNode.hasFocus
                                  ? AppColors.primaryColor
                                  : null,
                            ),
                            hintText: "Enter your address",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                          ),
                        ),
                      ),
                      CustomButton(
                        onPressed: () {
                          _useCurrentLocation();
                        },
                        title: "Use Current Location",
                        backgroundColor: AppColors.primaryColor,
                        fontColor: AppColors.whiteColor,
                        width: 1.sw * 0.75,
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      if (_textFieldFocusNode.hasFocus)
                        Container(
                          //  margin: const EdgeInsets.only(top: 55),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _suggestedLocations.length,
                            itemBuilder: (context, index) {
                              final prediction = _suggestedLocations[index];

                              return ListTile(
                                dense: true,
                                title: Text(
                                  prediction.structuredFormatting!.mainText,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  prediction.description!,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                onTap: () {
                                  //   _removeOverlay();
                                  //log(prediction.toString());
                                  _textEditingController.text =
                                      prediction.description!;
                                  _textFieldFocusNode.unfocus();
                                  _geocodePlace(prediction.placeId!);
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            bottomSheet: location != null
                ? Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customText(
                          location!.formattedAddress!,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          onPressed: () {
                            Get.back(result: location);
                          },
                          backgroundColor: AppColors.primaryColor,
                          title: "Confirm",
                          fontColor: AppColors.whiteColor,
                          width: 1.sw * 0.75,
                        ),
                      ],
                    ),
                  )
                : null)
        : const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()));
  }

  void _onSearchTextChanged() async {
    final input = _textEditingController.text;
    if (input.isEmpty) {
      return;
    }

    final predictions = await _getPredictions(input);
    setState(() {
      _suggestedLocations = predictions;
    });
  }

  Future<List<Prediction>> _getPredictions(String input) async {
    final places = GoogleMapsPlaces(apiKey: Secret.apiKey);
    final response = await places.autocomplete(input);
    return response.predictions;
  }

  Future<void> _geocodePlace(String placeId) async {
    final places = GoogleMapsPlaces(apiKey: Secret.apiKey);
    final response = await places.getDetailsByPlaceId(placeId);
    final location = response.result.geometry?.location;
    if (location != null) {
      setState(() {
        _markers = {
          Marker(
            markerId: MarkerId(LatLng(location.lat, location.lng).toString()),
            position: LatLng(location.lat, location.lng),
          ),
        };
      });
      final controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(location.lat, location.lng), zoom: 16),
        ),
      );

      setState(() {
        selectedLocation = LatLng(location.lat, location.lng);
      });
      _showLocationDetails(LatLng(location.lat, location.lng));
    }
  }

  Future<void> _showLocationDetails(LatLng latLng) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${Secret.apiKey}';

    final res = await Dio().get(url);
    final decodedData = json.decode(json.encode(res.data));

    if (res.statusCode == 200 && decodedData['results'] != null) {
      setState(() {
        location = ItemLocation(
            formattedAddress: decodedData['results'][0]['formatted_address'],
            latitude: latLng.latitude,
            longitude: latLng.longitude);
      });
    }
  }
}
