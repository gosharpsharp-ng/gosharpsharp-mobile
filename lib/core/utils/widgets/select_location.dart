import 'package:dio/dio.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

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
  LatLng initialPosition = const LatLng(9.0820, 8.6753); // Default: Abuja, Nigeria
  bool _isLoadingLocation = false;
  bool _isMapReady = false;
  // OverlayEntry? _overlayEntry;
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled, use default location
      // User can still search manually or tap on map
      if (mounted) {
        showToast(
          isError: false,
          message: "Location services disabled. You can search or tap on the map to select your location.",
        );
      }
      setState(() {
        initialPosition = const LatLng(9.0820, 8.6753); // Abuja, Nigeria
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          showToast(
            isError: false,
            message: "Location permission denied. You can search or tap on the map to select your location.",
          );
        }
        // Use default location if permission denied
        setState(() {
          initialPosition = const LatLng(9.0820, 8.6753); // Abuja, Nigeria
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showToast(
          isError: false,
          message: "Location permission denied permanently. You can search or tap on the map to select your location.",
        );
      }
      // Use default location if permission denied forever
      setState(() {
        initialPosition = const LatLng(9.0820, 8.6753); // Abuja, Nigeria
      });
      return;
    }

    try {
      // Try to get last known position first (instant)
      Position? lastPosition = await Geolocator.getLastKnownPosition();

      if (lastPosition != null && mounted) {
        setState(() {
          initialPosition = LatLng(lastPosition.latitude, lastPosition.longitude);
        });
      }

      // Use progressive accuracy: try medium first (faster), then high if needed
      Position? position;

      // Try medium accuracy first - usually sufficient and faster
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 8),
          ),
        );
      } catch (e) {
        debugPrint('Medium accuracy location timed out, trying low accuracy: $e');
        // Fall back to low accuracy if medium times out
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
              timeLimit: Duration(seconds: 5),
            ),
          );
        } catch (e) {
          debugPrint('Low accuracy also failed: $e');
        }
      }

      if (position != null && mounted) {
        setState(() {
          initialPosition = LatLng(position!.latitude, position.longitude);
        });
      }
    } catch (e) {
      debugPrint('Error in _determinePosition: $e');
      // Last known position should already be set if available
      // No toast needed here - map is already functional
    }
  }

  Future<void> _useCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToast(
        isError: true,
        message: "Location services are disabled. Please enable location in your device settings.",
      );
      // Optionally open app settings
      await Geolocator.openLocationSettings();
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast(
          isError: true,
          message: "Location permission is required to use your current location.",
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToast(
        isError: true,
        message: "Location permission denied permanently. Please enable it in app settings.",
      );
      // Optionally open app settings
      await Geolocator.openAppSettings();
      return;
    }

    try {
      // Show loading indicator
      setState(() {
        _isLoadingLocation = true;
      });

      Position? position;

      // Try medium accuracy first (faster)
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 8),
          ),
        );
      } catch (e) {
        debugPrint('Medium accuracy failed: $e');
        // Try low accuracy as fallback
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.low,
              timeLimit: Duration(seconds: 5),
            ),
          );
        } catch (e) {
          debugPrint('Low accuracy also failed: $e');
          // Try last known position as final fallback
          position = await Geolocator.getLastKnownPosition();
        }
      }

      if (position == null) {
        setState(() {
          _isLoadingLocation = false;
        });
        showToast(
          isError: true,
          message: "Could not get current location. Please search manually or tap on the map.",
        );
        return;
      }

      final currentLatLng = LatLng(position.latitude, position.longitude);

      // Update map position
      setState(() {
        initialPosition = currentLatLng;
        _markers = {
          Marker(
            markerId: MarkerId(currentLatLng.toString()),
            position: currentLatLng,
          ),
        };
        _isLoadingLocation = false;
      });

      // Animate camera to current location
      final controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLatLng, zoom: 16),
        ),
      );

      // Get formatted address
      await _showLocationDetails(currentLatLng);
    } catch (e) {
      debugPrint('Error getting current location: $e');
      setState(() {
        _isLoadingLocation = false;
      });
      showToast(
        isError: true,
        message: "Failed to get current location. Please try again or search manually.",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Use last known position first for faster initial load
    _initializeMapFast();
    _textEditingController.addListener(_onSearchTextChanged);
    // _textFieldFocusNode.addListener(_onTextFieldFocusChanged);
  }

  // Fast initialization using last known position
  Future<void> _initializeMapFast() async {
    try {
      // Try to get last known position immediately (very fast)
      Position? lastPosition = await Geolocator.getLastKnownPosition();

      if (lastPosition != null && mounted) {
        setState(() {
          initialPosition = LatLng(lastPosition.latitude, lastPosition.longitude);
          _isMapReady = true;
        });
      } else {
        // Use default position if no last known position
        setState(() {
          _isMapReady = true;
        });
      }
    } catch (e) {
      // Use default position on error
      setState(() {
        _isMapReady = true;
      });
    }

    // Then try to get accurate current position in background
    _determinePosition();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      liteModeEnabled: false,
                      compassEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        setState(() {
                          _isMapReady = true;
                        });
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
                              CameraPosition(target: latLng, zoom: 16)),
                        );

                        _showLocationDetails(latLng);
                      },
                      initialCameraPosition:
                          CameraPosition(target: initialPosition, zoom: 15),
                      markers: _markers),
                ),

                // Loading indicator while fetching location details
                if (_isLoadingLocation)
                  Container(
                    color: AppColors.blackColor.withValues(alpha: 0.3),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20.sp),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackColor.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.primaryColor,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 16.h),
                            customText(
                              "Loading location details...",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                color: Colors.grey.withValues(alpha: 0.5),
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
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Drag handle
                          Center(
                            child: Container(
                              width: 40.w,
                              height: 4.h,
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: AppColors.greyColor.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppColors.primaryColor,
                                size: 24.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: customText(
                                  "Selected Location",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          // Show complete location text without truncation
                          Container(
                            padding: EdgeInsets.all(12.sp),
                            decoration: BoxDecoration(
                              color: AppColors.greyColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: customText(
                              location!.formattedAddress!,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                              overflow: TextOverflow.visible,
                              maxLines: 10, // Allow multiple lines
                            ),
                          ),
                          SizedBox(height: 16.h),
                          CustomButton(
                            onPressed: () {
                              Navigator.pop(context, location);
                            },
                            backgroundColor: AppColors.primaryColor,
                            title: "Confirm Location",
                            fontColor: AppColors.whiteColor,
                            width: 1.sw,
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          );
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
    // Show loading indicator
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${Secret.apiKey}';

      final res = await Dio().get(url);
      final decodedData = json.decode(json.encode(res.data));

      if (res.statusCode == 200 && decodedData['results'] != null && mounted) {
        setState(() {
          location = ItemLocation(
              formattedAddress: decodedData['results'][0]['formatted_address'],
              latitude: latLng.latitude,
              longitude: latLng.longitude);
          _isLoadingLocation = false;
        });
      } else {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      debugPrint('Error getting location details: $e');
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
        showToast(
          message: 'Failed to get location details. Please try again.',
          isError: true,
        );
      }
    }
  }
}
