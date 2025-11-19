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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(bottom: 20.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.obscureTextColor.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Error icon with animated container
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: AppColors.redColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: AppColors.redColor,
              size: 48.sp,
            ),
          ),

          SizedBox(height: 16.h),

          // Title
          customText(
            widget.title,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          // Error message
          customText(
            widget.message,
            fontSize: 14.sp,
            color: AppColors.greyColor,
            textAlign: TextAlign.center,
            maxLines: 5,
          ),

          SizedBox(height: 24.h),

          // Action buttons
          if (widget.actionButtonText != null && widget.onActionPressed != null)
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Cancel",
                    backgroundColor: AppColors.whiteColor,
                    fontColor: AppColors.greyColor,
                    borderColor: AppColors.greyColor,
                    height: 45,
                    fontSize: 14,
                    onPressed: () => Get.back(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomButton(
                    title: widget.actionButtonText!,
                    backgroundColor: AppColors.redColor,
                    fontColor: AppColors.whiteColor,
                    height: 45,
                    fontSize: 14,
                    onPressed: () {
                      Get.back();
                      widget.onActionPressed?.call();
                    },
                  ),
                ),
              ],
            )
          else
            CustomButton(
              title: "Got it",
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
              height: 45,
              width: 150,
              fontSize: 14,
              onPressed: () => Get.back(),
            ),
        ],
      ),
    );
  }
}
