import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryPaymentOptionsScreen extends StatelessWidget {
  const DeliveryPaymentOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
        builder: (ordersController){
        return Form(
          // key: signInProvider.signInFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Payment Summary",
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 15.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TitleSectionBox(
                      backgroundColor: AppColors.whiteColor,
                      title: "Total amount",
                      children: [
                        customText("₦7,000",
                            fontWeight: FontWeight.w600,
                            fontSize: 30.sp,
                            fontFamily: GoogleFonts.montserrat().fontFamily!)
                      ],
                    ),
                    TitleSectionBox(
                      backgroundColor: AppColors.backgroundColor,
                      title: "Payment Options",
                      children: [
                        PaymentOptionSelector(
                          onSelected: () {},
                          isSelected: true,
                        ),
                        // PaymentOptionSelector(
                        //   onSelected: () {},
                        //   paymentOptionName: "Paystack",
                        //   paymentOptionLogoAsset: SvgAssets.paystackIcon,
                        // ),
                        // PaymentOptionSelector(
                        //   onSelected: () {},
                        //   paymentOptionName: "Flutterwave",
                        //   paymentOptionLogoAsset: SvgAssets.flutterWaveIcon,
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        onPressed: () {
                          showAnyBottomSheet(
                              isControlled: false,
                              child: PaymentSuccessBottomSheet());
                        },
                        // isBusy: signInProvider.isLoading,
                        title: "Proceed to pay",
                        width: 1.sw,
                        backgroundColor: AppColors.primaryColor,
                        fontColor: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
