
import 'package:gosharpsharp/core/utils/exports.dart';

class ProfileUpdateSuccessBottomSheet extends StatelessWidget {
  const ProfileUpdateSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 260.h,
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(SvgAssets.successIcon,height: 45.h,width: 45.h,),
          SizedBox(
            height: 10.h,
          ),
          customText("Profile update successfully",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            color: AppColors.primaryColor,
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,),
          SizedBox(
            height: 20.h,
          ),
          customText(
              "Your profile has been updated with the information you provided",
              overflow: TextOverflow.visible,
              color: AppColors.blackColor,
              textAlign: TextAlign.center,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal),
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onPressed: () {
             Get.back();
              },
              // isBusy: signInProvider.isLoading,
              title: "Back",
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),

        ],
      ),
    );
  }
}
