import 'package:gosharpsharp/core/utils/exports.dart';

class SearchDeliveriesScreen extends StatelessWidget {
  const SearchDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Form(
        key: ordersController.deliveriesSearchFormKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.h),
          height: 1.sh,
          width: 1.sw,
          color: AppColors.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                CustomOutlinedRoundedInputField(
                  label: "Enter query e.g: Xd391B",
                  autoFocus: true,
                  isSearch: true,
                  color: AppColors.obscureTextColor,
                  hasTitle: true,
                  prefixWidget: Container(
                      padding: EdgeInsets.all(12.sp),
                      child: SvgPicture.asset(
                        SvgAssets.searchIcon,
                      )),
                  suffixWidget: CustomGreenTextButton(
                    title: "Go",
                    isLoading: ordersController.searchingDeliveries,
                    onPressed: () {
                      ordersController.searchDeliveries();
                    },
                  ),
                  // controller: signInProvider.emailController,
                ),
                SizedBox(
                  height: 15.h,
                ),
                const SectionHeader(
                  title: "Results",
                ),
                SizedBox(
                  height: 10.h,
                ),
                ordersController.deliverySearchResults.isEmpty
                    ? Container(
                        width: 1.sw,
                        height: 1.sh * 0.85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText(
                              ordersController.searchingDeliveries
                                  ? "Loading..."
                                  : "Enter your search query above",
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 1.sw,
                        height: 1.sh * 0.85,
                        child: SingleChildScrollView(
                          controller:
                              ordersController.searchDeliveriesScrollController,
                          child: Column(children: [
                            ...List.generate(
                              ordersController.deliverySearchResults.length,
                              (i) => DeliveryItemWidget(
                                onSelected: () {
                                  ordersController.setSelectedDelivery(
                                      ordersController
                                          .deliverySearchResults[i]);
                                  Get.toNamed(
                                      Routes.PROCESSED_DELIVERY_SUMMARY_SCREEN);
                                },
                                delivery:
                                    ordersController.deliverySearchResults[i],
                              ),
                            ),
                            Visibility(
                              visible: ordersController.searchingDeliveries &&
                                  ordersController
                                      .deliverySearchResults.isNotEmpty,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: customText("Loading more...",
                                      color: AppColors.blueColor),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: ordersController.allDeliveries.length ==
                                  ordersController.totalDeliveries,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: customText("No more data to load",
                                      color: AppColors.blueColor),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                SizedBox(
                  height: 3.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
