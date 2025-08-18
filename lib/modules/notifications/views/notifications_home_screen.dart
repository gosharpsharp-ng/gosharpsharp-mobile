import 'package:gosharpsharp/core/utils/exports.dart';

class NotificationsHomeScreen extends StatelessWidget {
  const NotificationsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
        builder: (notificationsController) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Notifications",
          centerTitle: false,
        ),
        body: RefreshIndicator(
          backgroundColor: AppColors.primaryColor,
          color: AppColors.whiteColor,
          onRefresh: () async {
            notificationsController.getNotifications();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: Visibility(
              visible: notificationsController.notifications.isNotEmpty,
              replacement: Visibility(
                visible: notificationsController.fetchingNotifications &&
                    notificationsController.notifications.isEmpty,
                replacement: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: customText("No Notifications yet"),
                    ),
                  ],
                ),
                child: Center(
                  child: customText("Loading...."),
                ),
              ),
              child: SingleChildScrollView(
                controller:
                    notificationsController.notificationsScrollController,
                child: Column(
                  children: [
                    ...List.generate(
                      notificationsController.notifications.length,
                      (i) => NotificationItem(
                        onTap: () {
                          notificationsController.setSelectedNotification(
                              notificationsController.notifications[i]);
                          Get.toNamed(Routes.NOTIFICATIONS_DETAILS);
                        },
                        notification: notificationsController.notifications[i],
                        isLast:
                            i == notificationsController.notifications.length,
                      ),
                    ),
                    Visibility(
                      visible: notificationsController.fetchingNotifications &&
                          notificationsController.notifications.isNotEmpty,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customText("Loading more...",
                              color: AppColors.blueColor),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: notificationsController.notifications ==
                          notificationsController.totalNotifications,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customText("No more data to load",
                              color: AppColors.blueColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
