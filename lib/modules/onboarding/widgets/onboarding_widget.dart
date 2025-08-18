import 'package:gosharpsharp/core/utils/exports.dart';

class OnboardingWidget extends GetView<OnboardingController> {
  const OnboardingWidget({super.key, required this.asset, required this.title});
  final String asset;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScreenUtil().setVerticalSpacing(120.h),
          Center(
            child: Image.asset(asset, height: 158.3.sp, width: 243.sp),
          ),
          ScreenUtil().setVerticalSpacing(20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: customText(
              title,
              fontSize: 30.sp,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ),
          ScreenUtil().setVerticalSpacing(20.h),
        ],
      ),
    );
  }
}
