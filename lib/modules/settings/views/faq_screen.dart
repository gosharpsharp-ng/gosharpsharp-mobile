

import 'package:gosharpsharp/core/utils/exports.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(bgColor: AppColors.backgroundColor, title: "FAQ"),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 0.w,
        ),
        child: SingleChildScrollView(
          child: SectionBox(
            children: const [
              FaqItem(
                question: "How do I earn rewards, and how can I redeem them?",
                answer:
                    "After logging in, navigate to the 'Available tasks' section on the homepage. Select a task, review the requirements, and fill out the submission form with accurate details about the service. Ensure all mandatory fields are completed before submitting.",
              ),
              FaqItem(
                question: "Why is my BVN required for account verification?",
                answer:
                    "After logging in, navigate to the 'Available tasks' section on the homepage. Select a task, review the requirements, and fill out the submission form with accurate details about the service. Ensure all mandatory fields are completed before submitting.",
              ),
              FaqItem(
                question:
                    "How can I update my profile or change my account settings?",
                answer:
                    "After logging in, navigate to the 'Available tasks' section on the homepage. Select a task, review the requirements, and fill out the submission form with accurate details about the service. Ensure all mandatory fields are completed before submitting.",
              ),    FaqItem(
                question: "How do I earn rewards, and how can I redeem them?",
                answer:
                    "After logging in, navigate to the 'Available tasks' section on the homepage. Select a task, review the requirements, and fill out the submission form with accurate details about the service. Ensure all mandatory fields are completed before submitting.",
              ),
              FaqItem(
                question: "Why is my BVN required for account verification?",
                answer:
                    "After logging in, navigate to the 'Available tasks' section on the homepage. Select a task, review the requirements, and fill out the submission form with accurate details about the service. Ensure all mandatory fields are completed before submitting.",
              ),
              FaqItem(
                question:
                    "How can I update my profile or change my account settings?",
                answer:
                    "After logging in, navigate to the 'Available tasks' section on the homepage. Select a task, review the requirements, and fill out the submission form with accurate details about the service. Ensure all mandatory fields are completed before submitting.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
