import 'package:gosharpsharp/core/utils/exports.dart';

class DeliverySuccessScreen extends StatelessWidget {
  const DeliverySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
      builder: (ordersController) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              // Refresh deliveries list and go home
              ordersController.fetchParcelDeliveries();
              Get.offAllNamed(Routes.APP_NAVIGATION);
            }
          },
          child: Scaffold(
            appBar: flatAppBar(bgColor: AppColors.backgroundColor),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              height: 1.sh,
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 1.sw,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(SvgAssets.successIcon, height: 60.sp),
                        SizedBox(height: 30.h),
                        customText(
                          "Your delivery has been confirmed",
                          overflow: TextOverflow.visible,
                          color: AppColors.primaryColor,
                          textAlign: TextAlign.center,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 15.h),
                        customText(
                          "We're connecting you to the nearest rider",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                        ),
                        SizedBox(height: 12.h),
                        customText(
                          "You can track your delivery from the Deliveries tab",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          color: AppColors.obscureTextColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                        ),
                        SizedBox(height: 40.h),
                        CustomButton(
                          width: double.infinity,
                          onPressed: () {
                            // Refresh deliveries list to show the new delivery
                            ordersController.fetchParcelDeliveries();
                            // Go to app navigation screen - clears entire delivery creation stack
                            Get.offAllNamed(Routes.APP_NAVIGATION);
                          },
                          title: "Go Home",
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
