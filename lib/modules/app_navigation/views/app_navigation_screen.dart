import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/orders/controllers/orders_controller.dart';

class AppNavigationScreen extends StatelessWidget {
  const AppNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    setSystemOverlayStyle(navigationColor: AppColors.whiteColor);
    return GetBuilder<AppNavigationController>(
      builder: (appNavigationController) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              // Slide and fade transition
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey<String>(
                '${appNavigationController.currentScreenIndex}_${appNavigationController.showRestaurantView}',
              ),
              child: appNavigationController
                  .screens[appNavigationController.currentScreenIndex],
            ),
          ),
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
              child: Row(
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
                      title: "Search",
                      activeIcon: SvgAssets.searchIcon,
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      index: 2,
                      title: "Orders",
                      activeIcon: SvgAssets.ordersIcon,
                      showBadge: true,
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
  final bool showBadge;
  const BottomNavItem(
      {super.key,
      required this.title,
      required this.activeIcon,
      this.iconSize = 25,
      this.showBadge = false,
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
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(
                          activeIcon,
                          height: iconSize.sp,
                          color: index == homeController.currentScreenIndex
                              ? AppColors.primaryColor
                              : AppColors.blackColor,
                          width: iconSize.sp,
                        ),
                        if (showBadge && Get.isRegistered<OrdersController>())
                          GetBuilder<OrdersController>(
                            builder: (ordersController) {
                              final pendingCount = ordersController.allOrders
                                  .where((order) =>
                                      order.status == 'pending' ||
                                      order.status == 'confirmed')
                                  .length;

                              if (pendingCount == 0) return const SizedBox.shrink();

                              return Positioned(
                                right: -6,
                                top: -6,
                                child: Container(
                                  padding: EdgeInsets.all(4.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 16.sp,
                                    minHeight: 16.sp,
                                  ),
                                  child: Center(
                                    child: customText(
                                      pendingCount > 9 ? '9+' : pendingCount.toString(),
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
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
