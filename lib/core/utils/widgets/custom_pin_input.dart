import 'package:gosharpsharp/core/utils/exports.dart';

class CustomPinInput extends StatelessWidget {
  final String? title;
  final int maxLength;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onDone;
  final Function(String)? onChanged;
  final bool useBottomBorderOnly; // Use only bottom border

  const CustomPinInput({
    super.key,
    this.title,
    this.onDone,
    required this.maxLength,
    required this.validator,
    required this.controller,
    this.onChanged,
    this.useBottomBorderOnly = true, // Default to bottom border only
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == null
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  title!,
                  style: TextStyle(
                    fontFamily: "Satoshi",
                    color: AppColors.obscureTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
        Pinput(
          // smsRetriever: SmsRetriever?,
          isCursorAnimationEnabled: true,
          defaultPinTheme: PinTheme(
            width: 48.h,
            height: 48.h,
            textStyle: TextStyle(
              fontFamily: "Satoshi",
              color: AppColors.blackColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
              border: useBottomBorderOnly
                  ? Border(
                      bottom: BorderSide(
                        color: AppColors.disabledColor,
                        width: 1.h,
                      ),
                    )
                  : Border.all(color: AppColors.disabledColor, width: 1.h),
            ),
          ),
          followingPinTheme: PinTheme(
            width: useBottomBorderOnly ? 60.w : 48.h,
            height: 48.h,
            textStyle: TextStyle(
              fontFamily: "Satoshi",
              color: AppColors.blackColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.r),
              border: useBottomBorderOnly
                  ? Border(
                      bottom: BorderSide(
                        color: AppColors.disabledColor,
                        width: 1.h,
                      ),
                    )
                  : Border.all(color: AppColors.disabledColor, width: 1.w),
            ),
          ),
          submittedPinTheme: PinTheme(
            width: useBottomBorderOnly ? 60.w : 48.h,
            height: 48.h,
            textStyle: TextStyle(
              fontFamily: "Satoshi",
              color: AppColors.blackColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
              border: useBottomBorderOnly
                  ? Border(
                      bottom: BorderSide(
                        color: AppColors.disabledColor,
                        width: 1.h,
                      ),
                    )
                  : Border.all(color: AppColors.disabledColor, width: 1.w),
            ),
          ),
          validator: validator,
          focusedPinTheme: PinTheme(
            width: useBottomBorderOnly ? 60.w : 48.h,
            height: 48.h,
            textStyle: TextStyle(
              fontFamily: "Satoshi",
              color: AppColors.blackColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
              border: useBottomBorderOnly
                  ? Border(
                      bottom: BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.2.h,
                      ),
                    )
                  : Border.all(color: AppColors.primaryColor, width: 1.h),
            ),
          ),
          length: maxLength,
          onCompleted: onDone,
          controller: controller,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        ),
      ],
    );
  }
}
