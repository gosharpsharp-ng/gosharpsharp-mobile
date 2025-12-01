import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/core/utils/widgets/base64_image.dart';
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
              onPop: () {
                // Ensure we can navigate back properly
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  // Fallback to app navigation if no route to pop
                  Get.offAllNamed(Routes.APP_NAVIGATION);
                }
              },
            ),
            backgroundColor: AppColors.backgroundColor,
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pick Up Section
                  _buildSectionHeader(
                    icon: Icons.electric_bike,
                    title: "Pick Up",
                  ),
                  SizedBox(height: 8.h),
                  _buildLocationSelector(
                    label: "Pick up location",
                    address: ordersController.senderAddressController.text,
                    onTap: () async {
                      final ItemLocation result = await Get.toNamed(
                        Routes.SELECT_LOCATION_SCREEN,
                      );
                      ordersController.setDeliverySenderLocation(result);
                      if (ordersController.deliveryReceiverLocation != null) {
                        await ordersController.getRideEstimatedDistance();
                      }
                    },
                  ),

                  SizedBox(height: 20.h),

                  // Drop Off Section
                  _buildSectionHeader(
                    icon: Icons.location_on,
                    title: "Drop Off",
                  ),
                  SizedBox(height: 8.h),
                  _buildLocationSelector(
                    label: "Drop off location",
                    address: ordersController.receiverAddressController.text,
                    onTap: () async {
                      final ItemLocation result = await Get.toNamed(
                        Routes.SELECT_LOCATION_SCREEN,
                      );
                      ordersController.setDeliveryReceiverLocation(result);
                      if (ordersController.deliverySenderLocation != null) {
                        await ordersController.getRideEstimatedDistance();
                      }
                    },
                  ),

                  SizedBox(height: 16.h),

                  // Receiver Details
                  CustomRoundedInputField(
                    title: "Receiver's name",
                    label: "Enter receiver's name",
                    showLabel: true,
                    hasTitle: true,
                    isRequired: true,
                    controller: ordersController.receiverNameController,
                  ),
                  CustomRoundedPhoneInputField(
                    title: "Receiver's phone",
                    label: "8012345678",
                    onChanged: (PhoneNumber phone) {
                      String cleanedNumber = phone.number.replaceAll(' ', '');
                      if (cleanedNumber.isNotEmpty && cleanedNumber.startsWith('0')) {
                        cleanedNumber = cleanedNumber.replaceFirst(RegExp(r'^0'), '');
                      }
                      if (cleanedNumber != phone.number) {
                        ordersController.receiverPhoneController.value =
                            TextEditingValue(
                          text: cleanedNumber,
                          selection: TextSelection.collapsed(
                            offset: cleanedNumber.length,
                          ),
                        );
                        ordersController.setReceiverPhoneNumber(
                          PhoneNumber(
                            countryISOCode: phone.countryISOCode,
                            countryCode: phone.countryCode,
                            number: cleanedNumber,
                          ),
                        );
                        ordersController.setFilledPhoneNumber(
                          PhoneNumber(
                            countryISOCode: phone.countryISOCode,
                            countryCode: phone.countryCode,
                            number: cleanedNumber,
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
                          ordersController.receiverPhoneController.text.isEmpty) {
                        return "Phone number is required";
                      }
                      final regex = RegExp(r'^\+234[1-9]\d{9}$');
                      if (!regex.hasMatch(phone.completeNumber)) {
                        return "Enter a valid 10-digit phone number";
                      }
                      return null;
                    },
                    isPhone: true,
                    isRequired: true,
                    hasTitle: true,
                    controller: ordersController.receiverPhoneController,
                  ),

                  SizedBox(height: 20.h),

                  // Parcel Details Section
                  _buildSectionHeader(
                    icon: Icons.inventory_2_outlined,
                    title: "Parcel Details",
                  ),
                  SizedBox(height: 8.h),

                  // Image upload - compact version
                  _buildImageUploader(context, ordersController),

                  SizedBox(height: 12.h),

                  CustomRoundedInputField(
                    title: "Description",
                    label: "Describe the item you're sending (optional)",
                    showLabel: true,
                    hasTitle: false,
                    isRequired: false,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    controller: ordersController.deliveryItemDescriptionController,
                  ),

                  SizedBox(height: 24.h),

                  // Submit Button
                  CustomButton(
                    onPressed: () {
                      // Remove focus from all fields and dismiss keyboard
                      FocusScope.of(context).unfocus();

                      if (ordersController.sendingInfoFormKey.currentState!.validate() &&
                          ordersController.receiverPhoneController.text.isNotEmpty) {
                        // Small delay to allow keyboard to dismiss before showing bottom sheet
                        Future.delayed(const Duration(milliseconds: 100), () {
                          showAnyBottomSheet(
                            child: DeliveryInstructionsBottomSheet(
                              onContinue: () {
                                ordersController.callDeliveryEndpoint(context);
                              },
                              isLoading: ordersController.submittingDelivery,
                            ),
                          );
                        });
                      }
                    },
                    title: "Proceed",
                    isBusy: ordersController.submittingDelivery,
                    width: double.infinity,
                    backgroundColor: AppColors.primaryColor,
                    fontColor: AppColors.whiteColor,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 18.sp),
        SizedBox(width: 6.w),
        customText(
          title,
          color: AppColors.blackColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildLocationSelector({
    required String label,
    required String address,
    required VoidCallback onTap,
  }) {
    final hasAddress = address.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: hasAddress
                ? AppColors.primaryColor.withValues(alpha: 0.3)
                : AppColors.greyColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: customText(
                hasAddress ? address : "Tap to select $label",
                color: hasAddress ? AppColors.blackColor : AppColors.greyColor,
                fontSize: 14.sp,
                fontWeight: hasAddress ? FontWeight.w500 : FontWeight.normal,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.greyColor,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader(
    BuildContext context,
    DeliveriesController ordersController,
  ) {
    return CustomPaint(
      painter: DottedBorderPainter(),
      child: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            builder: (context) => CustomImagePickerBottomSheet(
              title: "Parcel Image",
              takePhotoFunction: () {
                ordersController.selectParcelImage(pickFromCamera: true);
              },
              selectFromGalleryFunction: () {
                ordersController.selectParcelImage(pickFromCamera: false);
              },
              deleteFunction: () {},
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            image: ordersController.parcelImage != null
                ? DecorationImage(
                    image: base64ToMemoryImage(ordersController.parcelImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 16.h),
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
                          height: 24.sp,
                          width: 24.sp,
                          colorFilter: const ColorFilter.mode(
                            Colors.blue,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundColor,
                      ),
                      padding: EdgeInsets.all(8.sp),
                      child: SvgPicture.asset(SvgAssets.cameraIcon),
                    ),
                    SizedBox(height: 4.h),
                    customText(
                      "Upload an image (optional)",
                      color: AppColors.primaryColor,
                      fontSize: 13.sp,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
