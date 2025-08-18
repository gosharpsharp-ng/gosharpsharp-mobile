import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gosharpsharp/core/utils/exports.dart';

class RatingBottomSheet extends StatelessWidget {
  const RatingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Form(
        key: ordersController.deliveryRatingFormKey,
        child: Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.h,
              ),
              customText(
                "Rate your experience!",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                color: AppColors.primaryColor,
                fontSize: 25.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                height: 5.h,
              ),
              customText(
                  "This information is important to us, we use it to create a better user experience for you",
                  overflow: TextOverflow.visible,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal),
              SizedBox(
                height: 20.h,
              ),
              RatingBar(
                initialRating: ordersController.rating,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(
                    Icons.star,
                    size: 15.sp,
                    color: AppColors.orangeColor,
                  ),
                  half: Icon(
                    Icons.star,
                    size: 15.sp,
                    color: AppColors.orangeColor.withOpacity(0.5),
                  ),
                  empty: Icon(
                    Icons.star,
                    size: 15.sp,
                    color: AppColors.obscureTextColor,
                  ),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.sp),
                onRatingUpdate: (rating) {
                  ordersController.setDeliveryRating(rating);
                },
              ),
              SizedBox(
                height: 16.h,
              ),
              CustomOutlinedRoundedInputField(
                maxLines: 3,
                hasTitle: true,
                title: "Your Review",
                controller: ordersController.ratingReviewController,
                isRequired: false,
              ),
              SizedBox(
                height: 16.h,
              ),
              CustomButton(
                onPressed: () async {
                  await ordersController.rateDelivery(context);
                },
                title: "Submit",
                isBusy: ordersController.ratingDelivery,
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      );
    });
  }
}
