import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/utils/widgets/base64_image.dart';
import 'package:gosharpsharp/modules/delivery/views/widgets/bike_and_payment_selection_bottomsheet.dart';
import 'package:gosharpsharp/modules/delivery/views/widgets/delivery_instructions_bottom_sheet.dart';
import 'package:intl_phone_field/phone_number.dart';

class InitiateDeliveryScreen extends StatelessWidget {
  const InitiateDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
      builder: (ordersController) {
        return Form(
          key: ordersController.sendingInfoFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Send a parcel",
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 12.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionBox(
                      children: [
                        CustomRoundedInputField(
                          title: "Sender's Name",
                          label: "Moses James",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          controller: ordersController.senderNameController,
                        ),
                        ClickableCustomRoundedInputField(
                          onPressed: () async {
                            final ItemLocation result = await Get.toNamed(
                              Routes.SELECT_LOCATION_SCREEN,
                            );
                            ordersController.setDeliverySenderLocation(result);
                            if (ordersController.deliveryReceiverLocation !=
                                null) {
                              await ordersController.getRideEstimatedDistance();
                            }
                          },
                          prefixWidget: IconButton(
                            onPressed: () async {
                              final ItemLocation result = await Get.toNamed(
                                Routes.SELECT_LOCATION_SCREEN,
                              );
                              ordersController.setDeliverySenderLocation(
                                result,
                              );
                              if (ordersController.deliveryReceiverLocation !=
                                  null) {
                                await ordersController
                                    .getRideEstimatedDistance();
                              }
                            },
                            icon: SvgPicture.asset(
                              SvgAssets.locationIcon,
                              // h: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          title: "Pick up address",
                          readOnly: true,
                          label: "Old Airport Roundabout",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          controller: ordersController.senderAddressController,
                        ),
                      ],
                    ),
                    SectionBox(
                      children: [
                        CustomRoundedInputField(
                          title: "Receiver's name",
                          label: "John Doyle",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          controller: ordersController.receiverNameController,
                        ),
                        CustomRoundedPhoneInputField(
                          title: "Phone number (required)",
                          label: "7061032122",
                          onChanged: (PhoneNumber phone) {
                            if (phone.number.isNotEmpty &&
                                phone.number.startsWith('0')) {
                              final updatedNumber = phone.number.replaceFirst(
                                RegExp(r'^0'),
                                '',
                              );
                              ordersController.receiverPhoneController.value =
                                  TextEditingValue(
                                    text: updatedNumber,
                                    selection: TextSelection.collapsed(
                                      offset: updatedNumber.length,
                                    ),
                                  );
                              ordersController.setReceiverPhoneNumber(
                                PhoneNumber(
                                  countryISOCode: phone.countryISOCode,
                                  countryCode: phone.countryCode,
                                  number: updatedNumber,
                                ),
                              );
                              ordersController.setFilledPhoneNumber(
                                PhoneNumber(
                                  countryISOCode: phone.countryISOCode,
                                  countryCode: phone.countryCode,
                                  number: updatedNumber,
                                ),
                              );
                            } else {
                              ordersController.setFilledPhoneNumber(phone);
                            }
                          },
                          keyboardType: TextInputType.phone,
                          validator: (phone) {
                            if (phone == null ||
                                phone.completeNumber.isEmpty ||
                                ordersController
                                    .receiverPhoneController
                                    .text
                                    .isEmpty) {
                              return "Phone number is required";
                            }
                            // Regex: `+` followed by 1 to 3 digits (country code), then 10 digits (phone number)
                            final regex = RegExp(r'^\+234[1-9]\d{9}$');
                            if (!regex.hasMatch(phone.completeNumber)) {
                              return "Phone number must be 10 digits long";
                            }
                            if (ordersController
                                    .receiverPhoneController
                                    .text
                                    .length ==
                                0) {
                              return "Phone number is required";
                            }
                            if (ordersController.filledPhoneNumber == null) {
                              return "Phone number is required";
                            }

                            return null; // Valid phone number
                          },
                          isPhone: true,
                          isRequired: true,
                          hasTitle: true,
                          controller: ordersController.receiverPhoneController,
                        ),
                        ClickableCustomRoundedInputField(
                          title: "Drop off address",
                          label: "Opp. New Government House Jos",
                          onPressed: () async {
                            final ItemLocation result = await Get.toNamed(
                              Routes.SELECT_LOCATION_SCREEN,
                            );
                            ordersController.setDeliveryReceiverLocation(
                              result,
                            );
                            if (ordersController.deliverySenderLocation !=
                                null) {
                              await ordersController.getRideEstimatedDistance();
                            }
                          },
                          prefixWidget: IconButton(
                            onPressed: () async {
                              final ItemLocation result = await Get.toNamed(
                                Routes.SELECT_LOCATION_SCREEN,
                              );
                              ordersController.setDeliveryReceiverLocation(
                                result,
                              );
                              if (ordersController.deliverySenderLocation !=
                                  null) {
                                await ordersController
                                    .getRideEstimatedDistance();
                              }
                            },
                            icon: SvgPicture.asset(
                              SvgAssets.locationIcon,
                              // h: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          showLabel: true,
                          readOnly: true,
                          hasTitle: true,
                          isRequired: true,
                          controller:
                              ordersController.receiverAddressController,
                        ),
                      ],
                    ),
                    SectionBox(
                      children: [
                        Row(
                          children: [
                            customText(
                              "Upload parcel image",
                              color: AppColors.blackColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(width: 3.w),
                            customText(
                              "(Required)",
                              color: AppColors.redColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
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
                                        pickFromCamera: true,
                                      );
                                    },
                                    selectFromGalleryFunction: () {
                                      ordersController.selectParcelImage(
                                        pickFromCamera: false,
                                      );
                                    },
                                    deleteFunction: () {},
                                  );
                                },
                              );
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
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.sp,
                                vertical: 20.h,
                              ),
                              child: ordersController.parcelImage != null
                                  ? Stack(
                                      children: [
                                        Positioned(
                                          bottom: 0,
                                          right: 2,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.backgroundColor,
                                            ),
                                            padding: EdgeInsets.all(8.sp),
                                            child: SvgPicture.asset(
                                              SvgAssets.cameraIcon,
                                              height: 30.sp,
                                              color: Colors.blue,
                                              width: 30.sp,
                                            ),
                                          ),
                                        ),
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
                                            color: AppColors.backgroundColor,
                                          ),
                                          padding: EdgeInsets.all(8.sp),
                                          child: SvgPicture.asset(
                                            SvgAssets.cameraIcon,
                                          ),
                                        ),
                                        customText(
                                          "Upload an image",
                                          color: AppColors.primaryColor,
                                          fontSize: 14.sp,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        customText(
                                          "Ensure the photo shows the item clearly",
                                          color: AppColors.blackColor,
                                          fontSize: 14.sp,
                                          overflow: TextOverflow.visible,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        customText(
                                          "(max 4mb)",
                                          color: AppColors.blackColor,
                                          fontSize: 14.sp,
                                          textAlign: TextAlign.center,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomRoundedInputField(
                          title: "Item name",
                          label: "Name of the item you're sending",
                          showLabel: true,
                          hasTitle: true,
                          isRequired: true,
                          controller:
                              ordersController.deliveryItemNameController,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CustomButton(
                        onPressed: () {
                          // Validate all fields including parcel image
                          if (ordersController.sendingInfoFormKey.currentState!
                                  .validate() &&
                              ordersController
                                  .receiverPhoneController
                                  .text
                                  .isNotEmpty) {
                            // Check if parcel image is uploaded
                            if (ordersController.parcelImage == null) {
                              showToast(
                                message: "Please upload a parcel image",
                                isError: true,
                              );
                              return;
                            }

                            // Check if item name is filled
                            if (ordersController
                                .deliveryItemNameController
                                .text
                                .isEmpty) {
                              showToast(
                                message: "Please enter the item name",
                                isError: true,
                              );
                              return;
                            }

                            // Show bike and payment selection bottomsheet
                            showAnyBottomSheet(
                              child: BikeAndPaymentSelectionBottomsheet(
                                onProceed: () {
                                  // Show delivery instructions bottomsheet after bike selection
                                  showAnyBottomSheet(
                                    child: DeliveryInstructionsBottomSheet(
                                      onContinue: () {
                                        // TODO: Submit the delivery
                                        showToast(
                                          message:
                                              "Delivery submitted successfully!",
                                          isError: false,
                                        );
                                        Get.back(); // Return to landing/dashboard
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                        title: "Proceed",
                        width: 1.sw,
                        backgroundColor: AppColors.primaryColor,
                        fontColor: AppColors.whiteColor,
                      ),
                    ),
                    SizedBox(height: 15.h),
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
