import 'dart:developer';

import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/views/cart_screen.dart';
import 'package:gosharpsharp/modules/dashboard/views/landing_screen.dart';
import 'package:gosharpsharp/modules/orders/views/orders_home_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

class AppNavigationController extends GetxController {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  socket_io.Socket? socket;
  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  int currentScreenIndex = 0;
  changeScreenIndex(selectedIndex) {
    currentScreenIndex = selectedIndex;
    update();
  }

  List<Widget> screens = [
    // const LandingScreen(),
    const DashboardScreen(),
    const CartScreen(),
    const OrdersHomeScreen(),
    // const WalletHomeScreen(),
    const SettingsHomeScreen(),
  ];
  @override
  void onInit() {
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
