import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/services/location/location_service.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
          () => SplashController(),
    );

    // Initialize LocationService early in the app lifecycle
    Get.put<LocationService>(
      LocationService(),
      permanent: true,
    );
  }
}
