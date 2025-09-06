import 'dart:math' as math;

import '../../../core/utils/exports.dart';
// TODO: When the user clicks on an item in the list, it should hide the landing screen and show the selected screen; say dashboard screen
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark, // For light status bar text
      ),
      body: Container(
        height: 1.sh,
        padding: EdgeInsets.symmetric(horizontal:15.w,vertical: 70.h),
        width: 1.sw,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(PngAssets.lightWatermark,),fit: BoxFit.cover
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              customText("What do you want to get Sharp Sharp?",fontWeight: FontWeight.w500,fontSize: 24.sp,overflow: TextOverflow.visible),
              // SizedBox(height: 15.h,),
              // customText("Let's know what you want to do today?",fontWeight: FontWeight.w500,fontSize: 18.sp,),
              //
              SizedBox(height: 45.h,),
              Center(
                child: Container(
                  width: 450.w,
                  height: 500.h,
                  child: CircularMenu(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularMenu extends StatelessWidget {
  // Food delivery item for center
  final MenuItem centerItem = MenuItem(
    title: "Food\nDelivery",
    icon: PngAssets.food,
    color: AppColors.secondaryColor,
  );

  // Surrounding menu items (excluding food delivery)
  final List<MenuItem> menuItems = [
    MenuItem(
      title: "Package\nDelivery",
      icon: PngAssets.rider,
      color: AppColors.primaryColor,
    ),
    // MenuItem(
    //   title: "Bukkateria\nFast Food",
    //   icon: PngAssets.food,
    //   color: AppColors.secondaryColor,
    // ),
    // MenuItem(
    //   title: "Otega\nRestaurant",
    //   icon: PngAssets.food,
    //   color: AppColors.secondaryColor,
    // ),
    MenuItem(
      title: "Pharmacy &\nBeauty",
      icon: PngAssets.pharmacy,
      color: AppColors.primaryColor,
        isAvailable: false
    ),
    MenuItem(
        title: "Groceries",
        icon: PngAssets.grocery,
        color: AppColors.primaryColor,
        isAvailable: false
    ),
    MenuItem(
      title: "Shopping",
      icon: PngAssets.shopping,
      color: AppColors.secondaryColor,
        isAvailable: false
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Calculate angle step based on number of items
    final angleStep = (360 / menuItems.length) * (math.pi / 180);
    final radius = 130.0; // Increased radius to accommodate center item

    return Stack(
      alignment: Alignment.center,
      children: [
        // Surrounding circular menu items
        ...List.generate(menuItems.length, (index) {
          final angle = (index * angleStep) - (math.pi / 2); // Start from top
          final x = radius * math.cos(angle);
          final y = radius * math.sin(angle);

          return Transform.translate(
            offset: Offset(x, y),
            child: MenuItemWidget(
              item: menuItems[index],
            ),
          );
        }),

        // Center food delivery item
        MenuItemWidget(
          item: centerItem,
        ),
      ],
    );
  }
}

class MenuItem {
  final String title;
  final String icon;
  final Color color;
  final bool isAvailable;
  final VoidCallback? onTap;

  MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
    this.isAvailable = true
  });
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;

  const MenuItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        width: 115.w, // Increased width for oval shape
        height: 115.h, // Reduced height for oval shape
        decoration: BoxDecoration(
          color: item.isAvailable ? item.color : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(45.r), // Creates oval shape
          boxShadow: item.isAvailable ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ] : [],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // customText(
                //   item.icon,
                //   fontSize: 20.sp,
                //   color: item.isAvailable ? AppColors.blackColor : Colors.grey.shade500,
                // ),
                Image.asset(item.icon, height: 50.h,width: 50.w,),
                SizedBox(height: 2.h),
                customText(
                  item.title,
                  textAlign: TextAlign.center,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: item.isAvailable ? item.color==AppColors.primaryColor?AppColors.whiteColor:AppColors.blackColor : Colors.grey.shade500,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Coming Soon overlay
            if (!item.isAvailable)
              Container(
                width: 110.w,
                height: 105.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(45.r), // Matches oval shape
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(
                      "Coming",
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    customText(
                      "Soon",
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}