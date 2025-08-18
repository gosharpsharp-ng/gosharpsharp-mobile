
import 'package:gosharpsharp/core/utils/exports.dart';

PreferredSize flatAppBar({Color bgColor=AppColors.whiteColor,Color navigationColor=AppColors.whiteColor}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(0.sp),
    child: AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      surfaceTintColor: bgColor,
      systemOverlayStyle:  SystemUiOverlayStyle(
        statusBarColor: bgColor,
        statusBarIconBrightness:[AppColors.primaryColor,AppColors.fadedPrimaryColor,AppColors.deepPrimaryColor].contains(bgColor)?Brightness.light:Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: navigationColor,
        systemNavigationBarIconBrightness:[AppColors.primaryColor,AppColors.deepPrimaryColor].contains(navigationColor)?Brightness.light:Brightness.dark,
        systemNavigationBarDividerColor: navigationColor,
      ),
    ),
  );
}
PreferredSize defaultAppBar({String title = "", VoidCallback? onPop,Color bgColor=Colors.white, bool implyLeading=true, bool centerTitle=false, Widget actionItem=const SizedBox.shrink()}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(40.0.h), // Adjust the height as needed
    child: AppBar(
      title: customText(title,fontSize:24.sp,fontWeight: FontWeight.w600,color:AppColors.blackColor  ), // Added title if needed
      centerTitle: centerTitle,
      foregroundColor: bgColor,
      surfaceTintColor: bgColor,
      automaticallyImplyLeading: implyLeading,
      elevation: 0,
      backgroundColor: bgColor,
      systemOverlayStyle:  SystemUiOverlayStyle(
        statusBarColor: bgColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.whiteColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: AppColors.whiteColor,
      ),
      leading:implyLeading? IconButton(
        onPressed: onPop ?? () => Get.back(),
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.blackColor,
        ),
      ):null,
      actions: [actionItem],
    ),
  );
}


PreferredSize flatEmptyAppBar({Color navigationColor=AppColors.whiteColor,Color topColor=AppColors.whiteColor}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(0.sp),
    child: AppBar(
      elevation: 0,
      backgroundColor: topColor,
      surfaceTintColor: topColor,
      systemOverlayStyle:  SystemUiOverlayStyle(
        systemNavigationBarColor: navigationColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarColor: topColor,
        systemNavigationBarIconBrightness: navigationColor==AppColors.whiteColor?Brightness.light:Brightness.dark,
        systemNavigationBarDividerColor: navigationColor,
      ),
    ),
  );
}
void setSystemOverlayStyle({
  Color navigationColor = AppColors.whiteColor,
  Color topColor = AppColors.whiteColor,
}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: navigationColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      statusBarColor: topColor,
      systemNavigationBarIconBrightness: navigationColor == AppColors.whiteColor ? Brightness.dark : Brightness.light,
      systemNavigationBarDividerColor: navigationColor,
    ),
  );
}

