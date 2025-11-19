import 'package:flutter/gestures.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryInstructionsBottomSheet extends StatelessWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onTermsSelected;
  final bool isLoading;

  const DeliveryInstructionsBottomSheet({
    super.key,
    this.onContinue,
    this.onTermsSelected,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: customText(
              "Delivery Instructions",
              color: AppColors.blackColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(height: 16.h),
          customText(
            "Dear Esteem customer Remember to always share delivery details with your recipient and always make sure your package:",
            color: AppColors.blackColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.visible,
          ),
          SizedBox(height: 12.h),
          // Instruction List
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInstructionItem(
                "Is given by you in person to the rider at the designated location.",
              ),
              _buildInstructionItem(
                " Is picked up by the recipient at the designated location.",
              ),
              _buildInstructionItem(
                " Is packed into a box, bag or envelope properly.",
              ),
              _buildInstructionItem(
                "Fits easily in the box and won't damage it.",
              ),
              _buildInstructionItem(
                "Does not contain prohibited items prohibited under the law",
              ),
              _buildInstructionItem("Items should not be above 20kg"),
              _buildInstructionItem(
                hasCurrency: true,
                "Items should not exceed the permitted goods value of ₦50,000 (Fifty thousand naira).",
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "By using continuing, you agree to our ",
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 13.sp,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.visible,
                ),
                children: [
                  TextSpan(
                    text: "terms and local regulations",
                    style: TextStyle(
                      color: AppColors
                          .primaryColor, // Highlight color for clickable text
                      decoration: TextDecoration.underline,
                      fontSize: 13.sp,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.visible, // Optional underline
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                  const TextSpan(text: "."),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  width: 1.sw,
                  height: 55.h,
                  onPressed: () {
                    Get.back();
                    onContinue!();
                  },
                  isBusy: isLoading,
                  title: "Ok",
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildInstructionItem(String text, {bool hasCurrency = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check, color: AppColors.primaryColor, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: customText(
              text,
              color: AppColors.blackColor,
              fontSize: hasCurrency ? 14.sp : 15.sp,
              fontStyle: GoogleFonts.inter().fontStyle,
              fontWeight: hasCurrency ? FontWeight.w600 : FontWeight.w500,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
