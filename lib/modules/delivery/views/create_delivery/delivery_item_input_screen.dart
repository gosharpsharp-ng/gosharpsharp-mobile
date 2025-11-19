import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/utils/widgets/base64_image.dart';

class DeliveryItemInputScreen extends StatelessWidget {
  const DeliveryItemInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Form(
        key: ordersController.itemDetailsFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor, title: "Item details"),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 3.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visibility(
                  //   visible: ordersController.shipmentItems.isNotEmpty,
                  //   child: SingleChildScrollView(
                  //     padding: EdgeInsets.symmetric(horizontal: 8.w),
                  //     scrollDirection: Axis.horizontal,
                  //     child: Row(
                  //       children: [
                  //         ...List.generate(
                  //           ordersController.shipmentItems.length,
                  //           (index) => Container(
                  //             margin: EdgeInsets.symmetric(
                  //                 horizontal: 4.sp, vertical: 5.sp),
                  //             child: Column(
                  //               children: [
                  //                 Container(
                  //                   width: 75.sp,
                  //                   height: 65.sp,
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(12.r),
                  //                     image: DecorationImage(
                  //                       image: base64ToMemoryImage(
                  //                         ordersController.shipmentItems[index]
                  //                             .image,
                  //                       ),
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                   ),
                  //                   child: SizedBox.shrink(),
                  //                 ),
                  //                 customText(
                  //                     ordersController
                  //                         .shipmentItems[index].name,
                  //                     color: AppColors.primaryColor,
                  //                     fontSize: 14.sp,fontWeight: FontWeight.w500)
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 20.sp),
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            customText("Upload an image",
                                color: AppColors.blackColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                            SizedBox(
                              width: 3.w,
                            ),
                            customText(
                              "(Optional)",
                              color: AppColors.greyColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 8.h,
                        ),
                        CustomPaint(
                          painter: DottedBorderPainter(),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return CustomImagePickerBottomSheet(
                                      title: "Parcel Image",
                                      takePhotoFunction: () {
                                        ordersController.selectParcelImage(
                                            pickFromCamera: true);
                                      },
                                      selectFromGalleryFunction: () {
                                        ordersController.selectParcelImage(
                                            pickFromCamera: false);
                                      },
                                      deleteFunction: () {},
                                    );
                                  });
                            },
                            child: Container(
                              width: 1.sw,
                              height: 170.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: ordersController.parcelImage != null
                                      ? DecorationImage(
                                          image: base64ToMemoryImage(
                                            ordersController.parcelImage!,
                                          ),
                                          fit: BoxFit.cover)
                                      : null),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.sp, vertical: 20.h),
                              child: ordersController.parcelImage != null
                                  ? Stack(
                                      children: [
                                        Positioned(
                                          bottom: 0,
                                          right: 2,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    AppColors.backgroundColor),
                                            padding: EdgeInsets.all(8.sp),
                                            child: SvgPicture.asset(
                                              SvgAssets.cameraIcon,
                                              height: 30.sp,
                                              color: Colors.blue,
                                              width: 30.sp,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.backgroundColor),
                                          padding: EdgeInsets.all(8.sp),
                                          child: SvgPicture.asset(
                                              SvgAssets.cameraIcon),
                                        ),
                                        customText("Upload an image",
                                            color: AppColors.primaryColor,
                                            fontSize: 14.sp,
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.w500),
                                        customText(
                                            "Ensure the photo shows the item clearly",
                                            color: AppColors.blackColor,
                                            fontSize: 14.sp,
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.normal),
                                        customText("(max 4mb)",
                                            color: AppColors.blackColor,
                                            fontSize: 14.sp,
                                            textAlign: TextAlign.center,
                                            fontWeight: FontWeight.normal),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        CustomRoundedInputField(
                          title: "Item name",
                          label: "Name of the item you're sending",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          controller:
                              ordersController.deliveryItemNameController,
                        ),
                        ClickableCustomRoundedInputField(
                          title: "Category",
                          label: "Non-fragile",
                          readOnly: true,
                          showLabel: true,
                          hasTitle: true,
                          onPressed: () {
                            showAnyBottomSheet(
                                child: const ParcelCategoryBottomSheet());
                          },
                          isRequired: true,
                          controller:
                              ordersController.deliveryItemCategoryController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              showAnyBottomSheet(
                                  child: const ParcelCategoryBottomSheet());
                            },
                            icon: SvgPicture.asset(
                              SvgAssets.downChevronIcon,
                              // h: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        CustomRoundedInputField(
                          title: "Quantity",
                          label: "1",
                          showLabel: true,
                          hasTitle: true,
                          keyboardType: TextInputType.number,
                          isRequired: true,
                          controller:
                              ordersController.deliveryItemQuantityController,
                          // controller: signInProvider.emailController,
                        ),
                        SizedBox(
                          height: 15.sp,
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     ordersController.addShipmentItem();
                        //   },
                        //   child: Row(
                        //     children: [
                        //       Icon(
                        //         Icons.add,
                        //         size: 25.sp,
                        //         color: AppColors.primaryColor,
                        //       ),
                        //       SizedBox(
                        //         width: 5.sp,
                        //       ),
                        //       customText("Add another item",
                        //           color: AppColors.primaryColor,
                        //           fontSize: 18.sp,
                        //           fontWeight: FontWeight.w500),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 15.sp,
                        // ),
                        // CustomButton(
                        //   onPressed: () {
                        //     Get.back();
                        //   },
                        //   backgroundColor: AppColors.fadedButtonPrimaryColor,
                        //   title: "Previous",
                        //   fontColor: AppColors.primaryColor,
                        //   width: double.infinity,
                        // ),
                        // SizedBox(
                        //   height: 10.h,
                        // ),
                        CustomButton(
                          onPressed: () {
                            ordersController.continueDelivery();
                          },
                          isBusy: ordersController.submittingDelivery,
                          title: "Continue",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
