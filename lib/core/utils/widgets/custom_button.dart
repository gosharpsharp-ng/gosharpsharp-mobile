import 'package:gosharpsharp/core/utils/exports.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.title = "",
    required this.onPressed,
    this.backgroundColor = AppColors.redColor,
    this.fontColor = AppColors.whiteColor,
    this.borderColor = Colors.transparent,
    this.fontWeight = FontWeight.w600,
    this.width = 260,
    this.height = 52,
    this.fontSize = 14,
    this.borderRadius = 16, // Default border radius
    this.isBusy = false,
    this.icon = Icons.arrow_forward_outlined,
  });

  final String title;
  final Function onPressed;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final Color fontColor;
  final IconData icon;
  final double width;
  final double height;
  final double fontSize;
  final double borderRadius;
  final Color borderColor;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isBusy ? print("Is Busy") : onPressed(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
        height: height.sp,
        width: width.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          border: Border.all(color: borderColor, width: 1.sp),
          color: backgroundColor,
        ),
        child: Center(
          child: isBusy
              ? SizedBox(
            height: 25.sp,
            width: 25.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: fontColor,
            ),
          )
              : customText(
            title,
            fontSize: fontSize.sp,
            color: fontColor,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.title = "",
    required this.onPressed,
    this.backgroundColor = AppColors.redColor,
    this.fontColor = AppColors.whiteColor,
    this.borderColor = Colors.transparent,
    this.iconBackgroundColor = Colors.white,
    this.iconColor = AppColors.redColor,
    this.width = 260,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.borderRadius = 40, // Default border radius
    this.isBusy = false,
    this.icon = Icons.arrow_forward_outlined,
  });

  final String title;
  final int fontSize;
  final FontWeight fontWeight;
  final Function onPressed;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color fontColor;
  final IconData icon;
  final double width;
  final double borderRadius;
  final Color borderColor;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        height: 55.sp,
        width: width.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          border: Border.all(color: borderColor, width: 1.sp),
          color: backgroundColor,
        ),
        child: isBusy
            ? Center(
          child: SizedBox(
            height: 25.sp,
            width: 25.sp,
            child: const CircularProgressIndicator(
              color: AppColors.whiteColor,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.sp),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
              ),
              child: Icon(icon, color: iconColor),
            ),
            SizedBox(width: 5.w),
            customText(
              title,
              fontSize: fontSize.sp,
              color: fontColor,
              fontWeight: fontWeight,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomFlatButton extends StatelessWidget {
  const CustomFlatButton({
    super.key,
    this.title = "",
    required this.onPressed,
    this.width = 235,
    this.height = 55,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.backgroundColor = AppColors.primaryColor,
    this.fontColor = AppColors.whiteColor,
    this.borderColor = Colors.transparent,
    this.borderRadius = 8, // Default border radius
    this.isBusy = false,
    this.icon = Icons.arrow_forward_outlined,
  });

  final String title;
  final Function onPressed;
  final double width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final Color backgroundColor;
  final Color fontColor;
  final IconData icon;
  final double borderRadius;
  final Color borderColor;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        height: height.sp,
        width: width.sp,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius.r),
          border: Border.all(color: borderColor, width: 1.sp),
          color: backgroundColor,
        ),
        child: isBusy
            ? Center(
          child: SizedBox(
            height: 25.sp,
            width: 25.sp,
            child: CircularProgressIndicator(color: fontColor),
          ),
        )
            : Center(
          child: customText(
            title,
            fontSize: fontSize.sp,
            color: fontColor,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}

class CustomGreenTextButton extends StatelessWidget {
  const CustomGreenTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.bgColor = AppColors.primaryColor,
    this.fontWeight = FontWeight.w500,
    this.borderRadius = 40, // Default border radius
    this.isLoading = false,
  });

  final String title;
  final Function onPressed;
  final Color bgColor;
  final FontWeight fontWeight;
  final double borderRadius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 8.sp),
        margin: EdgeInsets.all(5.sp),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
            height: 15.sp,
            width: 15.sp,
            child: CircularProgressIndicator(
              color: AppColors.whiteColor,
              strokeWidth: 1.5.sp,
            ),
          )
              : customText(
            title,
            color: AppColors.whiteColor,
            fontWeight: fontWeight,
            fontSize: 15.sp,
          ),
        ),
      ),
    );
  }
}