import 'package:flutter/material.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/utils/exports.dart';

class OrderCheckoutScreen extends StatelessWidget {
  const OrderCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: 'Checkout',
            implyLeading: true,
            centerTitle: true,
          ),
          body: cartController.isLoading
              ? _buildLoadingSkeleton()
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Map Preview Section
                            _buildMapPreview(cartController),

                            SizedBox(height: 16.h),

                            // Delivery Location Section
                            _buildDeliveryLocationSection(cartController),

                            SizedBox(height: 16.h),

                            // Order Summary Section
                            _buildOrderSummarySection(cartController),

                            SizedBox(height: 16.h),

                            // Payment Method Section
                            _buildPaymentMethodSection(cartController),

                            SizedBox(height: 16.h),

                            // Additional Instructions Section
                            _buildAdditionalInstructionsSection(cartController),
                          ],
                        ),
                      ),
                    ),

                    // Bottom action bar
                    _buildBottomActionBar(cartController, context),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildLoadingSkeleton() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Delivery location skeleton
          Container(
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Order summary skeleton
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(height: 16.h),

          // Payment method skeleton
          Container(
            height: 150.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(CartController cartController) {
    final lat = cartController.selectedLatitude;
    final lng = cartController.selectedLongitude;

    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          GoogleMap(
            key: ValueKey('${lat}_${lng}'), // Force rebuild when location changes
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: MarkerId('delivery_location'),
                position: LatLng(lat, lng),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
            liteModeEnabled: true,
          ),
          // Overlay to indicate tap to change location
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: () => _selectDeliveryLocation(cartController),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.greyColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_location,
                      size: 14.sp,
                      color: AppColors.blackColor,
                    ),
                    SizedBox(width: 4.w),
                    customText(
                      'Change',
                      fontSize: 12.sp,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryLocationSection(CartController cartController) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            'Delivery Location',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 12.h),

          InkWell(
            onTap: () => _selectDeliveryLocation(cartController),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: AppColors.blackColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.whiteColor,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        'Deliver to',
                        fontSize: 12.sp,
                        color: AppColors.greyColor,
                      ),
                      SizedBox(height: 2.h),
                      customText(
                        cartController.currentLocation.value.isEmpty
                            ? 'Tap to select location'
                            : cartController.currentLocation.value,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor,
                        maxLines: 2,
                        overflow: TextOverflow.visible
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit,
                  size: 16.sp,
                  color: AppColors.blackColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection(CartController cartController) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            'Order Summary',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 16.h),

          // Subtotal
          _buildSummaryRow('Subtotal', cartController.subtotal),
          SizedBox(height: 8.h),

          // Delivery fee
          _buildSummaryRow('Delivery fee', cartController.deliveryFee),
          SizedBox(height: 8.h),

          // Service charge
          _buildSummaryRow('Service charge', cartController.serviceCharge),
          SizedBox(height: 12.h),

          Divider(),
          SizedBox(height: 12.h),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                'Total',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
              ),
              customText(
                formatToCurrency(cartController.total),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ],
          ),

          SizedBox(height: 8.h),
          customText(
            '${cartController.itemCount} item${cartController.itemCount != 1 ? 's' : ''} in your order',
            fontSize: 12.sp,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          fontSize: 14.sp,
          color: AppColors.greyColor,
        ),
        customText(
          formatToCurrency(amount),
          fontSize: 14.sp,
          color: AppColors.blackColor,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(CartController cartController) {
    return GetBuilder<WalletController>(
      init: WalletController(),
      initState: (state) {
        Future.delayed(Duration.zero, () {
          state.controller?.getWalletBalance();
        });
      },
      builder: (walletController) {
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColors.greyColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                'Payment Method',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              SizedBox(height: 16.h),

              // Payment Options
              Row(
                children: [
                  // Go Wallet Option
                  Expanded(
                    child: _buildPaymentOptionWithBalance(
                      title: 'Go Wallet',
                      subtitle: 'Pay with wallet balance',
                      icon: Icons.account_balance_wallet,
                      onTap: () => _selectWalletPayment(cartController, walletController),
                      isLoading: cartController.isLoading,
                      isSelected: cartController.selectedPaymentMethod.value.toLowerCase() == 'wallet',
                      walletBalance: walletController.walletBalanceData?.balance,
                      orderTotal: cartController.total,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Paystack Option
                  Expanded(
                    child: _buildPaymentOption(
                      title: 'Paystack',
                      subtitle: 'Pay with card or bank',
                      icon: Icons.credit_card,
                      onTap: () => _selectPaymentMethod(cartController, 'paystack'),
                      isLoading: cartController.isLoading,
                      isSelected: cartController.selectedPaymentMethod.value.toLowerCase() == 'paystack',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdditionalInstructionsSection(CartController cartController) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.greyColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            'Additional Instructions',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 8.h),
          customText(
            'Add any special instructions for your order (optional)',
            fontSize: 12.sp,
            color: AppColors.greyColor,
          ),
          SizedBox(height: 12.h),

          TextField(
            onChanged: (value) => cartController.updateInstructions(value),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'e.g., Ring the doorbell, Leave at door, etc.',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.greyColor.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.blackColor),
              ),
              contentPadding: EdgeInsets.all(12.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(CartController cartController, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border(
          top: BorderSide(
            color: AppColors.greyColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: CustomButton(
          width: double.infinity,
          height: 50.h,
          backgroundColor: AppColors.primaryColor,
          title: 'Place Order - ${formatToCurrency(cartController.total)}',
          onPressed: () {
            if (!cartController.isLoading && cartController.selectedPaymentMethod.value.isNotEmpty) {
              _processPayment(cartController, cartController.selectedPaymentMethod.value.toLowerCase(), context);
            } else if (cartController.selectedPaymentMethod.value.isEmpty) {
              showToast(message: "Please select a payment method", isError: true);
            }
          },
          isBusy: cartController.isLoading,
          borderRadius: 12.r,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontColor: AppColors.whiteColor,
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool isLoading,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.blackColor
                : AppColors.greyColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isLoading
              ? AppColors.greyColor.withOpacity(0.1)
              : isSelected
              ? AppColors.blackColor.withOpacity(0.05)
              : AppColors.whiteColor,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28.sp,
              color: isLoading ? AppColors.greyColor : AppColors.blackColor,
            ),
            SizedBox(height: 6.h),
            customText(
              title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isLoading ? AppColors.greyColor : AppColors.blackColor,
            ),
            SizedBox(height: 2.h),
            customText(
              subtitle,
              fontSize: 10.sp,
              color: AppColors.obscureTextColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptionWithBalance({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required bool isLoading,
    required bool isSelected,
    required String? walletBalance,
    required double orderTotal,
  }) {
    double? balance = walletBalance != null ? double.tryParse(walletBalance) : null;
    bool hasInsufficientFunds = balance != null && balance < orderTotal;

    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasInsufficientFunds
                ? Colors.red.withOpacity(0.5)
                : isSelected
                ? AppColors.blackColor
                : AppColors.greyColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isLoading
              ? AppColors.greyColor.withOpacity(0.1)
              : hasInsufficientFunds
              ? Colors.red.withOpacity(0.05)
              : isSelected
              ? AppColors.blackColor.withOpacity(0.05)
              : AppColors.whiteColor,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isLoading
                  ? AppColors.greyColor
                  : hasInsufficientFunds
                  ? Colors.red
                  : AppColors.blackColor,
            ),
            SizedBox(height: 4.h),
            customText(
              title,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isLoading ? AppColors.greyColor : AppColors.blackColor,
            ),
            SizedBox(height: 2.h),
            if (walletBalance != null)
              customText(
                formatToCurrency(double.tryParse(walletBalance) ?? 0.0),
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: hasInsufficientFunds ? Colors.red : AppColors.blackColor,
              )
            else
              customText(
                'Loading...',
                fontSize: 10.sp,
                color: AppColors.obscureTextColor,
                textAlign: TextAlign.center,
              ),
            if (hasInsufficientFunds) ...[
              SizedBox(height: 2.h),
              customText(
                'Insufficient funds',
                fontSize: 8.sp,
                color: Colors.red,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _selectPaymentMethod(CartController cartController, String paymentMethod) {
    cartController.selectPaymentMethod(paymentMethod);
  }

  void _selectWalletPayment(CartController cartController, WalletController walletController) {
    String? balanceStr = walletController.walletBalanceData?.balance;
    if (balanceStr != null) {
      double balance = double.tryParse(balanceStr) ?? 0.0;
      double orderTotal = cartController.total;

      if (balance < orderTotal) {
        showToast(
          message: "Insufficient wallet balance. Please top up your wallet or use Paystack.",
          isError: true,
        );
        return;
      }
    }

    cartController.selectPaymentMethod('wallet');
  }

  void _processPayment(CartController cartController, String paymentMethod, BuildContext context) {
    if (paymentMethod == 'wallet') {
      cartController.placeOrderWithWallet(cartController.instructions.value);
    } else if (paymentMethod == 'paystack') {
      _processPaystackPayment(cartController, context);
    }
  }

  Future<void> _processPaystackPayment(CartController cartController, BuildContext context) async {
    await cartController.placeOrderWithPaystack(cartController.instructions.value);
    if (cartController.payStackAuthorizationData != null) {
      WebViewController collectionsWebViewController = createWebViewController(
        successCallback: () {
          Get.back();
        },
      );
      showWebViewDialog(
        context,
        controller: collectionsWebViewController,
        onDialogClosed: () {
          Get.back();
        },
        title: "Paystack",
        url: cartController.payStackAuthorizationData?.authorizationUrl ?? "",
      );
    }
  }

  Future<void> _selectDeliveryLocation(CartController cartController) async {
    try {
      final result = await Get.to(() => SelectLocation());

      if (result != null && result is ItemLocation) {
        await _showAddressEditingDialog(cartController, result);
      }
    } catch (e) {
      showToast(message: "Failed to select location: $e", isError: true);
    }
  }

  Future<void> _showAddressEditingDialog(CartController cartController, ItemLocation location) async {
    final TextEditingController addressController = TextEditingController(
      text: location.formattedAddress ?? '',
    );

    final result = await Get.dialog<String>(
      AlertDialog(
        title: customText(
          'Edit Delivery Address',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customText(
              'You can edit the address name before confirming',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Enter your delivery address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(
                    color: AppColors.greyColor.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: customText(
              'Cancel',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: addressController.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: customText(
              'Confirm',
              fontSize: 14.sp,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      cartController.updateDeliveryLocation(
        result,
        location.latitude,
        location.longitude,
      );
      showToast(
        message: "Delivery address updated successfully",
        isError: false,
      );
    }
  }
}