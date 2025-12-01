import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/models/courier_type_model.dart';

class BikeAndPaymentSelectionBottomsheet extends StatelessWidget {
  final VoidCallback onProceed;

  const BikeAndPaymentSelectionBottomsheet({
    super.key,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      // Get settings controller to access user profile and wallet balance
      // Use putIfAbsent pattern to ensure controller exists
      SettingsController settingsController;
      if (Get.isRegistered<SettingsController>()) {
        settingsController = Get.find<SettingsController>();
      } else {
        settingsController = Get.put(SettingsController());
      }
      final walletBalance = settingsController.userProfile?.walletBalance ?? 0.0;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fixed header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                children: [
                  // Header handle
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: customText(
                      "Select Bike & Payment",
                      color: AppColors.blackColor,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Courier Selection Section
              customText(
                "Select Courier Type",
                color: AppColors.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),

              // Display courier types from API
              if (ordersController.selectedDeliveryResponseModel != null &&
                  ordersController.selectedDeliveryResponseModel!.courierTypes.isNotEmpty)
                ...List.generate(
                  ordersController.selectedDeliveryResponseModel!.courierTypes.length,
                  (index) {
                    final courierType = ordersController
                        .selectedDeliveryResponseModel!.courierTypes[index];
                    return Column(
                      children: [
                        _buildCourierOption(
                          context,
                          ordersController,
                          courierType: courierType,
                        ),
                        if (index <
                            ordersController.selectedDeliveryResponseModel!
                                    .courierTypes.length -
                                1)
                          SizedBox(height: 10.h),
                      ],
                    );
                  },
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        size: 48.sp,
                        color: AppColors.obscureTextColor,
                      ),
                      SizedBox(height: 12.h),
                      customText(
                        "No Courier Types Available",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(height: 8.h),
                      customText(
                        "We couldn't find any available courier options for this delivery. Please try again later.",
                        fontSize: 14.sp,
                        color: AppColors.obscureTextColor,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 24.h),

              // Payment Method Selection Section
              customText(
                "Payment Method",
                color: AppColors.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),

              // Payment options
              _buildPaymentOption(
                context,
                ordersController,
                title: "Pay with Wallet",
                subtitle: "Balance: ${formatToCurrency(walletBalance)}",
                paymentType: "wallet",
                paymentIcon: SvgAssets.walletIcon,
              ),
              _buildPaymentOption(
                context,
                ordersController,
                title: "Card Payment",
                subtitle: "Pay with debit/credit card",
                paymentType: "paystack",
                paymentIcon: SvgAssets.paystackIcon,
              ),

              SizedBox(height: 24.h),

              // Proceed Button
              CustomButton(
                width: 1.sw,
                height: 55.h,
                onPressed: () {
                  if (ordersController.confirmingDelivery) return;

                  if (ordersController.selectedCourierType == null) {
                    showToast(
                      message: "Please select a courier type",
                      isError: true,
                    );
                    return;
                  }
                  if (ordersController.selectedPaymentType == null) {
                    showToast(
                      message: "Please select a payment method",
                      isError: true,
                    );
                    return;
                  }
                  // Don't close bottomsheet - let the API call complete first
                  onProceed();
                },
                title: "Confirm Delivery",
                isBusy: ordersController.confirmingDelivery,
                backgroundColor: AppColors.primaryColor,
                fontColor: AppColors.whiteColor,
              ),
              SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCourierOption(
    BuildContext context,
    DeliveriesController controller, {
    required DeliveryCourierType courierType,
  }) {
    final isSelected = controller.selectedCourierType?.id == courierType.id;

    // Get bike icon based on courier type name
    String bikeIcon = PngAssets.localRideIcon;
    final lowerName = courierType.name.toLowerCase();

    if (lowerName.contains('express') || lowerName.contains('motorcycle')) {
      bikeIcon = PngAssets.expressRideIcon;
    } else if (lowerName.contains('van') || lowerName.contains('cargo')) {
      bikeIcon = PngAssets.localRideIcon; // Use appropriate icon
    } else if (lowerName.contains('bicycle') || lowerName.contains('bike')) {
      bikeIcon = PngAssets.localRideIcon;
    }

    return InkWell(
      onTap: () {
        controller.setSelectedCourierType(courierType);
      },
      child: Container(
        padding: EdgeInsets.all(12.sp),
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50.sp,
              height: 50.sp,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.all(8.sp),
              child: Image.asset(
                bikeIcon,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    courierType.name,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 2.h),
                  customText(
                    courierType.description ?? "Standard delivery",
                    fontSize: 12.sp,
                    color: Colors.grey[600]!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                customText(
                  "₦${courierType.subtotal.toStringAsFixed(2)}",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 4.h),
                Container(
                  width: 20.sp,
                  height: 20.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primaryColor : Colors.grey[400]!,
                      width: isSelected ? 6.sp : 2.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    DeliveriesController controller, {
    required String title,
    required String subtitle,
    required String paymentType,
    String? paymentIcon,
  }) {
    final isSelected = controller.selectedPaymentType == paymentType;

    return InkWell(
      onTap: () {
        controller.setSelectedPaymentType(paymentType);
      },
      child: Container(
        padding: EdgeInsets.all(12.sp),
        margin: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey[300]!,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50.sp,
              height: 50.sp,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.all(12.sp),
              child: paymentIcon != null
                  ? SvgPicture.asset(
                      paymentIcon,
                      colorFilter: ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    )
                  : Icon(
                      Icons.money,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    title,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 2.h),
                  customText(
                    subtitle,
                    fontSize: 12.sp,
                    color: Colors.grey[600]!,
                  ),
                ],
              ),
            ),
            Container(
              width: 20.sp,
              height: 20.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : Colors.grey[400]!,
                  width: isSelected ? 6.sp : 2.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}