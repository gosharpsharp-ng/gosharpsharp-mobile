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

  get isLoading => _isLoading;
  get isAddingToCart => _isAddingToCart;
  get isRemovingFromCart => _isRemovingFromCart;
  get isUpdatingCart => _isUpdatingCart;

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

  // Order tracking states
  RxBool orderPlaced = false.obs;
  RxString orderStatus = 'preparing'.obs; // preparing, out_for_delivery, delivered

  // Delivery info
  RxString currentLocation = '20 Soho loop street birmingham'.obs;
  RxString deliveryPersonName = 'James Williams'.obs;
  RxString deliveryPersonPhone = '+234 806 000 0000'.obs;
  RxDouble deliveryPersonRating = 4.6.obs;
  RxString estimatedArrival = '11:45'.obs;

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
      customDebugPrint(response.data);

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

      // Remove all items one by one (if there's no clear cart endpoint)
      for (CartItem item in _cartItems) {
        await cartService.removeFromMenuCart({'id': item.id});
      }

      showToast(message: "Cart cleared successfully", isError: false);
      await fetchCart();
    } catch (e) {
      showToast(message: "Failed to clear cart: $e", isError: true);
    } finally {
      setLoadingState(false);
    }
  }

  // Getters for cart calculations
  double get subtotal {
    return _cartTotal;
  }

  double get deliveryFee => 600.00;
  double get serviceCharge => 1200.00;
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
  }

  // Place order
  Future<void> placeOrder() async {
    if (isCartEmpty) {
      showToast(message: "Cart is empty", isError: true);
      return;
    }

    try {
      setLoadingState(true);

      // Prepare order data
      dynamic orderData = {
        'payment_method': selectedPaymentMethod.value.toLowerCase(),
        'delivery_address': currentLocation.value,
        // Add any other required fields for order creation
      };

      APIResponse response = await cartService.createOrder(orderData);

      if (response.status.toLowerCase() == "success") {
        orderPlaced.value = true;
        showToast(message: "Order placed successfully", isError: false);

        // Clear the cart after successful order
        _cartItems = [];
        _cartTotal = 0.0;

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