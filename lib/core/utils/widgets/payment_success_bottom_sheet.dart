import 'package:gosharpsharp/core/utils/exports.dart';

class PaymentSuccessBottomSheet extends StatelessWidget {
  const PaymentSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(SvgAssets.successIcon),
          SizedBox(
            height: 20.h,
          ),
          customText("Payment successful",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              color: AppColors.blackColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.w700),
          SizedBox(
            height: 20.h,
          ),
          customText(
              "You’ll be notified once your order is in transit. You can turn on notifications to get notified.",
              overflow: TextOverflow.visible,
              color: AppColors.blackColor,
              textAlign: TextAlign.center,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal),
          SizedBox(
            height: 20.h,
          ),
          CustomButton(
            onPressed: () {},
            // isBusy: signInProvider.isLoading,
            title: "Back",
            width: 1.sw,
            backgroundColor: AppColors.primaryColor,
            fontColor: AppColors.whiteColor,
          ),
          SizedBox(
            height: 15.h,
          ),
          CustomIconButton(
            onPressed: () {},
            // isBusy: signInProvider.isLoading,
            title: "Share",
            icon: Icons.share_rounded,
            iconColor: AppColors.primaryColor,
            width: 1.sw,
            backgroundColor: AppColors.fadedButtonPrimaryColor,
            fontColor: AppColors.primaryColor,
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
