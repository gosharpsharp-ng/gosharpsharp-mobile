
import 'package:gosharpsharp/core/utils/exports.dart';

class NotificationItem extends StatelessWidget {
final NotificationModel notification;
  final Function onTap;
  final bool isLast;
  const NotificationItem({
    super.key,
    required this.onTap,
    required this.notification,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(0.r),
        border: Border(
          bottom: BorderSide(
            color: isLast
                ? AppColors.transparent
                : AppColors.obscureTextColor, // Set the border color
            width: 0.09, // Set the border thickness
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.sp),
              decoration: const BoxDecoration(
                  color: AppColors.fadedPrimaryColor, shape: BoxShape.circle),
              child: Center(
                child: Stack(
                  children: [
                    Visibility(
                      visible:notification.status=="unread",
                      child: Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                            height: 5.sp,
                            width: 5.sp,
                          )),
                    ),
                    SvgPicture.asset(
                      SvgAssets.notificationIcon,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(notification.title,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            overflow: TextOverflow.visible),
                        customText(
                          "${formatDate(notification.createdAt)} ${formatTime(notification.createdAt)}",
                          color: AppColors.obscureTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(notification.message,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 15.sp,
                            overflow: TextOverflow.visible),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
