import '../../../../core/utils/exports.dart';

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, this.question = "", this.answer = ""});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: _isExpanded
            ? AppColors.primaryColor.withOpacity(
                0.1,
              ) // Expanded background color
            : AppColors.backgroundColor,
        border: Border.all(
          color: _isExpanded
              ? AppColors.primaryColor.withAlpha(
                  80,
                ) // Expanded background color
              : AppColors.greenColor,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Removes top and bottom borders
        ),
        child: ExpansionTile(
          expandedAlignment: Alignment.centerLeft,
          iconColor: AppColors.primaryColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                widget.question,
                fontWeight: FontWeight.w600,
                textAlign: TextAlign.start,
                fontSize: 15.sp,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Divider(
                    color: AppColors.primaryColor.withOpacity(0.4),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                    bottom: 5.h,
                  ),
                  child: customText(
                    widget.answer,
                    fontWeight: FontWeight.normal,
                    textAlign: TextAlign.justify,
                    fontSize: 14.sp,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
