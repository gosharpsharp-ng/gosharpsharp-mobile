import 'package:gosharpsharp/core/utils/exports.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await ScreenUtil.ensureScreenSize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  setupServiceLocator();

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
