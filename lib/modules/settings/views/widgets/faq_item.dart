import 'package:gosharpsharp/core/utils/exports.dart';

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  const FaqItem({super.key, this.question = "", this.answer = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.2), // Add bottom border
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Removes top and bottom borders
        ),
        child: ExpansionTile(
          expandedAlignment: Alignment.centerLeft,
          title: customText(question,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.start,
              fontSize: 15.sp,
              overflow: TextOverflow.visible),
          children: [
            Container(
              decoration: BoxDecoration(color: AppColors.backgroundColor),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: customText(answer,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.justify,
                  fontSize: 14.sp,
                  overflow: TextOverflow.visible),
            ),
          ],
        ),
      ),
    );
  }
}
