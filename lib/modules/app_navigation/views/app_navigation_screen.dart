import 'package:gosharpsharp/core/utils/exports.dart';

class AppNavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setSystemOverlayStyle(navigationColor: AppColors.whiteColor);
    return GetBuilder<AppNavigationController>(
      builder: (appNavigationController) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: appNavigationController
              .screens[appNavigationController.currentScreenIndex],
          bottomNavigationBar: BottomAppBar(
            surfaceTintColor: AppColors.whiteColor,
            padding: const EdgeInsets.all(0.0),
            color: AppColors.whiteColor,
            elevation: 6,
            shape: const CircularNotchedRectangle(),
            // notchMargin: 12.sp,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    20.r,
                  ),
                  topRight: Radius.circular(
                    20.r,
                  ),
                ),
              ),
              height: 60.sp,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: BottomNavItem(
                      index: 0,
                      title: "Home",
                      activeIcon: SvgAssets.homeIcon,
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      index: 1,
                      title: "Cart",
                      activeIcon: SvgAssets.cartIcon,
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      index: 2,
                      title: "Orders",
                      activeIcon: SvgAssets.ordersIcon,
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      index: 3,
                      title: "Profile",
                      activeIcon: SvgAssets.profileIcon,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String title;
  final String activeIcon;
  final int index;
  final int iconSize;
  const BottomNavItem(
      {super.key,
      required this.title,
      required this.activeIcon,
      this.iconSize = 25,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppNavigationController>(
        builder: (homeController) => Container(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  homeController.changeScreenIndex(index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      activeIcon,
                      height: iconSize.sp,
                      color: index == homeController.currentScreenIndex
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                      width: iconSize.sp,
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    customText(title,
                        fontWeight: index == homeController.currentScreenIndex
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: index == homeController.currentScreenIndex
                            ? AppColors.primaryColor
                            : AppColors.blackColor,
                        fontSize: 13.sp)
                  ],
                ),
              ),
            ));
  }
}
