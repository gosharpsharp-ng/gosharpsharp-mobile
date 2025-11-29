import 'package:gosharpsharp/core/utils/exports.dart';

class DeliverySuccessScreen extends StatelessWidget {
  const DeliverySuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get delivery from arguments if passed
    final args = Get.arguments as Map<String, dynamic>?;
    final deliveryFromArgs = args?['delivery'] as DeliveryModel?;

    return GetBuilder<DeliveriesController>(
      builder: (ordersController) {
        // Use delivery from arguments or fall back to selectedDelivery
        final currentDelivery = deliveryFromArgs ?? ordersController.selectedDelivery;

        return WillPopScope(
          onWillPop: () async {
            // Go back to app navigation screen when back button is pressed
            Get.offAllNamed(Routes.APP_NAVIGATION);
            return false;
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
                        SizedBox(height: 40.h),
                        CustomButton(
                          width: double.infinity,
                          onPressed: () async {
                            // Check if delivery data exists
                            if (currentDelivery == null) {
                              showToast(
                                message:
                                    'Unable to track delivery. Please try again.',
                                isError: true,
                              );
                              return;
                            }

                            try {
                              // Fetch latest delivery data from API to get real-time status
                              await ordersController.getParcelDeliveryById(
                                currentDelivery.id,
                              );

                              // Check if fetch was successful
                              if (ordersController.selectedParcelDelivery == null) {
                                showToast(
                                  message: 'Unable to load delivery details',
                                  isError: true,
                                );
                                return;
                              }

                              // Navigate to parcel delivery details screen
                              // The details screen will automatically redirect to tracking screen
                              // if the status is confirmed/accepted/picked/in_transit
                              Get.offAllNamed(Routes.APP_NAVIGATION);
                              Get.toNamed(Routes.PARCEL_DELIVERY_DETAILS_SCREEN);
                            } catch (e) {
                              showToast(
                                message: 'Error loading delivery: $e',
                                isError: true,
                              );
                            }
                          },
                          title: "Track Delivery",
                          backgroundColor: AppColors.primaryColor,
                        ),
                        SizedBox(height: 25.h),
                        CustomButton(
                          width: double.infinity,
                          onPressed: () {
                            // Refresh deliveries list to show the new delivery
                            ordersController.fetchParcelDeliveries();
                            // Go to app navigation screen - clears entire delivery creation stack
                            Get.offAllNamed(Routes.APP_NAVIGATION);
                          },
                          title: "Go Home",
                          backgroundColor: AppColors.whiteColor,
                          fontColor: AppColors.primaryColor,
                          borderColor: AppColors.primaryColor,
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
