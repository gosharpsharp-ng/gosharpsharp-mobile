import 'package:gosharpsharp/core/utils/exports.dart';

class PhoneNumberWidget extends StatelessWidget {
  final String phoneNumber;
  final String title;
  final Function callAction;
  const PhoneNumberWidget(
      {super.key,
      required this.phoneNumber,
      required this.callAction,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title,
            fontSize: 12.sp,
            color: AppColors.obscureTextColor,
            fontWeight: FontWeight.w500,
          ),
          Row(
            children: [
              Expanded(
                child: customText(
                  phoneNumber,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              InkWell(
                  onTap: () {
                    callAction();
                  },
                  child: SvgPicture.asset(
                    SvgAssets.callIcon,
                    height: 25.sp,
                    width: 25.sp,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
