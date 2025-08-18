import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class InitiateDeliveryScreen extends StatelessWidget {
  const InitiateDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Form(
        key: ordersController.sendingInfoFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor, title: "Create order"),
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
                          final ItemLocation result =
                              await Get.toNamed(Routes.SELECT_LOCATION_SCREEN);
                          ordersController.setDeliverySenderLocation(result);
                          if (ordersController.deliveryReceiverLocation !=
                              null) {
                            await ordersController.getRideEstimatedDistance();
                          }
                        },
                        prefixWidget: IconButton(
                          onPressed: () async {
                            final ItemLocation result = await Get.toNamed(
                                Routes.SELECT_LOCATION_SCREEN);
                            ordersController.setDeliverySenderLocation(result);
                            if (ordersController.deliveryReceiverLocation !=
                                null) {
                              await ordersController.getRideEstimatedDistance();
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
                            final updatedNumber =
                                phone.number.replaceFirst(RegExp(r'^0'), '');
                            ordersController.receiverPhoneController.value =
                                TextEditingValue(
                              text: updatedNumber,
                              selection: TextSelection.collapsed(
                                  offset: updatedNumber.length),
                            );
                            ordersController.setReceiverPhoneNumber(PhoneNumber(
                              countryISOCode: phone.countryISOCode,
                              countryCode: phone.countryCode,
                              number: updatedNumber,
                            ));
                            ordersController.setFilledPhoneNumber(PhoneNumber(
                              countryISOCode: phone.countryISOCode,
                              countryCode: phone.countryCode,
                              number: updatedNumber,
                            ));
                          } else {
                            ordersController.setFilledPhoneNumber(phone);
                          }
                        },
                        keyboardType: TextInputType.phone,
                        validator: (phone) {
                          if (phone == null ||
                              phone.completeNumber.isEmpty ||
                              ordersController
                                  .receiverPhoneController.text.isEmpty) {
                            return "Phone number is required";
                          }
                          // Regex: `+` followed by 1 to 3 digits (country code), then 10 digits (phone number)
                          final regex = RegExp(r'^\+234[1-9]\d{9}$');
                          if (!regex.hasMatch(phone.completeNumber)) {
                            return "Phone number must be 10 digits long";
                          }
                          if (ordersController
                                  .receiverPhoneController.text.length ==
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
                          final ItemLocation result =
                              await Get.toNamed(Routes.SELECT_LOCATION_SCREEN);
                          ordersController.setDeliveryReceiverLocation(result);
                          if (ordersController.deliverySenderLocation != null) {
                            await ordersController.getRideEstimatedDistance();
                          }
                        },
                        prefixWidget: IconButton(
                          onPressed: () async {
                            final ItemLocation result = await Get.toNamed(
                                Routes.SELECT_LOCATION_SCREEN);
                            ordersController
                                .setDeliveryReceiverLocation(result);
                            if (ordersController.deliverySenderLocation !=
                                null) {
                              await ordersController.getRideEstimatedDistance();
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
                        controller: ordersController.receiverAddressController,
                      ),
                      CustomRoundedInputField(
                        title: "Estimated Distance (km)",
                        label: "0.0",
                        showLabel: true,
                        hasTitle: true,
                        readOnly: true,
                        isRequired: true,
                        controller:
                            ordersController.estimatedDistanceController,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomButton(
                      onPressed: () {
                        ordersController.validateSendingInformation();
                      },
                      // isBusy: signInProvider.isLoading,
                      title: "Continue",
                      width: 1.sw,
                      backgroundColor: AppColors.primaryColor,
                      fontColor: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
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
