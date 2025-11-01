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
        'http://socket.gosharpsharp.com/',
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
        log('🟢 Socket Connected to http://socket.gosharpsharp.com/');
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
  /// Emits to: "order:track" with payload { "orderNumber": "ORD-UFBZV5YU" }
  void joinFoodOrderTracking(String orderNumber) {
    if (isConnected.value) {
      socket.emit('order:track', {'orderNumber': orderNumber});
      log('🍔 Joined food order tracking for: $orderNumber');
    } else {
      log('⚠️ Cannot join food order tracking - socket not connected');
    }
  }

  /// Listen for food order status updates
  /// Event: "order:status-update"
  /// Data: {orderId, orderNumber, status, previousStatus, userId, restaurantId, total, currency, items, packages, updatedAt}
  void listenForOrderStatusUpdate(Function(Map<String, dynamic>) onOrderUpdate) {
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
      // Emit to order:track to leave (if needed by backend)
      log('👋 Stopped tracking food order: $orderNumber');
    }
  }

  // ==================== PARCEL DELIVERY TRACKING ====================

  /// Join a parcel delivery tracking room
  /// Emits to: "delivery:track" with payload { "trackingId": "DLV-20251030-1NZZKL" }
  void joinParcelDeliveryTracking(String trackingId) {
    if (isConnected.value) {
      socket.emit('delivery:track', {'trackingId': trackingId});
      log('📦 Joined parcel delivery tracking for: $trackingId');
    } else {
      log('⚠️ Cannot join parcel delivery tracking - socket not connected');
    }
  }

  /// Listen for parcel delivery status updates
  /// Event: "delivery:status-update"
  /// Data: {trackingId, status, lat, lon, degrees, riderId, ...}
  void listenForDeliveryStatusUpdate(Function(Map<String, dynamic>) onDeliveryUpdate) {
    socket.on('delivery:status-update', (data) {
      log('🚚 Delivery status update received: ${data.toString()}');
      if (data is Map<String, dynamic>) {
        onDeliveryUpdate(data);
      }
    });
  }

  /// Stop listening for delivery status updates
  void stopListeningForDeliveryStatusUpdate() {
    socket.off('delivery:status-update');
    log('🔇 Stopped listening for delivery status updates');
  }

  /// Leave parcel delivery tracking room
  void leaveParcelDeliveryTracking(String trackingId) {
    if (isConnected.value) {
      // Emit to delivery:track to leave (if needed by backend)
      log('👋 Stopped tracking parcel delivery: $trackingId');
    }
  }

  /// DEPRECATED: Use listenForDeliveryStatusUpdate instead
  /// Listen for parcel delivery tracking updates
  /// Event: "delivery:track"
  @Deprecated('Use listenForDeliveryStatusUpdate instead')
  void listenForDeliveryTracking(Function(Map<String, dynamic>) onDeliveryUpdate) {
    socket.on('delivery:track', (data) {
      log('🚚 Delivery tracking update received: ${data.toString()}');
      if (data is Map<String, dynamic>) {
        onDeliveryUpdate(data);
      }
    });
  }

  /// DEPRECATED: Use stopListeningForDeliveryStatusUpdate instead
  @Deprecated('Use stopListeningForDeliveryStatusUpdate instead')
  void stopListeningForDeliveryTracking() {
    socket.off('delivery:track');
    log('🔇 Stopped listening for delivery tracking updates');
  }

  // ==================== LEGACY METHODS (kept for backward compatibility) ====================

  void listenForParcelLocationUpdate(
      {required String roomId, required Function(dynamic) onLocationUpdate}) {
    socket.on(roomId, onLocationUpdate);
  }

  void joinTrackingRoom({required String trackingId, required String msg}) async {
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
    stopListeningForDeliveryStatusUpdate();

    // Dispose socket
    socket.dispose();
    super.onClose();
  }
}
