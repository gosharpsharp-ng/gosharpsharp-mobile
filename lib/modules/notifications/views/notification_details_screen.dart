
import 'package:gosharpsharp/core/utils/exports.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        builder: (settingsController){
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
              padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(settingsController.selectedNotification?.title??"",
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      overflow: TextOverflow.visible),
                  SizedBox(height: 10.sp,),
                  customText(settingsController.selectedNotification?.message??"",
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.sp,
                      overflow: TextOverflow.visible),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
