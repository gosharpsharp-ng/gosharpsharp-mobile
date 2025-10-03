
import 'package:gosharpsharp/core/utils/exports.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
        builder: (notificationsController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Notification Details",
            centerTitle: false,
          ),
          body: Container(
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Title
                  customText(
                    notificationsController.selectedNotification?.title ?? "No Title",
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    overflow: TextOverflow.visible,
                  ),

                  SizedBox(height: 16.h),

                  // Notification Date/Time
                  if (notificationsController.selectedNotification?.createdAt != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: customText(
                        "Received: ${_formatDate(notificationsController.selectedNotification!.createdAt)}",
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),

                  SizedBox(height: 20.h),

                  // Notification Message/Body
                  customText(
                    notificationsController.selectedNotification?.message ?? "No message content available",
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 16.sp,
                    overflow: TextOverflow.visible,
                    height: 1.5,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }
}
