import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        builder: (splashController){
        return Scaffold(
          backgroundColor: AppColors.fadedPrimaryColor,
          appBar: flatAppBar(
              bgColor: AppColors.fadedPrimaryColor,
              navigationColor: AppColors.fadedPrimaryColor),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(PngAssets.lightWatermark),fit: BoxFit.cover)
            ),
            height: 1.sh,
            width: 1.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 4,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(PngAssets.goSharpSharpTextLogo),
                      ],
                    ),
                  ),
                ),
                Lottie.asset(
                  'assets/json/loading.json',
                  width: 40,
                  height: 40,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: 80.sp,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  }




