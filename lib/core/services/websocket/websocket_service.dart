import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../utils/exports.dart';

class SocketService extends GetxService {
  static SocketService get instance => Get.find();

  late IO.Socket socket;
  final isConnected = false.obs;
  late UserProfile _userProfile;

  Future<SocketService> init() async {
    _initializeSocket();
    _setupSocketListeners();
    return this;
  }

  void _initializeSocket() {
    socket = IO.io(
        'http://164.90.143.42:8082',
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
        print('Socket Connected');
        isConnected.value = true;
        joinRidersTrackingRoom();
      })
      ..onDisconnect((_) {
        print('Socket Disconnected');
        isConnected.value = false;
      })
      ..onReconnect((_) {
        log('Socket Reconnected');
        isConnected.value = true;
        joinRidersTrackingRoom();
      })
      ..onError((error) => log('Socket Error: $error'))
      ..onConnectError((error) => log('Socket Connect Error: $error'));
  }

  void listenForParcelLocationUpdate(
      {required String roomId, required Function(dynamic) onLocationUpdate}) {
    socket.on(roomId, onLocationUpdate);
  }

  joinTrackingRoom({required String trackingId, required String msg}) async {
    if (isConnected.value) {
      socket.emit(msg, trackingId);
    }
  }

  joinRidersTrackingRoom() async {
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

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
