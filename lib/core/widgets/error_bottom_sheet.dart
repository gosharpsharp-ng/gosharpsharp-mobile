import 'package:gosharpsharp/core/utils/exports.dart';

class ErrorBottomSheet extends StatefulWidget {
  final String title;
  final String message;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;
  final bool autoDismiss;
  final int autoDismissSeconds;

  const ErrorBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.actionButtonText,
    this.onActionPressed,
    this.autoDismiss = true,
    this.autoDismissSeconds = 5,
  });

  @override
  State<ErrorBottomSheet> createState() => _ErrorBottomSheetState();
}

class _ErrorBottomSheetState extends State<ErrorBottomSheet> {
  @override
  void initState() {
    super.initState();

    // Auto-dismiss after specified seconds
    if (widget.autoDismiss) {
      Future.delayed(Duration(seconds: widget.autoDismissSeconds), () {
        if (mounted && Get.isBottomSheetOpen == true) {
          Get.back();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withAlpha(25),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(bottom: 24.h),
              width: 48.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: AppColors.obscureTextColor.withAlpha(80),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),

            // Error icon with animated container
            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                color: AppColors.redColor.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: AppColors.redColor,
                size: 52.sp,
              ),
            ),

            SizedBox(height: 20.h),

            // Title
            Container(
              width: 1.sw,
              child: customText(
                widget.title,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 12.h),

            // Error message
            Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: customText(
                widget.message,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.greyColor,
                textAlign: TextAlign.center,
                maxLines: 6,
                height: 1.4,
              ),
            ),

            SizedBox(height: 32.h),

            // Action buttons
            if (widget.actionButtonText != null && widget.onActionPressed != null)
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: "Cancel",
                      backgroundColor: AppColors.whiteColor,
                      fontColor: AppColors.greyColor,
                      borderColor: AppColors.greyColor.withAlpha(150),
                      height: 50,
                      fontSize: 15,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      title: widget.actionButtonText!,
                      backgroundColor: AppColors.redColor,
                      fontColor: AppColors.whiteColor,
                      height: 50,
                      fontSize: 15,
                      onPressed: () {
                        Get.back();
                        widget.onActionPressed?.call();
                      },
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: 1.sw,
                child: CustomButton(
                  title: "Got it",
                  backgroundColor: AppColors.primaryColor,
                  fontColor: AppColors.whiteColor,
                  height: 52,
                  width: double.infinity,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  onPressed: () => Get.back(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
