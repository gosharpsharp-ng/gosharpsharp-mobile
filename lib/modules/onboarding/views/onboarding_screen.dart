import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/onboarding/widgets/onbaording_content.dart'
    show contents;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    show AnimatedSmoothIndicator, ExpandingDotsEffect;

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (onboardingController) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.transparent,
            elevation: 0,
            systemOverlayStyle:
                SystemUiOverlayStyle.dark, // For light status bar text
          ),
          body: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              height: 1.sh,
              width: 1.sw,
              padding: EdgeInsets.only(top: 0.h),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(PngAssets.lightWatermark),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: PageView.builder(
                      controller: onboardingController.pageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: contents.length,
                      onPageChanged: (int index) {
                        onboardingController.nextIndex(index);
                      },
                      itemBuilder: (_, i) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            bool isTablet = constraints.maxWidth > 600;
                            int imageFlex = isTablet ? 5 : 4;
                            int textFlex = isTablet ? 2 : 2;
                            double titleFontSize = isTablet ? 24.sp : 24.sp;
                            double descFontSize = isTablet ? 18.sp : 16.sp;
                            double spacing = isTablet ? 10.sp : 10.sp;
                            BoxFit imageFit = isTablet ? BoxFit.cover : BoxFit.cover;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: imageFlex,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      top: 15.sp,
                                      bottom: isTablet ? 30.sp : 15.sp,
                                      left: 0.sp,
                                      right: 0.sp,
                                    ),
                                    child: Container(
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(contents[i].image),
                                          fit: imageFit,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: isTablet?5.sp:25.sp),
                                Expanded(
                                  flex: textFlex,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.sp,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        customText(
                                          contents[i].title,
                                          textAlign: TextAlign.center,
                                          fontSize: titleFontSize,
                                          fontWeight: FontWeight.w600,
                                          overflow: TextOverflow.visible,
                                        ),
                                        SizedBox(height: spacing),
                                        customText(
                                          contents[i].desc,
                                          textAlign: TextAlign.center,
                                          fontSize: descFontSize,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: 1.sw,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(PngAssets.lightWatermark),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          bool isTablet = constraints.maxWidth > 600;
                          double buttonHeight = isTablet ? 58.h : 56.h;
                          double buttonFontSize = isTablet ? 17.sp : 16.sp;
                          double skipFontSize = isTablet ? 17.sp : 16.sp;
                          return Column(
                            children: [
                              SizedBox(
                                child: AnimatedSmoothIndicator(
                                  activeIndex:
                                      onboardingController.currentPageIndex,
                                  count: 3,
                                  effect: ExpandingDotsEffect(
                                    activeDotColor: AppColors.primaryColor,
                                    dotColor: AppColors.obscureTextColor,
                                    dotWidth: 8.sp,
                                    dotHeight: 8.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.sp),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: CustomButton(
                                  borderRadius: 16.r,
                                  onPressed: () {
                                    if (onboardingController.currentPageIndex !=
                                        contents.length - 1) {
                                      onboardingController.autoNextIndex();
                                    } else {
                                      Get.toNamed(Routes.SIGN_IN);
                                    }
                                  },
                                  width: 1.sw * 0.80,
                                  height: buttonHeight,
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w600,
                                  title:
                                      onboardingController.currentPageIndex !=
                                          contents.length - 1
                                      ? "Next"
                                      : "Continue",
                                  backgroundColor: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 12.sp),
                              Visibility(
                                visible:
                                    onboardingController.currentPageIndex !=
                                    contents.length - 1,
                                replacement: SizedBox(height: 19.sp),
                                child: InkWell(
                                  onTap: () {
                                    onboardingController.moveToLastIndex();
                                  },
                                  child: customText(
                                    "Skip",
                                    textAlign: TextAlign.center,
                                    fontSize: skipFontSize,
                                    color: AppColors.primaryColor,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
