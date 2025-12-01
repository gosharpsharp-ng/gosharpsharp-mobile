import 'package:gosharpsharp/core/services/push_notification_service.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
}

class GoSharpSharp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const GoSharpSharp({
    super.key,
    required this.navigatorKey,
  });
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoSharpSharp',
      theme: ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      // navigatorKey: navigatorKey,
    );
  }
}
