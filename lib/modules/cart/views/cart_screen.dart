import 'package:gosharpsharp/core/widgets/skeleton_loaders.dart';
import 'package:gosharpsharp/modules/cart/controllers/cart_controller.dart';
import 'package:gosharpsharp/modules/cart/views/widgets/cart_item_widget.dart';

import '../../../core/utils/exports.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: 'My Cart',
            implyLeading: false,
            centerTitle: true,
            actionItem: Row(
              children:[
                if (!cartController.isCartEmpty)
                  TextButton(
                    onPressed: cartController.isLoading
                        ? null
                        : () => _showClearCartDialog(context, cartController),
                    child: customText(
                      'Clear',
                      fontSize: 14.sp,
                      color: AppColors.redColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          body: RefreshIndicator(
            backgroundColor: AppColors.primaryColor,
            color: AppColors.whiteColor,
            onRefresh: () => cartController.refreshCart(),
            child: cartController.isLoading
                ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  // Skeleton for delivery location
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 12.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                height: 16.h,
                                width: 150.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Cart items skeleton
                  SkeletonLoaders.cartItem(count: 3),
                ],
              ),
            )
                : cartController.isCartEmpty
                ? _buildEmptyCart()
                : Column(
              children: [
                // Delivery Location
                InkWell(
                  onTap: () => _selectDeliveryLocation(cartController),
                  child: Container(
                    padding: EdgeInsets.all(16.sp),
                    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.sp),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
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
                                'Tap to change location',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              customText(
                                cartController.currentLocation.value,
                                fontSize: 12.sp,
                                color: AppColors.greyColor,
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16.sp,
                          color: AppColors.greyColor,
                        ),
                      ],
                    ),
                  ),
                ),

                // Cart Items Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: customText(
                      'Cart Items',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),

                // Cart Items List with more space
                Expanded(
                  flex: 3, // Give more space to cart items
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];
                      return CartItemWidget(
                        item: item,
                        onQuantityChanged: (quantity) {
                          cartController.updateCartItemQuantity(item.id, quantity);
                        },
                        onRemove: () {
                          cartController.removeFromCart(item.id);
                        },
                        isUpdating: cartController.isUpdatingCart,
                        isRemoving: cartController.isRemovingFromCart,
                      );
                    },
                  ),
                ),

                // Expandable Order Summary
                _buildExpandableOrderSummary(cartController),
              ],
            ),
          ),
          bottomNavigationBar: cartController.isCartEmpty
              ? null
              : _buildPaymentOptions(cartController),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        width: 1.sw,
        height: 0.7.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           SvgPicture.asset(
                SvgAssets.cartIcon,
             height: 100.sp,
             colorFilter: ColorFilter.mode(AppColors.deepAmberColor, BlendMode.srcIn),
            ),
            SizedBox(height: 20.h),
            customText(
              "Your Cart is Empty",
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 10.h),
            customText(
              "Add some delicious items to your cart\nto get started",
              fontSize: 16.sp,
              color: AppColors.obscureTextColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                // Navigate to dashboard tab (index 0) in app navigation
                try {
                  final appNavController = Get.find<AppNavigationController>();
                  appNavController.changeScreenIndex(0);
                } catch (e) {
                  // Fallback if controller not found
                  Get.offNamedUntil(
                    Routes.APP_NAVIGATION,
                    (route) => false,
                    arguments: {'initialIndex': 0},
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: customText(
                "Browse Restaurants",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableOrderSummary(CartController cartController) {
    return GetBuilder<CartController>(
      id: 'order_summary',
      builder: (controller) {
        bool isExpanded = controller.isOrderSummaryExpanded;
        return Container(
          margin: EdgeInsets.all(16.w),
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
            children: [
              // Header - Always visible
              InkWell(
                onTap: () => controller.toggleOrderSummary(),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            'Order Summary',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                          Row(
                            children: [
                              customText(
                                '₦${cartController.total.toStringAsFixed(2)}',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: 8.w),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration: Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20.sp,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            '${cartController.itemCount} item${cartController.itemCount != 1 ? 's' : ''}',
                            fontSize: 12.sp,
                            color: AppColors.greyColor,
                          ),
                          customText(
                            isExpanded ? 'Tap to collapse' : 'Tap to view breakdown',
                            fontSize: 12.sp,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Expanded Details
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: isExpanded ? null : 0,
                child: isExpanded ? Container(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
                  child: Column(
                    children: [
                      Divider(),
                      SizedBox(height: 12.h),

                      // Subtotal
                      OrderSummaryItem(
                        label: "Subtotal",
                        amount: cartController.subtotal,
                      ),
                      SizedBox(height: 8.h),

                      // Delivery fee
                      OrderSummaryItem(
                        label: "Delivery fee",
                        amount: cartController.deliveryFee,
                      ),
                      SizedBox(height: 8.h),

                      // Service charge
                      OrderSummaryItem(
                        label: "Service charge",
                        amount: cartController.serviceCharge,
                      ),

                      SizedBox(height: 12.h),
                      Divider(),
                      SizedBox(height: 12.h),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText(
                            'Total',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor,
                          ),
                          customText(
                            '₦${cartController.total.toStringAsFixed(2)}',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ) : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOptions(CartController cartController) {
    return GetBuilder<WalletController>(
      init: WalletController(),
      initState: (state) {
        // Fetch wallet balance when payment options are shown
        Future.delayed(Duration.zero, () {
          state.controller?.getWalletBalance();
        });
      },
      builder: (walletController) {
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  'Select Payment Method',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 8.h),

                // Payment Options Row
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
                    SizedBox(width: 8.w),

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

                SizedBox(height: 12.h),

                // Place Order Button
                CustomButton(
                  width: double.infinity,
                  height: 45.h,
                  backgroundColor: AppColors.primaryColor,
                  title: 'Place Order - ₦${cartController.total.toStringAsFixed(2)}',
                  onPressed: () {
                    if (!cartController.isLoading) {
                      _processPayment(cartController, cartController.selectedPaymentMethod.value.toLowerCase());
                    }
                  },
                  isBusy: cartController.isLoading,
                  borderRadius: 12.r,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontColor: AppColors.whiteColor,
                ),
              ],
            ),
          ),
        );
      },
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
                ? AppColors.primaryColor
                : AppColors.primaryColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isLoading
              ? AppColors.greyColor.withOpacity(0.1)
              : isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : AppColors.whiteColor,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28.sp,
              color: isLoading
                  ? AppColors.greyColor
                  : AppColors.primaryColor,
            ),
            SizedBox(height: 6.h),
            customText(
              title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isLoading
                  ? AppColors.greyColor
                  : AppColors.blackColor,
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
                    ? AppColors.primaryColor
                    : AppColors.primaryColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isLoading
              ? AppColors.greyColor.withOpacity(0.1)
              : hasInsufficientFunds
                  ? Colors.red.withOpacity(0.05)
                  : isSelected
                      ? AppColors.primaryColor.withOpacity(0.1)
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
                      : AppColors.primaryColor,
            ),
            SizedBox(height: 4.h),
            customText(
              title,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isLoading
                  ? AppColors.greyColor
                  : AppColors.blackColor,
            ),
            SizedBox(height: 2.h),
            if (walletBalance != null)
              customText(
                '₦${double.tryParse(walletBalance)?.toStringAsFixed(2) ?? '0.00'}',
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: hasInsufficientFunds
                    ? Colors.red
                    : AppColors.primaryColor,
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
    // Check if wallet has sufficient funds
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

    // Select wallet payment method if funds are sufficient
    cartController.selectPaymentMethod('wallet');
  }

  void _processPayment(CartController cartController, String paymentMethod) {
    // Show additional instructions bottom sheet first
    _showAdditionalInstructionsBottomSheet(cartController, paymentMethod);
  }

  Future<void> _selectDeliveryLocation(CartController cartController) async {
    try {
      final result = await Get.to(() => SelectLocation());

      if (result != null && result is ItemLocation) {
        // Show address editing dialog
        await _showAddressEditingDialog(cartController, result);
      }
    } catch (e) {
      showToast(message: "Failed to select location: $e", isError: true);
    }
  }

  Future<void> _showAddressEditingDialog(CartController cartController, ItemLocation location) async {
    final TextEditingController addressController = TextEditingController(
      text: location.formattedAddress ?? ''
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
                  borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
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
      // Update the delivery location
      cartController.updateDeliveryLocation(result, location.latitude, location.longitude);
      showToast(message: "Delivery address updated successfully", isError: false);
    }
  }

  void _showAdditionalInstructionsBottomSheet(CartController cartController, String paymentMethod) {
    final TextEditingController instructionsController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            customText(
              'Additional Instructions',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 8.h),
            customText(
              'Add any special instructions for your order (optional)',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
            SizedBox(height: 20.h),

            TextField(
              controller: instructionsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g., Ring the doorbell, Leave at door, etc.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.greyColor.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                      // Place order without instructions
                      _finalizeOrder(cartController, paymentMethod, '');
                    },
                    child: customText(
                      'Skip',
                      fontSize: 14.sp,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: CustomButton(
                    width: double.infinity,
                    height: 45.h,
                    backgroundColor: AppColors.primaryColor,
                    title: 'Place Order',
                    onPressed: () {
                      Get.back();
                      _finalizeOrder(cartController, paymentMethod, instructionsController.text.trim());
                    },
                    borderRadius: 12.r,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontColor: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(Get.context!).viewInsets.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _finalizeOrder(CartController cartController, String paymentMethod, String instructions) {
    // Place order with the selected payment method and instructions
    if (paymentMethod == 'wallet') {
      cartController.placeOrderWithWallet(instructions);
    } else if (paymentMethod == 'paystack') {
      cartController.placeOrderWithPaystack(instructions);
    }
  }

  void _showClearCartDialog(BuildContext context, CartController cartController) {
    Get.dialog(
      AlertDialog(
        title: customText(
          'Clear Cart',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
        content: customText(
          'Are you sure you want to remove all items from your cart?',
          fontSize: 14.sp,
          color: AppColors.greyColor,
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
          TextButton(
            onPressed: () {
              Get.back();
              cartController.clearCart();
            },
            child: customText(
              'Clear',
              fontSize: 14.sp,
              color: AppColors.redColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderSummaryItem extends StatelessWidget {
  final String label;
  final double amount;

  const OrderSummaryItem({
    super.key,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(label, fontSize: 14.sp, color: AppColors.greyColor),
        customText(
          "₦${amount.toStringAsFixed(2)}",
          fontSize: 14.sp,
          color: AppColors.blackColor,
        ),
      ],
    );
  }
}