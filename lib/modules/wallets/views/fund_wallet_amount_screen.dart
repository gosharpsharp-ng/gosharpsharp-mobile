import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:intl/intl.dart';

class FundWalletAmountScreen extends StatelessWidget {
  const FundWalletAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return Form(
        key: walletController.fundWalletFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Fund Wallet",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TitleSectionBox(
                    title: "Enter the amount you want to fund your wallet with",
                    children: [
                      SizedBox(
                        height: 15.sp,
                      ),
                      CustomRoundedInputField(
                        title: "Amount",
                        label: "50,000",
                        showLabel: true,
                        isRequired: true,
                        isNumber: true,
                        useCustomValidator: true,
                        keyboardType: TextInputType.number,
                        hasTitle: true,
                        controller: walletController.amountEntryController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          // Remove currency symbols and commas for validation
                          String cleanedValue =
                              value.replaceAll(RegExp(r'[^\d]'), '');
                          if (cleanedValue.isEmpty ||
                              double.tryParse(cleanedValue) == null) {
                            return 'Please enter a valid number';
                          }

                          // Parse the value and check if it is greater than 1000
                          double numericValue = double.parse(cleanedValue);
                          if (numericValue <= 1000) {
                            return 'Amount must be greater than ₦1,000';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // Remove all non-digit characters
                          String newValue =
                              value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (value.isEmpty || newValue == '00') {
                            walletController.amountEntryController.clear();
                            return;
                          }
                          double value1 = int.parse(newValue) / 100;
                          value = NumberFormat.currency(
                            locale: 'en_NG',
                            symbol: '₦',
                            decimalDigits: 2,
                          ).format(value1);
                          walletController.amountEntryController.value =
                              TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomButton(
                        onPressed: () async {
                          await walletController.fundWallet();
                          if (walletController.payStackAuthorizationData !=
                              null) {
                            if (!context.mounted) return;
                            showPaymentWebViewDialog(
                              context,
                              url: walletController.payStackAuthorizationData
                                      ?.authorizationUrl ??
                                  "",
                              title: "Paystack Payment",
                              onSuccess: () {
                                // Get the amount before clearing fields
                                final amount = walletController.amountEntryController.text;
                                walletController.clearFundingFields();
                                // Navigate to success screen (wallet will refresh there)
                                Get.offNamedUntil(
                                  Routes.FUND_WALLET_SUCCESS_SCREEN,
                                  (route) => route.settings.name == Routes.APP_NAVIGATION,
                                  arguments: {
                                    'amount': amount,
                                  },
                                );
                              },
                              onFailure: (String reason) {
                                walletController.clearFundingFields();
                                // Navigate to failure screen with specific reason
                                Get.offNamedUntil(
                                  Routes.FUND_WALLET_FAILURE_SCREEN,
                                  (route) => route.settings.name == Routes.APP_NAVIGATION,
                                  arguments: {
                                    'message': reason,
                                  },
                                );
                              },
                            );
                          }
                        },
                        isBusy: walletController.fundingWallet,
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
