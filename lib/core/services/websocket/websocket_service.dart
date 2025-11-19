import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../utils/exports.dart';

class SocketService extends GetxService {
  static SocketService get instance => Get.find();

  late IO.Socket socket;
  final isConnected = false.obs;
  int? _currentUserId;

  Future<SocketService> init() async {
    _initializeSocket();
    _setupSocketListeners();
    return this;
  }

  void _initializeSocket() {
    socket = IO.io(
        'https://socket.gosharpsharp.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(3000)
            .build());
    socket.connect();
  }

  void _setupSocketListeners() {
    socket
      ..onConnect((_) {
        log('🟢 Socket Connected to https://socket.gosharpsharp.com');
        isConnected.value = true;
        // Rejoin user room if userId was set
        if (_currentUserId != null) {
          joinUserRoom(_currentUserId!);
        }
        joinRidersTrackingRoom();
      })
      ..onDisconnect((_) {
        log('🔴 Socket Disconnected');
        isConnected.value = false;
      })
      ..onReconnect((_) {
        log('🟡 Socket Reconnected');
        isConnected.value = true;
        // Rejoin user room on reconnection
        if (_currentUserId != null) {
          joinUserRoom(_currentUserId!);
        }
        joinRidersTrackingRoom();
      })
      ..onError((error) => log('❌ Socket Error: $error'))
      ..onConnectError((error) => log('❌ Socket Connect Error: $error'));
  }

  // Join customer room with userId
  void joinUserRoom(int userId) {
    if (isConnected.value) {
      _currentUserId = userId;
      socket.emit('customer:join', {'userId': userId});
      log('👤 Joined customer room with userId: $userId');
    } else {
      log('⚠️ Cannot join customer room - socket not connected');
    }
  }

  // Leave customer room
  void leaveUserRoom() {
    if (_currentUserId != null && isConnected.value) {
      // No specific leave event for customer room
      log('👋 Left customer room for userId: $_currentUserId');
      _currentUserId = null;
    }
  }

  // ==================== FOOD ORDER TRACKING ====================

  /// Join a food order tracking room
  /// Emits to: "order:join" with payload { "orderNumber": "ORD-UFBZV5YU" }
  void joinFoodOrderTracking(String orderNumber) {
    if (isConnected.value) {
      socket.emit('order:join', {'orderNumber': orderNumber});
      log('🍔 Joined food order tracking for: $orderNumber');
    } else {
      log('⚠️ Cannot join food order tracking - socket not connected');
    }
  }

  /// Listen for food order status updates
  /// Event: "order:status-update"
  /// Data: {orderId, orderNumber, status, previousStatus, userId, restaurantId, total, currency, items, packages, updatedAt}
  void listenForOrderStatusUpdate(
      Function(Map<String, dynamic>) onOrderUpdate) {
    socket.on('order:status-update', (data) {
      log('📦 Order status update received: ${data.toString()}');
      if (data is Map<String, dynamic>) {
        onOrderUpdate(data);
      }
    });
  }

  /// Stop listening for order status updates
  void stopListeningForOrderStatusUpdate() {
    socket.off('order:status-update');
    log('🔇 Stopped listening for order status updates');
  }

  /// Leave food order tracking room
  void leaveFoodOrderTracking(String orderNumber) {
    if (isConnected.value) {
      log('👋 Stopped tracking food order: $orderNumber');
    }
  }

  // ==================== DELIVERY LOCATION TRACKING ====================
  // Used for both food order deliveries and parcel deliveries

  /// Join a delivery tracking room (for both food orders and parcels)
  /// Emits to: "delivery:track" with payload { "trackingId": "Order Number or Tracking ID" }
  /// For food orders: trackingId = orderNumber (e.g., "ORD-UFBZV5YU")
  /// For parcels: trackingId = deliveryTrackingId (e.g., "DLV-20251030-1NZZKL")
  void joinDeliveryTracking(String trackingId) {
    if (isConnected.value) {
      socket.emit('delivery:track', {'trackingId': trackingId});
      log('🚚 Joined delivery tracking for: $trackingId');
    } else {
      log('⚠️ Cannot join delivery tracking - socket not connected');
    }
  }

  /// Listen for delivery location updates (rider location)
  /// Event: "delivery:location-update"
  /// Data: {trackingId, location: {latitude, longitude, degrees}}
  void listenForDeliveryLocationUpdate(
      Function(Map<String, dynamic>) onLocationUpdate) {
    socket.on('delivery:location-update', (data) {
      log('📍 Delivery location update received: ${data.toString()}');
      if (data is Map<String, dynamic>) {
        onLocationUpdate(data);
      }
    });
  }

  /// Stop listening for delivery location updates
  void stopListeningForDeliveryLocationUpdate() {
    socket.off('delivery:location-update');
    log('🔇 Stopped listening for delivery location updates');
  }

  /// Leave delivery tracking room
  void leaveDeliveryTracking(String trackingId) {
    if (isConnected.value) {
      log('👋 Stopped tracking delivery: $trackingId');
    }
  }

  // DEPRECATED methods - kept for backward compatibility
  @Deprecated('Use joinDeliveryTracking instead')
  void joinParcelDeliveryTracking(String trackingId) =>
      joinDeliveryTracking(trackingId);

  @Deprecated('Use listenForDeliveryLocationUpdate instead')
  void listenForDeliveryStatusUpdate(
          Function(Map<String, dynamic>) onDeliveryUpdate) =>
      listenForDeliveryLocationUpdate(onDeliveryUpdate);

  @Deprecated('Use stopListeningForDeliveryLocationUpdate instead')
  void stopListeningForDeliveryStatusUpdate() =>
      stopListeningForDeliveryLocationUpdate();

  @Deprecated('Use leaveDeliveryTracking instead')
  void leaveParcelDeliveryTracking(String trackingId) =>
      leaveDeliveryTracking(trackingId);

  // ==================== LEGACY METHODS (kept for backward compatibility) ====================

  void listenForParcelLocationUpdate(
      {required String roomId, required Function(dynamic) onLocationUpdate}) {
    socket.on(roomId, onLocationUpdate);
  }

  void joinTrackingRoom(
      {required String trackingId, required String msg}) async {
    if (isConnected.value) {
      socket.emit(msg, trackingId);
    }
  }

  void joinRidersTrackingRoom() async {
    if (isConnected.value) {
      socket.emit("get_riders", "riders");
    }
  }

  void listenForAvailableRiders({required Function(dynamic) onRiderOnline}) {
    socket.on("riders_list", onRiderOnline);
  }

  void leaveTrackingRoom(
      {required String trackingId, required String msg}) async {
    if (isConnected.value) {
      socket.emit(msg, trackingId);
    }
  }

  // ==================== CLEANUP ====================

  @override
  void onClose() {
    // Clean up user room
    leaveUserRoom();

    // Stop all listeners
    stopListeningForOrderStatusUpdate();
    stopListeningForDeliveryLocationUpdate();

    // Dispose socket
    socket.dispose();
    super.onClose();
  }
}
