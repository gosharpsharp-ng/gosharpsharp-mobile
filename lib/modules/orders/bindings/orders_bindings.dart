import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/orders/controllers/orders_controller.dart';

class OrdersBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      OrdersController(),
    );
  }
}
