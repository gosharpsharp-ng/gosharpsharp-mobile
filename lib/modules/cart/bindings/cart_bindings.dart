import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';

class CartBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      CartController(),
    );
  }
}
