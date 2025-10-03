import 'package:gosharpsharp/modules/support/controllers/support_controller.dart';

import '../../../core/utils/exports.dart';

class SupportBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportController>(() => SupportController());
  }
}
