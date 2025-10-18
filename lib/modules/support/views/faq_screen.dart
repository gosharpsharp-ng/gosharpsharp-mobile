import 'package:gosharpsharp/core/widgets/skeleton_loaders.dart';
import 'package:gosharpsharp/modules/support/controllers/support_controller.dart';
import 'package:gosharpsharp/modules/support/views/widgets/faq_category_chip.dart';

import '../../../core/utils/exports.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportController>(
      builder: (supportController) {
        return Scaffold(
          appBar: defaultAppBar(bgColor: AppColors.backgroundColor,title: "Faqs"),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      ...List.generate(
                        supportController.faqs.length,
                        (i) => FaqCategoryChip(
                          value: supportController.faqs[i].name,
                          isSelected:
                              supportController.faqs[i] ==
                              supportController.selectedFaq,
                          onSelected: () {
                            supportController.setSelectedFaq(
                              faq: supportController.faqs[i],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    mainAxisAlignment: supportController.fetchingFaqs
                        ? MainAxisAlignment.center
                        : (supportController.faqs.isNotEmpty
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center),
                    children: [
                      if (supportController.fetchingFaqs)
                        SkeletonLoaders.faqItem(count: 6)
                      else if (supportController.faqs.isEmpty)
                        const Center(
                          child: Text(
                            "No FAQs available",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      else
                        ...List.generate(
                          supportController.selectedFaq?.faqs.length ?? 0,
                          (i) => FaqItem(
                            question:
                                supportController
                                    .selectedFaq
                                    ?.faqs[i]
                                    .question ??
                                "",
                            answer:
                                supportController.selectedFaq?.faqs[i].answer ??
                                "",
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 15.sp),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
