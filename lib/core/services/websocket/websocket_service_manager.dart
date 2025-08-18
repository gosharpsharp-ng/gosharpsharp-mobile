import 'dart:developer';

import 'package:gosharpsharp/core/services/delivery/delivery_notification.dart';

import '../../utils/exports.dart';

class DeliveryNotificationServiceManager extends GetxService {
  static DeliveryNotificationServiceManager get instance => Get.find();
  bool _isServicesInitialized = false;

  bool get isServicesInitialized => _isServicesInitialized;

  Future<void> initializeServices() async {
    if (_isServicesInitialized) {
      log('Services already initialized');
      return;
    }

    try {
      // Check and dispose existing services
      if (Get.isRegistered<SocketService>()) {
        await Get.delete<SocketService>();
      }

      if (Get.isRegistered<DeliveryNotificationService>()) {
        await Get.delete<DeliveryNotificationService>();
      }

      // Initialize services
      await Get.putAsync(() => SocketService().init());

      _isServicesInitialized = true;
      log('Services initialized successfully');
    } catch (e) {
      log('Error initializing services: $e');
      _isServicesInitialized = false;
      rethrow;
    }
  }

  Future<void> disposeServices() async {
    if (Get.isRegistered<SocketService>()) {
      final socketService = Get.find<SocketService>();
      socketService.socket.disconnect();
      await Get.delete<SocketService>();
    }

    _isServicesInitialized = false;
    log('Services disposed successfully');
  }
}
