import 'package:gosharpsharp/core/models/cart_model.dart';
import 'package:gosharpsharp/core/services/restaurant/cart/restaurant_cart_service.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/views/checkout_screen.dart';
import 'package:gosharpsharp/modules/cart/views/order_tracking_screen.dart';

class CartController extends GetxController {
  final cartService = serviceLocator<RestaurantCartService>();

  // Loading states
  bool _isLoading = false;
  bool _isAddingToCart = false;
  bool _isRemovingFromCart = false;
  bool _isUpdatingCart = false;
  int? _addingToCartItemId; // Track specific item being added

  get isLoading => _isLoading;
  get isAddingToCart => _isAddingToCart;
  get isRemovingFromCart => _isRemovingFromCart;
  get isUpdatingCart => _isUpdatingCart;

  // Check if specific item is being added to cart
  bool isAddingItemToCart(int itemId) => _addingToCartItemId == itemId;

  void setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  void setAddingToCartState(bool val) {
    _isAddingToCart = val;
    update();
  }

  void setRemovingFromCartState(bool val) {
    _isRemovingFromCart = val;
    update();
  }

  void setUpdatingCartState(bool val) {
    _isUpdatingCart = val;
    update();
  }

  // Cart data - Updated structure
  List<CartItem> _cartItems = [];
  double _cartTotal = 0.0;
  RxString selectedPaymentMethod = 'Cash'.obs;
  RxString instructions = ''.obs;

  // Order tracking states
  RxBool orderPlaced = false.obs;
  RxString orderStatus =
      'preparing'.obs; // preparing, out_for_delivery, delivered

  // UI states
  bool _isOrderSummaryExpanded = false;
  bool get isOrderSummaryExpanded => _isOrderSummaryExpanded;

  // Delivery info
  RxString currentLocation = '20 Soho loop street birmingham'.obs;
  double _selectedLatitude = 43.6532;
  double _selectedLongitude = 79.3832;
  RxString deliveryPersonName = 'James Williams'.obs;
  RxString deliveryPersonPhone = '+234 806 000 0000'.obs;
  RxDouble deliveryPersonRating = 4.6.obs;
  RxString estimatedArrival = '11:45'.obs;

  // Location getters
  double get selectedLatitude => _selectedLatitude;
  double get selectedLongitude => _selectedLongitude;

  // Update delivery location
  void updateDeliveryLocation(
    String address,
    double latitude,
    double longitude,
  ) {
    currentLocation.value = address;
    _selectedLatitude = latitude;
    _selectedLongitude = longitude;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  // Fetch cart from API
  Future<void> fetchCart() async {
    try {
      setLoadingState(true);
      APIResponse response = await cartService.getMenuCart();

      if (response.status.toLowerCase() == "success") {
        if (response.data != null) {
          // Handle the new API structure: {items: [], total: 0}
          final data = response.data as Map<String, dynamic>;
          final itemsData = data['items'] as List<dynamic>? ?? [];
          final total = data['total'] ?? 0;

          // Parse cart items
          _cartItems = itemsData
              .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
              .toList();

          // Set total
          _cartTotal = double.tryParse(total.toString()) ?? 0.0;
        } else {
          _cartItems = [];
          _cartTotal = 0.0;
        }
      } else {
        showToast(message: response.message, isError: true);
        _cartItems = [];
        _cartTotal = 0.0;
      }
    } catch (e) {
      showToast(message: "Failed to fetch cart: $e", isError: true);
      _cartItems = [];
      _cartTotal = 0.0;
    } finally {
      setLoadingState(false);
    }
  }

  // Add item to cart
  Future<void> addToCart(int menuId, int quantity) async {
    try {
      // Set specific item being added
      _addingToCartItemId = menuId;
      setAddingToCartState(true);

      dynamic data = {'menu_id': menuId, 'quantity': quantity};

      APIResponse response = await cartService.addToMenuCart(data);

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Item added to cart successfully", isError: false);
        // Refresh cart after adding item
        await fetchCart();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to add item to cart: $e", isError: true);
    } finally {
      _addingToCartItemId = null; // Clear specific item
      setAddingToCartState(false);
    }
  }

  // Update cart item quantity
  Future<void> updateCartItemQuantity(int itemId, int quantity) async {
    try {
      setUpdatingCartState(true);

      dynamic data = {'quantity': quantity};

      // Use the correct endpoint for updating cart item
      APIResponse response = await cartService.updateMenuCart(
        id: itemId,
        data: data,
      );

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Cart updated successfully", isError: false);
        // Refresh cart after updating
        await fetchCart();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to update cart: $e", isError: true);
    } finally {
      setUpdatingCartState(false);
    }
  }

  // Decrease quantity for a specific menu item
  Future<void> decreaseQuantity(int menuId) async {
    CartItem? item = getCartItemByPurchasableId(menuId);
    if (item != null && item.quantity > 1) {
      await updateCartItemQuantity(item.id, item.quantity - 1);
    } else if (item != null && item.quantity == 1) {
      // Remove item if quantity is 1
      await removeFromCart(item.id);
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(int itemId) async {
    try {
      setRemovingFromCartState(true);

      APIResponse response = await cartService.removeFromMenuCart({
        'id': itemId,
      });

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Item removed from cart", isError: false);
        // Refresh cart after removing item
        await fetchCart();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to remove item from cart: $e", isError: true);
    } finally {
      setRemovingFromCartState(false);
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    if (_cartItems.isEmpty) return;

    try {
      setLoadingState(true);

      // Use the dedicated clear cart endpoint
      APIResponse response = await cartService.clearCart();

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Cart cleared successfully", isError: false);
        await fetchCart();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to clear cart: $e", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Getters for cart calculations
  double get subtotal {
    // Calculate subtotal from individual cart item totals
    return _cartItems.fold(0.0, (sum, item) {
      return sum + (double.tryParse(item.total) ?? 0.0);
    });
  }

  double get deliveryFee => 600.00;
  double get serviceCharge => 200.00;
  double get total => subtotal + deliveryFee + serviceCharge;

  int get itemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  List<CartItem> get cartItems {
    return _cartItems;
  }

  bool get isCartEmpty {
    return _cartItems.isEmpty;
  }

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    update(); // Update UI to reflect selection
  }

  void updateInstructions(String newInstructions) {
    instructions.value = newInstructions;
  }

  // Toggle order summary expansion
  void toggleOrderSummary() {
    _isOrderSummaryExpanded = !_isOrderSummaryExpanded;
    update(['order_summary']);
  }

  // Place order
  Future<void> placeOrder() async {
    if (isCartEmpty) {
      showToast(message: "Cart is empty", isError: true);
      return;
    }

    try {
      setLoadingState(true);

      // Prepare order data with the specified format
      dynamic orderData = {
        'delivery_address': currentLocation.value,
        'latitude': selectedLatitude,
        'longitude': selectedLongitude,
        'note': 'Order placed via mobile app',
      };

      APIResponse response = await cartService.createOrder(orderData);

      if (response.status.toLowerCase() == "success") {
        orderPlaced.value = true;
        showToast(message: "Order placed successfully", isError: false);

        // Refresh the cart after successful order
        await refreshCart();

        // Navigate to checkout success
        Get.to(() => CheckoutScreen());
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to place order: $e", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Place order with Go Wallet
  Future<void> placeOrderWithWallet([String? instructions]) async {
    if (isCartEmpty) {
      showToast(message: "Cart is empty", isError: true);
      return;
    }

    try {
      setLoadingState(true);

      // Prepare order data with wallet payment method using selected location and instructions
      dynamic orderData = {
        'delivery_address': currentLocation.value,
        'latitude': _selectedLatitude,
        'longitude': _selectedLongitude,
        'note': instructions?.isNotEmpty == true
            ? instructions
            : 'Order placed via mobile app',
        'payment_method': 'wallet',
      };
      APIResponse response = await cartService.createOrder(orderData);

      if (response.status.toLowerCase() == "success") {
        orderPlaced.value = true;
        showToast(
          message: "Order placed successfully with Go Wallet",
          isError: false,
        );

        // Refresh the cart after successful order
        await refreshCart();

        // Navigate to checkout success
        Get.to(() => CheckoutScreen());
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(
        message: "Failed to place order with wallet: $e",
        isError: true,
      );
    } finally {
      setLoadingState(false);
    }
  }

  PayStackAuthorizationModel? payStackAuthorizationData;
  // Place order with Paystack
  Future<void> placeOrderWithPaystack([String? instructions]) async {
    if (isCartEmpty) {
      showToast(message: "Cart is empty", isError: true);
      return;
    }

    try {
      setLoadingState(true);

      // Prepare order data with Paystack payment method using selected location and instructions
      dynamic orderData = {
        'delivery_address': currentLocation.value,
        'latitude': _selectedLatitude,
        'longitude': _selectedLongitude,
        'note': instructions?.isNotEmpty == true
            ? instructions
            : 'Order placed via mobile app',
        'payment_method': 'paystack',
      };

      APIResponse response = await cartService.createOrder(orderData);

      if (response.status.toLowerCase() == "success") {
        orderPlaced.value = true;
        payStackAuthorizationData = PayStackAuthorizationModel.fromJson(
          response.data['payment']['data'],
        );
        showToast(
          message: "Order placed successfully with Paystack",
          isError: false,
        );

        // Refresh the cart after successful order
        await refreshCart();

        // Navigate to checkout success
        Get.to(() => CheckoutScreen());
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(
        message: "Failed to place order with Paystack: $e",
        isError: true,
      );
    } finally {
      setLoadingState(false);
    }
  }

  void trackOrderProgress() {
    Get.to(() => OrderTrackingScreen());
  }

  void goBackToHome() {
    orderPlaced.value = false;
    Get.offAllNamed(Routes.DASHBOARD);
  }

  // Helper method to get cart item by purchasable ID
  CartItem? getCartItemByPurchasableId(int purchasableId) {
    try {
      return _cartItems.firstWhere(
        (item) => item.purchasableId == purchasableId,
      );
    } catch (e) {
      return null;
    }
  }

  // Check if item is in cart
  bool isInCart(int menuId) {
    return getCartItemByPurchasableId(menuId) != null;
  }

  // Get quantity of specific item in cart
  int getItemQuantityInCart(int menuId) {
    CartItem? item = getCartItemByPurchasableId(menuId);
    return item?.quantity ?? 0;
  }

  // Refresh cart data
  Future<void> refreshCart() async {
    await fetchCart();
  }
}
