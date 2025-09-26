import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:math';
import '../../models/location_model.dart';
import '../../utils/helpers.dart';
import '../../utils/exports.dart';
import '../../utils/widgets/select_location.dart' as widgets;

// Service area model for geofencing
class ServiceArea {
  final String name;
  final double centerLat;
  final double centerLng;
  final double radiusKm;

  ServiceArea({
    required this.name,
    required this.centerLat,
    required this.centerLng,
    required this.radiusKm,
  });
}

class LocationService extends GetxService {
  static LocationService get to {
    try {
      return Get.find<LocationService>();
    } catch (e) {
      // If service is not found, create and register it
      return Get.put<LocationService>(LocationService(), permanent: true);
    }
  }

  // Current location data
  final Rx<ItemLocation?> _currentLocation = Rx<ItemLocation?>(null);
  final RxBool _isLocationLoading = false.obs;
  final RxBool _hasLocationPermission = false.obs;
  final RxString _locationError = ''.obs;

  // Getters - with render-safe access
  ItemLocation? get currentLocation {
    try {
      return _currentLocation.value;
    } catch (e) {
      return _defaultLocation;
    }
  }

  bool get isLocationLoading {
    try {
      return _isLocationLoading.value;
    } catch (e) {
      return false;
    }
  }

  bool get hasLocationPermission {
    try {
      return _hasLocationPermission.value;
    } catch (e) {
      return false;
    }
  }

  String get locationError {
    try {
      return _locationError.value;
    } catch (e) {
      return '';
    }
  }

  // Default fallback location (Jos, Nigeria)
  final ItemLocation _defaultLocation = ItemLocation(
    formattedAddress: "Jos, Nigeria",
    latitude: 9.8965,
    longitude: 8.8583,
  );

  // Supported service areas - Define your operating cities/regions
  final List<ServiceArea> _supportedAreas = [
    ServiceArea(
      name: "Jos, Nigeria",
      centerLat: 9.8965,
      centerLng: 8.8583,
      radiusKm: 50.0, // 50km radius around Jos
    ),
    ServiceArea(
      name: "Abuja, Nigeria",
      centerLat: 9.0765,
      centerLng: 7.3986,
      radiusKm: 60.0, // 60km radius around Abuja
    ),
    // Add more cities as you expand service
  ];

  // Selected delivery location (different from current GPS location)
  final Rx<ItemLocation?> _selectedDeliveryLocation = Rx<ItemLocation?>(null);

  @override
  void onInit() {
    super.onInit();
    // Set default location immediately to avoid null states
    _setDefaultLocation();
    // Do NOT automatically initialize location - only when explicitly requested
  }

  /// Initialize location service - tries to get current location silently
  Future<void> _initializeLocation() async {
    try {
      // Initialize silently without any user prompts or toasts
      await getCurrentLocation(showToasts: false);
    } catch (e) {
      // Keep default location if initialization fails - no user notification
      // Silently using default location
    }
  }

  /// Get current user location with proper permission handling
  Future<ItemLocation?> getCurrentLocation({bool showToasts = false}) async {
    try {
      _isLocationLoading.value = true;
      _locationError.value = '';

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationError.value = 'Location services are disabled';
        if (showToasts) {
          showToast(
            message: 'Please enable location services in your device settings',
            isError: true,
          );
        }
        return _setDefaultLocation();
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationError.value = 'Location permissions denied';
          if (showToasts) {
            showToast(
              message: 'Location permission is required to find nearby restaurants',
              isError: true,
            );
          }
          return _setDefaultLocation();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _locationError.value = 'Location permissions permanently denied';
        if (showToasts) {
          showToast(
            message: 'Please enable location permission from Settings > Apps > GoSharpSharp > Permissions',
            isError: true,
          );
        }
        return _setDefaultLocation();
      }

      _hasLocationPermission.value = true;

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      // Get address from coordinates
      String address = await _getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Create location object
      final location = ItemLocation(
        formattedAddress: address,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      _currentLocation.value = location;

      if (showToasts) {
        showToast(message: 'Location updated successfully', isError: false);
      }

      return location;

    } catch (e) {
      _locationError.value = 'Failed to get location: $e';
      if (showToasts) {
        showToast(
          message: 'Unable to get your location. Using default location.',
          isError: true,
        );
      }
      return _setDefaultLocation();
    } finally {
      _isLocationLoading.value = false;
    }
  }

  /// Get formatted address from latitude and longitude using Google Maps API
  Future<String> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      // Use the same approach as in select_location.dart
      final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${Secret.apiKey}';

      final res = await Dio().get(url);
      final decodedData = json.decode(json.encode(res.data));

      if (res.statusCode == 200 &&
          decodedData['results'] != null &&
          decodedData['results'].isNotEmpty) {

        // Get the formatted address
        String formattedAddress = decodedData['results'][0]['formatted_address'];

        // Try to extract a shorter, more readable address
        final addressComponents = decodedData['results'][0]['address_components'] as List?;
        if (addressComponents != null && addressComponents.isNotEmpty) {
          List<String> addressParts = [];

          // Look for locality, administrative_area_level_2, administrative_area_level_1
          for (var component in addressComponents) {
            final types = component['types'] as List?;
            if (types != null) {
              if (types.contains('locality') ||
                  types.contains('administrative_area_level_2') ||
                  types.contains('sublocality_level_1')) {
                addressParts.add(component['long_name']);
                if (addressParts.length >= 2) break; // Limit to 2 parts for readability
              }
            }
          }

          if (addressParts.isNotEmpty) {
            return addressParts.join(', ');
          }
        }

        return formattedAddress;
      }
    } catch (e) {
      print('Error getting address from Google Maps API: $e');
    }

    return 'Current Location';
  }

  /// Set default location as fallback
  ItemLocation _setDefaultLocation() {
    _currentLocation.value = _defaultLocation;
    return _defaultLocation;
  }

  /// Manually refresh location
  Future<void> refreshLocation() async {
    await getCurrentLocation(showToasts: true);
  }

  /// Get coordinates for API calls
  Map<String, double> getCoordinatesForAPI() {
    try {
      final location = _currentLocation.value ?? _defaultLocation;
      return {
        'latitude': location.latitude,
        'longitude': location.longitude,
      };
    } catch (e) {
      return {
        'latitude': _defaultLocation.latitude,
        'longitude': _defaultLocation.longitude,
      };
    }
  }

  /// Get display address for UI
  String getDisplayAddress() {
    try {
      return _currentLocation.value?.formattedAddress ?? _defaultLocation.formattedAddress!;
    } catch (e) {
      return _defaultLocation.formattedAddress!;
    }
  }

  /// Open location selection screen
  Future<ItemLocation?> openLocationPicker() async {
    // This will use the existing SelectLocation widget
    final result = await Get.to(() => widgets.SelectLocation());
    if (result != null && result is ItemLocation) {
      _currentLocation.value = result;
      return result;
    }
    return null;
  }

  /// Check if we have a valid location (not default)
  bool hasValidLocation() {
    try {
      final current = _currentLocation.value;
      if (current == null) return false;

      // Check if it's not the default location
      return current.latitude != _defaultLocation.latitude ||
             current.longitude != _defaultLocation.longitude;
    } catch (e) {
      return false;
    }
  }

  /// Reset to default location
  void resetToDefault() {
    try {
      _setDefaultLocation();
    } catch (e) {
      // Silently fail if reset fails
    }
  }

  /// Calculate distance between two points in kilometers
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  /// Check if a location is within any of our service areas
  bool isLocationInServiceArea(double latitude, double longitude) {
    for (ServiceArea area in _supportedAreas) {
      double distance = _calculateDistance(
        latitude,
        longitude,
        area.centerLat,
        area.centerLng
      );
      if (distance <= area.radiusKm) {
        return true;
      }
    }
    return false;
  }

  /// Check if current GPS location is in service area
  bool isCurrentLocationInServiceArea() {
    try {
      if (_currentLocation.value == null) return false;
      return isLocationInServiceArea(
        _currentLocation.value!.latitude,
        _currentLocation.value!.longitude,
      );
    } catch (e) {
      return false;
    }
  }

  /// Set delivery location (for when user picks an address manually)
  void setDeliveryLocation(ItemLocation location) {
    try {
      _selectedDeliveryLocation.value = location;
    } catch (e) {
      // Silently fail if reactive assignment fails
    }
  }

  /// Get the location to use for restaurant fetching
  /// Priority: Selected delivery location > Current GPS location > Default
  ItemLocation getLocationForRestaurants() {
    try {
      if (_selectedDeliveryLocation.value != null) {
        return _selectedDeliveryLocation.value!;
      }
      return _currentLocation.value ?? _defaultLocation;
    } catch (e) {
      return _defaultLocation;
    }
  }

  /// Get coordinates for restaurant API (respects delivery location)
  Map<String, double> getCoordinatesForRestaurants() {
    try {
      final location = getLocationForRestaurants();
      return {
        'latitude': location.latitude,
        'longitude': location.longitude,
      };
    } catch (e) {
      return {
        'latitude': _defaultLocation.latitude,
        'longitude': _defaultLocation.longitude,
      };
    }
  }

  /// Check if we should show restaurants (always true with default location)
  bool shouldShowRestaurants() {
    try {
      // If user has selected a delivery location, check if it's in service area
      if (_selectedDeliveryLocation.value != null) {
        return isLocationInServiceArea(
          _selectedDeliveryLocation.value!.latitude,
          _selectedDeliveryLocation.value!.longitude,
        );
      }

      // Always show restaurants using default location (Jos, Nigeria)
      return true;
    } catch (e) {
      // If any error occurs during check, default to true for default location
      return true;
    }
  }

  /// Get display address for UI (prioritizes delivery location)
  String getDisplayAddressForRestaurants() {
    try {
      if (_selectedDeliveryLocation.value != null) {
        return _selectedDeliveryLocation.value!.formattedAddress ?? 'Selected Location';
      }
      return getDisplayAddress();
    } catch (e) {
      return _defaultLocation.formattedAddress!;
    }
  }

  /// Clear selected delivery location (go back to using GPS)
  void clearDeliveryLocation() {
    try {
      _selectedDeliveryLocation.value = null;
    } catch (e) {
      // Silently fail if reactive assignment fails
    }
  }

  /// Open location picker for delivery address
  Future<ItemLocation?> selectDeliveryAddress() async {
    final result = await Get.to(() => widgets.SelectLocation());
    if (result != null && result is ItemLocation) {
      setDeliveryLocation(result);
      return result;
    }
    return null;
  }
}