import 'package:gosharpsharp/core/utils/exports.dart';

class ParcelCategoryBottomSheet extends StatelessWidget {
  const ParcelCategoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Container(
        height: 1.sh * 0.52,
        margin: EdgeInsets.only(top: 5.sp),
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 5.sp),
        child: Column(
          children: [
            customText("Select Item Category",
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: AppColors.primaryColor),
            Container(
              height: 1.sh * 0.46,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      ordersController.parcelCategories.length,
                      (index) => InkWell(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 2.sp),
                              height: 45.sp,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.sp, vertical: 6.sp),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: customText(
                                        ordersController
                                            .parcelCategories[index].capitalizeFirst!,
                                        fontSize: 18.sp,
                                        color: ordersController
                                                    .parcelCategories[index] ==
                                                ordersController
                                                    .deliveryItemCategoryController
                                                    .text
                                            ? AppColors.primaryColor
                                            : AppColors.blackColor),
                                  ),
                                  ordersController.parcelCategories[index] ==
                                          ordersController
                                              .deliveryItemCategoryController
                                              .text
                                      ? Icon(
                                          Icons.check_circle_outline,
                                          color: AppColors.primaryColor,
                                          size: 20.sp,
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                            Divider(
                              color: AppColors.primaryColor.withOpacity(0.1),
                            )
                          ],
                        ),
                        onTap: () {
                          ordersController.setDeliveryItemCategory(
                              ordersController.parcelCategories[index]);
                          Get.back();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
