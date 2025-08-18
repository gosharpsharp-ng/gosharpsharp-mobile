
import 'package:gosharpsharp/core/utils/app_assets.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class PaymentOptionSelector extends StatelessWidget {
  final String paymentOptionName;
  final String paymentOptionLogoAsset;
  final Function onSelected;
  final bool isSelected;
  const PaymentOptionSelector(
      {super.key,
      required this.onSelected,
      this.paymentOptionLogoAsset = SvgAssets.walletIcon,
      this.isSelected = false,
      this.paymentOptionName = "GoWallet"});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.whiteColor),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(paymentOptionLogoAsset,height: 40.sp,width: 40.sp,),
                SizedBox(
                  width: 8.sp,
                ),
                customText(paymentOptionName,
                    color: AppColors.blackColor, fontSize: 16.sp,fontWeight: FontWeight.w500,),
              ],
            ),
          ),
          Container(
            height: 20.sp,
            width: 20.sp,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.transparent,
                border: Border.all(
                    width: isSelected ? 4.sp : 1.sp,
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.obscureTextColor)),
          )
        ],
      ),
    );
  }
}
