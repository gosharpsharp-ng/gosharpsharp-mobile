import 'package:gosharpsharp/core/utils/app_assets.dart';

class OnboardingContent {
  String image;
  String title;
  String desc;

  OnboardingContent({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContent> contents = [
  OnboardingContent(
    title: "All Your Favorite Food in One Place",
    desc: "Order from top restaurants and local eateries — all in one easy-to-use app.",
    image: PngAssets.onboardingOne,
  ),
  OnboardingContent(
    title: "Send Parcels and Foods Sharp Sharp",
    desc: "Fast, safe delivery for your food and parcels — anytime, anywhere.",
    image: PngAssets.onboardingTwo,
  ),
  OnboardingContent(
    title: "Smooth, Easy Order Tracking System",
    desc: "Track your order live and get updates from pickup to doorstep.",
    image: PngAssets.onboardingThree,
  ),
];
