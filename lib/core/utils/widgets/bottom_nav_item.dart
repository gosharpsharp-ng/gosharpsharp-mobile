
import 'package:gosharpsharp/core/utils/exports.dart';

class BottomNavItem extends StatelessWidget {
  final String title;
  final String activeIcon;
  final bool isActive;
  final Function onPressed;
  final int index;
  const BottomNavItem(
      {super.key,
        this.title='',
        this.isActive=false,
        required this.onPressed,
        required this.activeIcon,
        required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.primaryColor,
        onTap: () {
         onPressed();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              activeIcon,
              height: 28.sp,
              color: isActive
                  ? AppColors.primaryColor
                  : AppColors.blackColor,
              width: 28.sp,
            ),
            SizedBox(
              height: 5.sp,
            ),
            customText(title,
                fontWeight: isActive
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: isActive
                    ? AppColors.primaryColor
                    : AppColors.blackColor,
                fontSize: 13.sp)
          ],
        ),
      ),
    );
  }
}