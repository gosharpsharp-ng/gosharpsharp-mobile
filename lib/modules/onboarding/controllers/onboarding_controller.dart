import 'package:gosharpsharp/core/utils/exports.dart';

class OnboardingController extends GetxController {
  var pageController = PageController();
  // int ImageSliderIndex = 0;
  int currentPageIndex = 0;
  void nextIndex(int index) {
    currentPageIndex = index;
    update();
  }

  void autoNextIndex() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
    currentPageIndex = pageController.page!.toInt();
    update();
  }

  void moveToLastIndex() {
    int lastIndex = (pageController.positions.isNotEmpty)
        ? pageController.positions.first.maxScrollExtent ~/
        pageController.position.viewportDimension
        : 0; // Fallback if the page isn't fully built yet

    pageController.animateToPage(
      lastIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    currentPageIndex = lastIndex;
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pageController = PageController();
  }
}