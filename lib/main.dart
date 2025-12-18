import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gosharpsharp/core/services/app_update/app_update_service.dart';
import 'package:gosharpsharp/core/services/push_notification_service.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load appropriate env file based on build mode
  const buildMode = String.fromEnvironment('BUILD_MODE', defaultValue: 'dev');
  await dotenv.load(fileName: buildMode == 'prod' ? '.env.prod' : '.env.dev');

  await GetStorage.init();
  await ScreenUtil.ensureScreenSize();
  // await Get.putAsync(() => AuthProvider().init());
  // Get.put(DeliveryNotificationServiceManager());
  // await Get.find<DeliveryNotificationServiceManager>().initializeServices();

  // Initialize push notifications
  await PushNotificationService().initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  setupServiceLocator();

  /// 1.1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  // ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // call the useSystemCallingUI
  // ZegoUIKit().initLog().then((value) {
  //   ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
  //     [ZegoUIKitSignalingPlugin()],
  //   );
  //
  //   runApp(GoSharpSharp(navigatorKey: navigatorKey));
  // });
  runApp(GoSharpSharp(navigatorKey: navigatorKey));

  // Check for app updates after app is running
  Future.delayed(const Duration(seconds: 2), () {
    AppUpdateService().initialize();
  });
}

class GoSharpSharp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const GoSharpSharp({
    super.key,
    required this.navigatorKey,
  });
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoSharpSharp',
      theme: ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // navigatorKey: navigatorKey,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(0.85),
            boldText: false,
          ),
          child: child!,
        );
      },
    );
  }
}
