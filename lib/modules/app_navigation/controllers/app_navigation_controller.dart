import 'dart:developer';

import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/views/cart_screen.dart';
import 'package:gosharpsharp/modules/dashboard/views/landing_screen.dart';
import 'package:gosharpsharp/modules/orders/views/orders_home_screen.dart';
import 'package:gosharpsharp/modules/orders/views/orders_hub.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class AppNavigationController extends GetxController {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  socket_io.Socket? socket;
  bool showRestaurantView = false; // Toggle between landing and restaurant view

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  int currentScreenIndex = 0;
  changeScreenIndex(selectedIndex) {
    currentScreenIndex = selectedIndex;
    update();
  }

  // Toggle to show restaurant dashboard
  void toggleToRestaurantView() {
    showRestaurantView = !showRestaurantView;
    update();
  }

  // Get the appropriate home screen based on toggle state
  Widget get homeScreen => showRestaurantView
      ? const DashboardScreen()
      : const LandingScreen();

  List<Widget> get screens => [
    homeScreen,
    const OrdersHub(),
    const SettingsHomeScreen(),
  ];
  @override
  void onInit() {
    // Check if we have an initialIndex argument from navigation
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map && arguments['initialIndex'] != null) {
      final int initialIndex = arguments['initialIndex'];
      currentScreenIndex = initialIndex;
      selectedIndex.value = initialIndex;
      log('AppNavigationController initialized with index: $initialIndex');
    }

    // _handleLocationPermission();
    super.onInit();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showLocationPermissionDialog();
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast(isError: true, message: 'Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToast(
        isError: true,
        message:
            'Location permissions are permanently denied. Please grant permissions from app settings.',
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
