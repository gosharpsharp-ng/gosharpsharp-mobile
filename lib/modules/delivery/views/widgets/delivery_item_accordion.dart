import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/utils/widgets/base64_image.dart';

class DeliveryItemAccordion extends StatelessWidget {
  final DeliveryItemData shipmentItemData;
  const DeliveryItemAccordion({super.key, required this.shipmentItemData});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(vertical: 5.sp),
        child: Theme(
          data: Theme.of(context).copyWith(
            expansionTileTheme: const ExpansionTileThemeData(
              backgroundColor:
                  AppColors.whiteColor, // Blue background for expanded state
              collapsedBackgroundColor:
                  AppColors.whiteColor, // Blue background for collapsed state
              iconColor: AppColors.blackColor, // Icon color for contrast
              collapsedIconColor: AppColors.blackColor,
            ),
          ),
          child: ExpansionTile(
            backgroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(), // No border when expanded
            collapsedShape: RoundedRectangleBorder(),
            tilePadding: EdgeInsets.symmetric(horizontal: 8.sp),
            title: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(shipmentItemData.name,
                      fontWeight: FontWeight.w500, fontSize: 14.sp),
                ],
              ),
            ),
            children: [
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                      image: base64ToMemoryImage(shipmentItemData.image,),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: 1.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    DeliverySummaryDetailItem(
                        isVertical: false,
                        title: "Category",
                        value: shipmentItemData.category),
                    DeliverySummaryDetailItem(
                        isVertical: false,
                        title: "Quantity",
                        value: shipmentItemData.quantity.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        EditIcon(onPressed: () {
                          Get.back();
                        }),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class OrderItemSummaryAccordion extends StatelessWidget {
  final Item shipmentItemData;
  const OrderItemSummaryAccordion({super.key, required this.shipmentItemData});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.symmetric(vertical: 5.sp),
        child: Theme(
          data: Theme.of(context).copyWith(
            expansionTileTheme: const ExpansionTileThemeData(
              backgroundColor:
              AppColors.whiteColor, // Blue background for expanded state
              collapsedBackgroundColor:
              AppColors.whiteColor, // Blue background for collapsed state
              iconColor: AppColors.blackColor, // Icon color for contrast
              collapsedIconColor: AppColors.blackColor,
            ),
          ),
          child: ExpansionTile(
            backgroundColor: AppColors.whiteColor,
            shape: RoundedRectangleBorder(), // No border when expanded
            collapsedShape: RoundedRectangleBorder(),
            tilePadding: EdgeInsets.symmetric(horizontal: 8.sp),
            title: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(shipmentItemData.name,
                      fontWeight: FontWeight.w500, fontSize: 14.sp),
                ],
              ),
            ),
            children: [
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                      image: base64ToMemoryImage(shipmentItemData.image,),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: 1.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    DeliverySummaryDetailItem(
                        isVertical: false,
                        title: "Category",
                        value: shipmentItemData.category),
                    DeliverySummaryDetailItem(
                        isVertical: false,
                        title: "Quantity",
                        value: shipmentItemData.quantity.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        EditIcon(onPressed: () {}),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
