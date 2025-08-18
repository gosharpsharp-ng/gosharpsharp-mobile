import 'package:gosharpsharp/core/utils/exports.dart';


class WalletBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(
          () => WalletController(),
    );
  }
}
