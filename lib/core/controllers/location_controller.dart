import 'package:gosharpsharp/core/utils/exports.dart';

class LocationController extends GetxController {
  final RxString selectedLocation = 'Choose Location to continue'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedLocation();
  }

  void loadSavedLocation() {
    final storage = GetStorage();
    final savedLocation = storage.read('selected_location');
    if (savedLocation != null && savedLocation.isNotEmpty) {
      selectedLocation.value = savedLocation;
    }
  }

  Future<void> updateLocation(String location, {double? lat, double? lng}) async {
    final storage = GetStorage();
    await storage.write('selected_location', location);
    if (lat != null) {
      await storage.write('location_lat', lat.toString());
    }
    if (lng != null) {
      await storage.write('location_lng', lng.toString());
    }
    selectedLocation.value = location;
    update();
  }

  void clearLocation() {
    final storage = GetStorage();
    storage.remove('selected_location');
    storage.remove('location_lat');
    storage.remove('location_lng');
    selectedLocation.value = 'Choose Location to continue';
    update();
  }
}
