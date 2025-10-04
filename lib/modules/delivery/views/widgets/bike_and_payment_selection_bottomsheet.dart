import 'package:gosharpsharp/core/utils/exports.dart';

class BikeAndPaymentSelectionBottomsheet extends StatelessWidget {
  final VoidCallback onProceed;

  const BikeAndPaymentSelectionBottomsheet({
    super.key,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
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
              SizedBox(height: 20.h),

              // Bike Selection Section
              customText(
                "Select Bike Type",
                color: AppColors.blackColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 12.h),

              // Mock bike options
              _buildBikeOption(
                context,
                ordersController,
                title: "Local Bike",
                subtitle: "Best for small packages",
                price: "₦500",
                bikeType: "local",
                bikeIcon: PngAssets.localRideIcon,
              ),
              SizedBox(height: 10.h),
              _buildBikeOption(
                context,
                ordersController,
                title: "Express Bike",
                subtitle: "Faster delivery",
                price: "₦800",
                bikeType: "express",
                bikeIcon: PngAssets.expressRideIcon,
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

              // Mock payment options
              _buildPaymentOption(
                context,
                ordersController,
                title: "Pay with Wallet",
                subtitle: "Use your GoSharpSharp wallet",
                paymentType: "wallet",
                paymentIcon: SvgAssets.walletIcon,
              ),
              _buildPaymentOption(
                context,
                ordersController,
                title: "Cash on Delivery",
                subtitle: "Pay when item is delivered",
                paymentType: "cash",
                paymentIcon: null, // Using Material icon
              ),
              _buildPaymentOption(
                context,
                ordersController,
                title: "Pay with Paystack",
                subtitle: "Pay with debit/credit card",
                paymentType: "paystack",
                paymentIcon: SvgAssets.paystackIcon,
              ),

              SizedBox(height: 24.h),

              // Proceed Button
              CustomButton(
                width: 1.sw,
                height:55.h,
                onPressed: () {
                  if (ordersController.selectedBikeType == null) {
                    showToast(
                      message: "Please select a bike type",
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
                  Get.back();
                  onProceed();
                },
                title: "Proceed",
                backgroundColor: AppColors.primaryColor,
                fontColor: AppColors.whiteColor,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBikeOption(
    BuildContext context,
    DeliveriesController controller, {
    required String title,
    required String subtitle,
    required String price,
    required String bikeType,
    required String bikeIcon,
  }) {
    final isSelected = controller.selectedBikeType == bikeType;

    return InkWell(
      onTap: () {
        controller.setSelectedBikeType(bikeType);
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                customText(
                  price,
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