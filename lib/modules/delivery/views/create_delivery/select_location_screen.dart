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
  LatLng initialPosition = const LatLng(9.0820, 8.6753); // Default: Abuja, Nigeria
  bool _isLoadingLocation = false;
  bool _isMapReady = false;
  bool _isGettingCurrentLocation = false;
  bool _isSearching = false;

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are disabled, use default location
      if (mounted) {
        showToast(
          isError: false,
          message: "Location services disabled. You can search or tap on the map to select your location.",
        );
        setState(() {
          initialPosition = const LatLng(9.0820, 8.6753); // Abuja, Nigeria
        });
      }
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
          setState(() {
            initialPosition = const LatLng(9.0820, 8.6753); // Abuja, Nigeria
          });
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showToast(
          isError: false,
          message: "Location permission denied permanently. You can search or tap on the map to select your location.",
        );
        setState(() {
          initialPosition = const LatLng(9.0820, 8.6753); // Abuja, Nigeria
        });
      }
      return;
    }

    try {
      // Try to get last known position first (faster)
      Position? lastPosition = await Geolocator.getLastKnownPosition();

      if (lastPosition != null && mounted) {
        setState(() {
          initialPosition = LatLng(lastPosition.latitude, lastPosition.longitude);
        });
      }

      // Then get current position with timeout (more accurate)
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10), // 10 second timeout
        ),
      );

      if (mounted) {
        setState(() {
          initialPosition = LatLng(position.latitude, position.longitude);
        });
      }
    } catch (e) {
      // If getting position fails, try last known position or use default
      try {
        Position? lastPosition = await Geolocator.getLastKnownPosition();
        if (lastPosition != null && mounted) {
          setState(() {
            initialPosition = LatLng(lastPosition.latitude, lastPosition.longitude);
          });
        } else {
          // Use default location (Abuja, Nigeria)
          if (mounted) {
            showToast(
              isError: false,
              message: "Could not get current location. You can search or tap on the map to select your location.",
            );
            setState(() {
              initialPosition = const LatLng(9.0820, 8.6753);
            });
          }
        }
      } catch (e) {
        // Final fallback to default location
        if (mounted) {
          showToast(
            isError: false,
            message: "Could not get current location. You can search or tap on the map to select your location.",
          );
          setState(() {
            initialPosition = const LatLng(9.0820, 8.6753);
          });
        }
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    if (_isGettingCurrentLocation) return; // Prevent multiple calls

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

    // Show loading state
    setState(() {
      _isGettingCurrentLocation = true;
    });

    try {
      // Get current position with timeout
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

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
      showToast(
        isError: true,
        message: "Failed to get current location. Please try again or search manually.",
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGettingCurrentLocation = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Use last known position first for faster initial load
    _initializeMapFast();
    _textEditingController.addListener(_onSearchTextChanged);
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
    _textEditingController.removeListener(_onSearchTextChanged);
    _textEditingController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Show loading placeholder while map is initializing
          if (!_isMapReady)
            Container(
              color: AppColors.backgroundColor,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              ),
            ),
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
                    CameraPosition(target: latLng, zoom: 16),
                  ),
                );

                _showLocationDetails(latLng);
              },
              initialCameraPosition: CameraPosition(target: initialPosition, zoom: 15),
              markers: _markers,
            ),
          ),

          // Loading indicator while fetching location details
          if (_isLoadingLocation)
            Container(
              color: AppColors.blackColor.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withOpacity(0.1),
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

          SafeArea(
            child: Column(
              children: [
                // Search bar with back button
                Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(10.sp),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColors.blackColor,
                            size: 22.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // Search field
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          focusNode: _textFieldFocusNode,
                          onTapOutside: ((event) {
                            //FocusScope.of(context).unfocus();
                          }),
                          decoration: InputDecoration(
                            fillColor: AppColors.whiteColor,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                            prefixIcon: Icon(
                              Icons.search,
                              color: _textFieldFocusNode.hasFocus
                                  ? AppColors.primaryColor
                                  : AppColors.greyColor,
                            ),
                            suffixIcon: _textEditingController.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _textEditingController.clear();
                                      setState(() {
                                        _suggestedLocations = [];
                                      });
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: AppColors.greyColor,
                                      size: 20.sp,
                                    ),
                                  )
                                : null,
                            hintText: "Search for an address",
                            hintStyle: TextStyle(
                              color: AppColors.greyColor,
                              fontSize: 14.sp,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.r),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.r),
                              borderSide: BorderSide(color: AppColors.primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Use Current Location button with loading state
                GestureDetector(
                  onTap: _isGettingCurrentLocation ? null : _useCurrentLocation,
                  child: Container(
                    width: 1.sw * 0.75,
                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: _isGettingCurrentLocation
                          ? AppColors.primaryColor.withOpacity(0.7)
                          : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isGettingCurrentLocation) ...[
                          SizedBox(
                            width: 18.sp,
                            height: 18.sp,
                            child: CircularProgressIndicator(
                              color: AppColors.whiteColor,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          customText(
                            "Getting Location...",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ] else ...[
                          Icon(
                            Icons.my_location,
                            color: AppColors.whiteColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          customText(
                            "Use Current Location",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.sp),
                // Search suggestions with loading indicator
                if (_textFieldFocusNode.hasFocus && (_isSearching || _suggestedLocations.isNotEmpty || _textEditingController.text.isNotEmpty))
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 0.4.sh, // Max 40% of screen height
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isSearching
                        ? Padding(
                            padding: EdgeInsets.all(20.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20.sp,
                                  height: 20.sp,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                customText(
                                  "Searching...",
                                  fontSize: 14.sp,
                                  color: AppColors.greyColor,
                                ),
                              ],
                            ),
                          )
                        : _suggestedLocations.isEmpty && _textEditingController.text.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.all(20.sp),
                                child: customText(
                                  "No results found. Try a different search.",
                                  fontSize: 14.sp,
                                  color: AppColors.greyColor,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                itemCount: _suggestedLocations.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  color: AppColors.greyColor.withOpacity(0.2),
                                ),
                                itemBuilder: (context, index) {
                                  final prediction = _suggestedLocations[index];

                                  return ListTile(
                                    dense: true,
                                    leading: Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.primaryColor,
                                      size: 22.sp,
                                    ),
                                    title: Text(
                                      prediction.structuredFormatting?.mainText ?? '',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      prediction.description ?? '',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.greyColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      _textEditingController.text = prediction.description ?? '';
                                      _textFieldFocusNode.unfocus();
                                      if (prediction.placeId != null) {
                                        _geocodePlace(prediction.placeId!);
                                      }
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
                    color: AppColors.blackColor.withOpacity(0.1),
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
                          color: AppColors.greyColor.withOpacity(0.3),
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
                        color: AppColors.greyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: customText(
                        location!.formattedAddress ?? '${location!.latitude.toStringAsFixed(6)}, ${location!.longitude.toStringAsFixed(6)}',
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
    // Add null-safety check for disposed controller
    if (!mounted) {
      return;
    }

    try {
      final input = _textEditingController.text;
      if (input.isEmpty) {
        if (mounted) {
          setState(() {
            _suggestedLocations = [];
            _isSearching = false;
          });
        }
        return;
      }

      // Show searching state
      if (mounted) {
        setState(() {
          _isSearching = true;
        });
      }

      final predictions = await _getPredictions(input);
      if (mounted) {
        setState(() {
          _suggestedLocations = predictions;
          _isSearching = false;
        });
      }
    } catch (e) {
      debugPrint('Error getting search predictions: $e');
      if (mounted) {
        setState(() {
          _suggestedLocations = [];
          _isSearching = false;
        });
      }
    }
  }

  Future<List<Prediction>> _getPredictions(String input) async {
    final places = GoogleMapsPlaces(apiKey: Secret.apiKey);
    final response = await places.autocomplete(input);
    return response.predictions;
  }

  Future<void> _geocodePlace(String placeId) async {
    // Show loading immediately when user selects a search suggestion
    setState(() {
      _isLoadingLocation = true;
    });

    try {
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
        // _showLocationDetails will handle setting _isLoadingLocation to false
        await _showLocationDetails(LatLng(location.lat, location.lng));
      } else {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      debugPrint('Error geocoding place: $e');
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
        showToast(
          message: 'Failed to get location. Please try again.',
          isError: true,
        );
      }
    }
  }

  Future<void> _showLocationDetails(LatLng latLng) async {
    // Show loading indicator (if not already showing)
    if (!_isLoadingLocation) {
      setState(() {
        _isLoadingLocation = true;
      });
    }

    try {
      final url =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${Secret.apiKey}';

      debugPrint('Geocoding URL: $url');
      final res = await Dio().get(url);
      debugPrint('Geocoding response status: ${res.statusCode}');
      debugPrint('Geocoding response data: ${res.data}');

      final decodedData = json.decode(json.encode(res.data));

      if (res.statusCode == 200 && decodedData['results'] != null && decodedData['results'].isNotEmpty && mounted) {
        setState(() {
          location = ItemLocation(
              formattedAddress: decodedData['results'][0]['formatted_address'],
              latitude: latLng.latitude,
              longitude: latLng.longitude);
          _isLoadingLocation = false;
        });
      } else {
        debugPrint('Geocoding failed: status=${res.statusCode}, results=${decodedData['results']?.length ?? 0}');
        // Create location with coordinates even if geocoding fails
        if (mounted) {
          setState(() {
            location = ItemLocation(
                latitude: latLng.latitude,
                longitude: latLng.longitude);
            _isLoadingLocation = false;
          });
          showToast(
            message: 'Location selected with coordinates. Address details unavailable.',
            isError: false,
          );
        }
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
