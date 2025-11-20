import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/widgets/animated_star_rating.dart';

class DeliveryInvoiceDetailsScreen extends StatelessWidget {
  const DeliveryInvoiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
      builder: (ordersController) {
        return Form(
          // key: signInProvider.signInFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Order Invoice",
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SectionBox(
                      children: [
                        DeliveryInvoiceSummaryItem(
                          title: "Delivery Fee",
                          value: formatToCurrency(
                            double.parse(
                              ordersController.selectedDelivery?.cost ?? "0.0",
                            ),
                          ),
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Tracking number",
                          value: ordersController.selectedDelivery!.trackingId,
                        ),
                        const DeliveryInvoiceSummaryItem(
                          title: "Payment Method",
                          value: "GoWallet",
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Date",
                          value:
                              "${formatDate(ordersController.selectedDelivery!.createdAt)} ${formatTime(ordersController.selectedDelivery!.createdAt)} ",
                        ),
                        OrderInvoiceSummaryStatusItem(
                          title: "Status",
                          value:
                              ordersController.selectedDelivery?.status ?? "",
                        ),
                        if (ordersController.selectedDelivery?.deliveryCode != null &&
                            ordersController.selectedDelivery!.deliveryCode!.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(top: 12.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withAlpha(26),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.primaryColor.withAlpha(100),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.verified_user_rounded,
                                      color: AppColors.primaryColor,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    customText(
                                      "Delivery Verification Code",
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customText(
                                        ordersController.selectedDelivery!.deliveryCode!,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                        letterSpacing: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: AppColors.greyColor,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: customText(
                                        "Show this code to the rider to confirm delivery of your parcel",
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.greyColor,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        SizedBox(width: 12.w),
                        customText(
                          "Delivery Items",
                          color: AppColors.blackColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    ...List.generate(
                      ordersController.selectedDelivery!.items.length,
                      (i) => SectionBox(
                        children: [
                          Row(
                            children: [
                              customText(
                                "Item ${(i + 1).toString()}",
                                color: AppColors.blackColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                              ),
                              SizedBox(height: 8.h),
                            ],
                          ),
                          DeliveryInvoiceSummaryItem(
                            title: "Name",
                            value:
                                ordersController
                                    .selectedDelivery
                                    ?.items[i]
                                    .name ??
                                "",
                          ),
                          DeliveryInvoiceSummaryItem(
                            title: "Item category",
                            value:
                                ordersController
                                    .selectedDelivery
                                    ?.items[i]
                                    .category ??
                                "",
                          ),
                          DeliveryInvoiceSummaryItem(
                            title: "Quantity",
                            value:
                                ordersController
                                    .selectedDelivery
                                    ?.items[i]
                                    .quantity
                                    .toString() ??
                                "",
                          ),
                        ],
                      ),
                    ),
                    SectionBox(
                      children: [
                        DeliveryInvoiceSummaryItem(
                          title: "Sender's Name",
                          value:
                              "${ordersController.selectedDelivery?.sender?.firstName ?? ''} ${ordersController.selectedDelivery?.sender?.lastName ?? ''}",
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Phone Number",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.sender
                                  ?.phone ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Email",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.sender
                                  ?.email ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Address",
                          isVertical: true,
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.pickUpLocation
                                  ?.name ??
                              '',
                        ),
                      ],
                    ),
                    SectionBox(
                      children: [
                        DeliveryInvoiceSummaryItem(
                          title: "Receiver's Name",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.receiver
                                  .name ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Phone Number",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.receiver
                                  .phone ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Email",
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.receiver
                                  .email ??
                              '',
                        ),
                        DeliveryInvoiceSummaryItem(
                          title: "Address",
                          isVertical: true,
                          value:
                              ordersController
                                  .selectedDelivery
                                  ?.destinationLocation
                                  .name ??
                              '',
                        ),
                      ],
                    ),

                    SizedBox(height: 12.h),

                    // Rating Section - show only when status is delivered and not yet rated
                    if (ordersController.selectedDelivery != null &&
                        ordersController.selectedDelivery!.status != null &&
                        ordersController.selectedDelivery!.status!.toLowerCase() == 'delivered' &&
                        ordersController.selectedDelivery!.rating == null)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.greyColor.withAlpha(50),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star_rounded,
                                  color: AppColors.primaryColor,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                customText(
                                  "Rate your rider",
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            AnimatedStarRating(
                              onRatingSelected: (rating) {
                                ordersController.setDeliveryRating(rating.toDouble());
                              },
                            ),
                            SizedBox(height: 16.h),
                            CustomButton(
                              title: 'Submit Rating',
                              backgroundColor: AppColors.primaryColor,
                              fontColor: AppColors.whiteColor,
                              width: double.infinity,
                              height: 45,
                              fontSize: 14,
                              isBusy: ordersController.ratingDelivery,
                              onPressed: () {
                                if (ordersController.rating > 0) {
                                  ordersController.rateDelivery(context);
                                } else {
                                  ModernSnackBar.showInfo(
                                    context,
                                    message: "Please select a rating",
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 12.h),

                    // Track Delivery Button - show for all statuses except cancelled
                    if (ordersController.selectedDelivery != null &&
                        ordersController.selectedDelivery!.status != null &&
                        !['cancelled', 'rejected', 'delivered'].contains(
                            ordersController.selectedDelivery!.status!.toLowerCase()))
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomButton(
                          title: 'Track Delivery',
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                          width: double.infinity,
                          height: 50,
                          fontSize: 16,
                          onPressed: () {
                            // Navigate to delivery tracking screen (map-based)
                            Get.toNamed(Routes.DELIVERY_TRACKING_SCREEN);
                          },
                        ),
                      ),

                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
