import 'package:gosharpsharp/core/utils/exports.dart';


class DeliveriesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveriesController>(
          () => DeliveriesController(),
    );
  }
}
