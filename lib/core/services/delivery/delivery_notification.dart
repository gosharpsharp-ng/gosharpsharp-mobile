import 'dart:convert';
import 'dart:developer';

import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryNotificationService extends GetxService {
  static DeliveryNotificationService get instance => Get.find();

  bool _isListenerSetup = false;

  void initialize() {
    final socketService = Get.find<SocketService>();
    if (Get.isRegistered<SocketService>()) {
      // socketService.socket.on('shipment', (dynamic data) {
      //   handleShipmentNotification(data);
      // });
      // Get.find<SocketService>().listenForShipments((data) {
      //   print(
      //       "*********************************************Shipment don show******************************************************");
      //   print(data.toString());
      //   print(
      //       "***************************************************************************************************");
      // });
    }

  }

  void setupShipmentListener() {
    if (_isListenerSetup) {
      print('Shipment listeners already setup, skipping');
      return;
    }

    final socketService = Get.find<SocketService>();

    // Setup shipment listener
    socketService.socket.on('shipment_events', (dynamic data) {
      log('Received shipment notification');
      log("**********************************************************************************");
      log(data.toString());
      log("Shipment Entered **********************************************************************************");

    });

    _isListenerSetup = true;
  }




}

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const OrderDetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            label,
            fontSize: 16.sp,
            fontFamily: GoogleFonts.montserrat().fontFamily!,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(width: 10.sp),
          Expanded(
            child: customText(value,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.montserrat().fontFamily!),
          ),
        ],
      ),
    );
  }
}
