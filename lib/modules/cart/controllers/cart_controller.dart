import 'package:gosharpsharp/core/models/cart_model.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';
import 'package:gosharpsharp/core/services/restaurant/cart/restaurant_cart_service.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/views/checkout_screen.dart';
import 'package:gosharpsharp/modules/orders/views/order_tracking_screen.dart';
import 'package:gosharpsharp/modules/cart/views/widgets/package_selection_dialog.dart';
import 'package:gosharpsharp/modules/cart/views/widgets/add_to_cart_success_bottom_sheet.dart';

class CartController extends GetxController {
  final cartService = serviceLocator<RestaurantCartService>();

  // Loading states
  bool _isLoading = false;
  bool _isAddingToCart = false;
  bool _isRemovingFromCart = false;
  bool _isUpdatingCart = false;
  int? _addingToCartItemId; // Track specific item being added

  bool get isLoading => _isLoading;
  bool get isAddingToCart => _isAddingToCart;
  bool get isRemovingFromCart => _isRemovingFromCart;
  bool get isUpdatingCart => _isUpdatingCart;

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
  List<CartPackage> _packages = [];
  RxString selectedPaymentMethod = 'Cash'.obs;
  RxString instructions = ''.obs;

  // Package management
  String? _selectedPackageName;

  List<CartPackage> get packages => _packages;
  List<String> get packageNames => _packages.map((p) => p.name).toList();
  String? get selectedPackageName => _selectedPackageName;

  // Set selected package
  void setSelectedPackage(String? packageName) {
    _selectedPackageName = packageName;
    update();
  }

  // Clear selected package
  void clearSelectedPackage() {
    _selectedPackageName = null;
    update();
  }

  // Order tracking states
  RxBool orderPlaced = false.obs;
  RxString orderStatus =
      'preparing'.obs; // preparing, out_for_delivery, delivered

  // UI states
  bool _isOrderSummaryExpanded = false;
  bool get isOrderSummaryExpanded => _isOrderSummaryExpanded;

  // Delivery info
  RxString currentLocation = ''.obs;
  double _selectedLatitude = 9.8965; // Default to Jos, Nigeria
  double _selectedLongitude = 8.8583;
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

  // Send to Someone Else feature
  bool _isSendingToSomeoneElse = false;
  final TextEditingController recipientNameController = TextEditingController();
  final TextEditingController recipientPhoneController = TextEditingController();

  bool get isSendingToSomeoneElse => _isSendingToSomeoneElse;

  void toggleSendToSomeoneElse(bool value) {
    _isSendingToSomeoneElse = value;
    if (!value) {
      // Clear recipient details when toggled off
      recipientNameController.clear();
      recipientPhoneController.clear();
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocation();
    fetchCart();
  }

  // Load the customer's saved location from storage
  void _loadSavedLocation() {
    try {
      final storage = GetStorage();
      final savedLocation = storage.read('selected_location');
      final lat = storage.read('location_lat');
      final lng = storage.read('location_lng');

      if (savedLocation != null &&
          savedLocation.isNotEmpty &&
          savedLocation != 'Choose Location to continue' &&
          lat != null &&
          lng != null) {
        currentLocation.value = savedLocation;
        _selectedLatitude = double.parse(lat);
        _selectedLongitude = double.parse(lng);
        debugPrint('📍 CartController: Loaded saved location: $savedLocation');
      } else {
        debugPrint('📍 CartController: No saved location found, using default');
      }
    } catch (e) {
      debugPrint('❌ Error loading saved location in CartController: $e');
    }
  }

  // Fetch cart from API
  Future<void> fetchCart() async {
    try {
      setLoadingState(true);
      APIResponse response = await cartService.getMenuCart();

      if (response.status.toLowerCase() == "success") {
        if (response.data != null) {
          customDebugPrint(response.data);

          // Parse the Cart object from response
          final Cart cart = Cart.fromJson(response.data as Map<String, dynamic>);

          // Extract packages
          _packages = cart.packages;

          // Set default package if cart is not empty and no package selected
          if (_packages.isNotEmpty && _selectedPackageName == null) {
            _selectedPackageName = _packages.first.name;
          }
        } else {
          _packages = [];
          _selectedPackageName = null;
        }
        update(); // Trigger UI update
      } else {
        showToast(message: response.message, isError: true);
        _packages = [];
        _selectedPackageName = null;
        update(); // Trigger UI update
      }
    } catch (e) {
      showToast(message: "Failed to fetch cart: $e", isError: true);
      _packages = [];
      _selectedPackageName = null;
      update(); // Trigger UI update
    } finally {
      setLoadingState(false);
    }
  }

  // Fetch cart silently without showing loading state (for background updates)
  Future<void> _fetchCartSilently() async {
    try {
      APIResponse response = await cartService.getMenuCart();

      if (response.status.toLowerCase() == "success") {
        if (response.data != null) {
          // Parse the Cart object from response
          final Cart cart = Cart.fromJson(response.data as Map<String, dynamic>);

          // Extract packages
          _packages = cart.packages;

          // Set default package if cart is not empty and no package selected
          if (_packages.isNotEmpty && _selectedPackageName == null) {
            _selectedPackageName = _packages.first.name;
          }
        } else {
          _packages = [];
          _selectedPackageName = null;
        }
        update(); // Trigger UI update
      }
    } catch (e) {
      debugPrint("Silent cart fetch failed: $e");
      // Don't show toast on silent fetch failure
    }
  }

  // Add item to cart with package and addons support
  Future<void> addToCart(
    int menuId,
    int quantity, {
    int? addonMenuId,
    List<int>? addonIds,
    String? packageName,
    bool skipDialog = false, // Skip dialog when explicitly providing packageName
    bool autoIncrementIfExists = false, // Auto-increment quantity if item exists (for programmatic adds)
    RestaurantModel? restaurant, // Restaurant to validate operating hours
  }) async {
    try {
      // Check if restaurant is open before adding to cart
      if (restaurant != null && !restaurant.isOpen()) {
        final hours = restaurant.getOperatingHoursText();
        _showErrorBottomSheet(
          title: 'Restaurant Closed',
          message: '${restaurant.name} is currently closed.\n\nOperating hours: $hours',
          autoDismiss: true,
        );
        return;
      }

      // If autoIncrementIfExists is true, check if item exists and auto-increment
      // This is used for programmatic quantity increases (not user-initiated adds)
      if (autoIncrementIfExists && !isCartEmpty) {
        // Try to find the item in existing packages
        for (var package in _packages) {
          final item = _findItemInPackage(menuId, package.name, addonIds);
          if (item != null) {
            // Item exists, auto-increment its quantity
            final newQuantity = item.quantity + quantity;
            await updateCartItemQuantity(
              item.id,
              quantity: newQuantity,
              packageName: package.name,
            );
            return;
          }
        }
      }

      // Show package selection dialog only if:
      // 1. No package is explicitly provided
      // 2. No package is currently selected by user
      // 3. Dialog is not skipped
      if (packageName == null && _selectedPackageName == null && !skipDialog) {
        await showPackageSelectionAndAddToCart(menuId, quantity, addonIds: addonIds, restaurant: restaurant);
        return;
      }

      // Determine package name with priority:
      // 1. Explicitly provided packageName
      // 2. User-selected package (_selectedPackageName)
      // 3. First item: Pack 1
      // 4. Existing packages: use first
      // 5. Fallback: Pack 1
      String finalPackageName;
      if (packageName != null) {
        finalPackageName = packageName;
      } else if (_selectedPackageName != null) {
        finalPackageName = _selectedPackageName!;
        debugPrint('📦 Using selected package: $_selectedPackageName');
      } else if (isCartEmpty) {
        // First item in cart, default to Pack 1
        finalPackageName = 'Pack 1';
      } else if (packageNames.isNotEmpty) {
        // Use existing package
        finalPackageName = packageNames.first;
      } else {
        // Fallback to Pack 1
        finalPackageName = 'Pack 1';
      }

      // IMPORTANT: Check if item already exists in the selected package
      // If it exists, increment quantity instead of creating duplicate
      final existingItem = _findItemInPackage(menuId, finalPackageName, addonIds);

      if (existingItem != null) {
        // Item with same addons exists in this package, increase quantity instead
        final newQuantity = existingItem.quantity + quantity;
        debugPrint('📦 Item already exists in package "$finalPackageName", incrementing quantity to $newQuantity');
        // Note: Don't send addons when updating quantity - they're already set on the item
        await updateCartItemQuantity(
          existingItem.id,
          quantity: newQuantity,
          packageName: finalPackageName,
        );
        return;
      }

      // Set specific item being added
      _addingToCartItemId = menuId;
      setAddingToCartState(true);

      dynamic data = {
        'menu_id': menuId,
        'quantity': quantity,
        'package_name': finalPackageName,
      };

      // Add addons if provided (new API format expects array of addon IDs)
      if (addonIds != null && addonIds.isNotEmpty) {
        data['addons'] = addonIds;
      } else if (addonMenuId != null) {
        // Support legacy single addon parameter
        data['addons'] = [addonMenuId];
      }

      APIResponse response = await cartService.addToMenuCart(data);

      if (response.status.toLowerCase() == "success") {
        // Refresh cart after adding item
        await fetchCart();

        // Find the newly added item to get its name
        String itemName = "Item";
        try {
          // Look for the item in the cart
          for (var package in _packages) {
            for (var item in package.items) {
              if (item.purchasableId == menuId) {
                itemName = item.purchasable?.name ?? "Item";
                break;
              }
            }
          }
        } catch (e) {
          debugPrint("Error getting item name: $e");
        }

        // Show success bottom sheet
        _showAddToCartSuccessBottomSheet(itemName, quantity);
      } else {
        _showErrorBottomSheet(
          title: 'Unable to Add Item',
          message: response.message,
          autoDismiss: true,
        );
      }
    } catch (e) {
      _showErrorBottomSheet(
        title: 'Error',
        message: 'Failed to add item to cart. Please try again.',
        autoDismiss: true,
      );
      debugPrint('Failed to add item to cart: $e');
    } finally {
      _addingToCartItemId = null; // Clear specific item
      setAddingToCartState(false);
    }
  }

  // Helper method to find item in a specific package with matching addons
  CartItem? _findItemInPackage(int menuId, String packageName, List<int>? addonIds) {
    try {
      // Find the package
      final package = _packages.firstWhere(
        (p) => p.name == packageName,
        orElse: () => throw Exception('Package not found'),
      );

      // Find item with matching menu ID in this package
      final matchingItems = package.items.where((item) => item.purchasableId == menuId);

      if (matchingItems.isEmpty) return null;

      // If no addons specified, return first matching item
      if (addonIds == null || addonIds.isEmpty) {
        // Return item only if it has no addons
        return matchingItems.firstWhere(
          (item) => item.addons.isEmpty,
          orElse: () => null as CartItem,
        );
      }

      // Find item with exact matching addons
      for (var item in matchingItems) {
        if (_hasMatchingAddons(item, addonIds)) {
          return item;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Helper method to check if cart item has matching addons
  bool _hasMatchingAddons(CartItem item, List<int> addonIds) {
    // Get addon IDs from cart item
    final itemAddonIds = item.addons.map((a) => a.addonId).toList()..sort();
    final requestedAddonIds = List<int>.from(addonIds)..sort();

    // Check if addon lists match
    if (itemAddonIds.length != requestedAddonIds.length) return false;

    for (int i = 0; i < itemAddonIds.length; i++) {
      if (itemAddonIds[i] != requestedAddonIds[i]) return false;
    }

    return true;
  }

  // Show package selection dialog and add to cart
  Future<void> showPackageSelectionAndAddToCart(
    int menuId,
    int quantity, {
    List<int>? addonIds,
    RestaurantModel? restaurant,
  }) async {
    // Get context for showing dialog
    final context = Get.context;
    if (context == null) return;

    // Always show dialog, even if cart is empty (to allow user to name the first package)
    final result = await Get.dialog<String>(
      PackageSelectionDialog(
        existingPackages: packageNames,
        currentPackage: _selectedPackageName ?? (isCartEmpty ? 'Pack 1' : null),
      ),
    );

    if (result != null) {
      // User selected or created a package
      await addToCart(
        menuId,
        quantity,
        addonIds: addonIds,
        packageName: result,
        skipDialog: true, // Skip dialog since we already got the package name
        restaurant: restaurant,
      );
    }
  }

  // Update cart item (quantity and/or addons)
  // Note: package_name is REQUIRED since every cart item is always in a package
  // quantity is optional (only needed when updating quantity)
  // addonIds is optional (only needed when updating addons)
  Future<void> updateCartItemQuantity(int itemId, {dynamic quantity, List<int>? addonIds, String? packageName}) async {
    try {
      setUpdatingCartState(true);

      // Find the item to get its package if not provided
      String? finalPackageName = packageName;

      if (finalPackageName == null) {
        // Find the item in packages to get its package name
        bool found = false;
        for (var package in _packages) {
          for (var cartItem in package.items) {
            if (cartItem.id == itemId) {
              finalPackageName = package.name;
              found = true;
              break;
            }
          }
          if (found) break;
        }

        if (finalPackageName == null) {
          _showErrorBottomSheet(
            title: 'Item Not Found',
            message: 'The item you\'re trying to update could not be found in your cart.',
            autoDismiss: true,
          );
          return;
        }
      }

      // Find the cart item to get the purchasable_id
      CartItem? cartItem;
      for (var package in _packages) {
        for (var item in package.items) {
          if (item.id == itemId) {
            cartItem = item;
            break;
          }
        }
        if (cartItem != null) break;
      }

      if (cartItem == null) {
        _showErrorBottomSheet(
          title: 'Item Not Found',
          message: 'The item you\'re trying to update could not be found in your cart.',
          autoDismiss: true,
        );
        return;
      }

      // Store old quantity for rollback if needed
      final oldQuantity = cartItem.quantity;

      // Optimistic update - update UI immediately
      if (quantity != null) {
        final newQuantity = quantity is int ? quantity : int.parse(quantity.toString());
        cartItem.quantity = newQuantity;
        update(); // Update UI immediately
      }

      Map<String, dynamic> data = {
        'package_name': finalPackageName, // Always include package name (REQUIRED)
      };

      // Only add quantity if explicitly provided (optional)
      if (quantity != null) {
        // Parse to int if it's a string, otherwise use as is
        data['quantity'] = quantity is int ? quantity : int.parse(quantity.toString());
      }
      // Only add addons if explicitly provided (optional)
      if (addonIds != null) {
        data['addons'] = addonIds;
      }

      // Use the correct endpoint for updating cart item

      customDebugPrint("cart item id: $itemId");
      customDebugPrint("purchasable id: ${cartItem.purchasableId}");
      customDebugPrint("Request route: /menu-cart/items/${cartItem.purchasableId}");
      customDebugPrint("Request body: ${data.toString()}");

      APIResponse response = await cartService.updateMenuCart(
        id: cartItem.id, // Use purchasable ID instead of cart item ID
        data: data,
      );

      customDebugPrint("Response status: ${response.status}");
      customDebugPrint("Response message: ${response.message}");
      customDebugPrint("Response data: ${response.data}");

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Cart updated successfully", isError: false);
        // Silently refresh cart in background without showing loader
        await _fetchCartSilently();
      } else {
        customDebugPrint("=== ERROR UPDATING CART ===");
        customDebugPrint("Route called: /menu-cart/items/${cartItem.purchasableId}");
        customDebugPrint("Request body sent: ${data.toString()}");
        customDebugPrint("Error Status: ${response.status}");
        customDebugPrint("Error Message: ${response.message}");
        customDebugPrint("Error Data: ${response.data}");
        customDebugPrint("=========================");
        _showErrorBottomSheet(
          title: 'Update Failed',
          message: response.message.isNotEmpty ? response.message : 'Unable to update cart item. Please try again.',
          autoDismiss: true,
        );
      }
    } catch (e, stackTrace) {
      customDebugPrint("Exception updating cart: $e");
      customDebugPrint("Stack trace: $stackTrace");
      _showErrorBottomSheet(
        title: 'Update Failed',
        message: 'Unable to update cart item. Please try again.',
        autoDismiss: true,
      );
    } finally {
      setUpdatingCartState(false);
    }
  }

  // Decrease quantity for a specific menu item
  Future<void> decreaseQuantity(int menuId) async {
    CartItem? item = getCartItemByPurchasableId(menuId);
    if (item != null && item.quantity > 1) {
      await updateCartItemQuantity(item.id, quantity: item.quantity - 1);
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
        _showErrorBottomSheet(
          title: 'Remove Failed',
          message: response.message.isNotEmpty ? response.message : 'Unable to remove item from cart. Please try again.',
          autoDismiss: true,
        );
      }
    } catch (e) {
      _showErrorBottomSheet(
        title: 'Remove Failed',
        message: 'Unable to remove item from cart. Please try again.',
        autoDismiss: true,
      );
      debugPrint('Failed to remove item from cart: $e');
    } finally {
      setRemovingFromCartState(false);
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    if (isCartEmpty) return;

    try {
      setLoadingState(true);

      // Use the dedicated clear cart endpoint
      APIResponse response = await cartService.clearCart();

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Cart cleared successfully", isError: false);
        await fetchCart();

        // Clear selected package when cart is manually cleared
        clearSelectedPackage();
        debugPrint('🧹 Cleared selected package after manual cart clear');
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
    // Calculate subtotal from all packages
    return _packages.fold(0.0, (sum, package) {
      return sum + (double.tryParse(package.cost) ?? 0.0);
    });
  }

  double get deliveryFee => 600.00;
  double get serviceCharge => 200.00;
  double get total => subtotal + deliveryFee + serviceCharge;

  int get itemCount {
    return _packages.fold(0, (sum, package) {
      return sum + package.items.fold(0, (itemSum, item) => itemSum + item.quantity);
    });
  }

  List<CartItem> get cartItems {
    // Get all items from all packages
    return _packages.expand((package) => package.items).toList();
  }

  bool get isCartEmpty {
    return _packages.isEmpty;
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

        // Extract order details from response
        final orderNumber = response.data['order_number'] ?? response.data['id']?.toString() ?? 'N/A';
        final orderId = response.data['id'];

        // Refresh the cart after successful order
        await refreshCart();

        // Navigate to success screen, clearing entire stack
        Get.offAllNamed(
          Routes.ORDER_SUCCESS_SCREEN,
          arguments: {
            'orderId': orderId,
            'orderNumber': orderNumber,
            'totalAmount': total,
            'paymentMethod': 'cash',
            'deliveryAddress': currentLocation.value,
          },
        );
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

        // Extract order details from response
        final orderNumber = response.data['order_number'] ?? response.data['id']?.toString() ?? 'N/A';
        final orderId = response.data['id'];

        // Refresh the cart after successful order
        await refreshCart();

        // Navigate to success screen, clearing entire stack
        Get.offAllNamed(
          Routes.ORDER_SUCCESS_SCREEN,
          arguments: {
            'orderId': orderId,
            'orderNumber': orderNumber,
            'totalAmount': total,
            'paymentMethod': 'wallet',
            'deliveryAddress': currentLocation.value,
          },
        );
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
  String? lastOrderNumber;

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

        // Extract order details from response
        lastOrderNumber = response.data['order_number'] ?? response.data['id']?.toString() ?? 'N/A';

        // Refresh the cart after successful order
        await refreshCart();
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
      // Search through all packages
      for (var package in _packages) {
        for (var item in package.items) {
          if (item.purchasableId == purchasableId) {
            return item;
          }
        }
      }
      return null;
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

    // Clear selected package if cart is empty (after successful checkout)
    if (isCartEmpty && _selectedPackageName != null) {
      clearSelectedPackage();
      debugPrint('🧹 Cleared selected package after checkout');
    }
  }

  // Package-aware helper methods

  // Get cart items by package
  List<CartItem> getItemsByPackage(String packageName) {
    try {
      final package = _packages.firstWhere((p) => p.name == packageName);
      return package.items;
    } catch (e) {
      return [];
    }
  }

  // Get package by name
  CartPackage? getPackageByName(String packageName) {
    try {
      return _packages.firstWhere((p) => p.name == packageName);
    } catch (e) {
      return null;
    }
  }

  // Get cart item by menu ID and optional package
  CartItem? getCartItemByMenuId(int menuId, {int? packageId}) {
    try {
      for (var package in _packages) {
        for (var item in package.items) {
          if (packageId != null) {
            if (item.purchasableId == menuId && item.cartPackageId == packageId) {
              return item;
            }
          } else {
            if (item.purchasableId == menuId) {
              return item;
            }
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Addon helper methods (Updated for new structure)
  // Note: In the new API, addons are nested within cart items, not separate items

  bool isAddonInCart(int mainItemId, int addonId) {
    try {
      // Find the main cart item across all packages
      CartItem? mainItem;
      for (var package in _packages) {
        for (var item in package.items) {
          if (item.purchasableId == mainItemId) {
            mainItem = item;
            break;
          }
        }
        if (mainItem != null) break;
      }

      if (mainItem == null) return false;

      // Check if addon exists in the addons array
      return mainItem.addons.any((addon) => addon.addonId == addonId);
    } catch (e) {
      return false;
    }
  }

  int getAddonQuantityInCart(int mainItemId, int addonId) {
    try {
      // Find the main cart item across all packages
      CartItem? mainItem;
      for (var package in _packages) {
        for (var item in package.items) {
          if (item.purchasableId == mainItemId) {
            mainItem = item;
            break;
          }
        }
        if (mainItem != null) break;
      }

      if (mainItem == null) return 0;

      // Find the addon and get its quantity
      final addon = mainItem.addons.firstWhere(
        (addon) => addon.addonId == addonId,
        orElse: () => CartItemAddon(
          id: 0,
          cartItemId: 0,
          addonId: 0,
          quantity: 0,
          price: "0.00",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      return addon.quantity;
    } catch (e) {
      return 0;
    }
  }

  // Addon management with API endpoints

  Future<void> removeAddonFromCart(int mainItemId, int addonId) async {
    try {
      setUpdatingCartState(true);

      // Find the cart item across all packages
      CartItem? cartItem;
      for (var package in _packages) {
        for (var item in package.items) {
          if (item.purchasableId == mainItemId) {
            cartItem = item;
            break;
          }
        }
        if (cartItem != null) break;
      }

      if (cartItem == null) {
        showToast(message: "Cart item not found", isError: true);
        return;
      }

      APIResponse response = await cartService.removeAddonFromCartItem(
        cartItemId: cartItem.id,
        addonId: addonId,
      );

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Addon removed successfully", isError: false);
        await fetchCart();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to remove addon: $e", isError: true);
      debugPrint('Error removing addon from cart: $e');
    } finally {
      setUpdatingCartState(false);
    }
  }

  Future<void> increaseAddonQuantity(int mainItemId, int addonId) async {
    try {
      setUpdatingCartState(true);

      // Find the cart item across all packages
      CartItem? cartItem;
      for (var package in _packages) {
        for (var item in package.items) {
          if (item.purchasableId == mainItemId) {
            cartItem = item;
            break;
          }
        }
        if (cartItem != null) break;
      }

      if (cartItem == null) {
        showToast(message: "Cart item not found", isError: true);
        return;
      }

      // Get current addon quantity
      final currentQuantity = getAddonQuantityInCart(mainItemId, addonId);
      final newQuantity = currentQuantity + 1;

      APIResponse response = await cartService.updateAddonQuantity(
        cartItemId: cartItem.id,
        addonId: addonId,
        quantity: newQuantity,
      );

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Addon quantity updated", isError: false);
        await fetchCart();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to update addon quantity: $e", isError: true);
      debugPrint('Error increasing addon quantity: $e');
    } finally {
      setUpdatingCartState(false);
    }
  }

  Future<void> decreaseAddonQuantity(int mainItemId, int addonId) async {
    try {
      setUpdatingCartState(true);

      // Find the cart item across all packages
      CartItem? cartItem;
      for (var package in _packages) {
        for (var item in package.items) {
          if (item.purchasableId == mainItemId) {
            cartItem = item;
            break;
          }
        }
        if (cartItem != null) break;
      }

      if (cartItem == null) {
        showToast(message: "Cart item not found", isError: true);
        return;
      }

      // Get current addon quantity
      final currentQuantity = getAddonQuantityInCart(mainItemId, addonId);

      if (currentQuantity > 1) {
        // Decrease quantity
        final newQuantity = currentQuantity - 1;

        APIResponse response = await cartService.updateAddonQuantity(
          cartItemId: cartItem.id,
          addonId: addonId,
          quantity: newQuantity,
        );

        if (response.status.toLowerCase() == "success") {
          showToast(message: "Addon quantity updated", isError: false);
          await fetchCart();
        } else {
          showToast(message: response.message, isError: true);
        }
      } else {
        // Remove addon if quantity would be 0
        await removeAddonFromCart(mainItemId, addonId);
      }
    } catch (e) {
      showToast(message: "Failed to update addon quantity: $e", isError: true);
      debugPrint('Error decreasing addon quantity: $e');
    } finally {
      setUpdatingCartState(false);
    }
  }

  // Add addons to existing cart item
  Future<void> addAddonsToCartItem(int cartItemId, List<int> addonIds) async {
    try {
      setUpdatingCartState(true);

      APIResponse response = await cartService.addAddonToCartItem(
        cartItemId: cartItemId,
        addonIds: addonIds,
      );

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Addons added successfully", isError: false);
        await fetchCart();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to add addons: $e", isError: true);
      debugPrint('Error adding addons to cart item: $e');
    } finally {
      setUpdatingCartState(false);
    }
  }

  // Package-aware quantity management

  // Increase quantity of a cart item (package-aware)
  Future<void> increaseItemQuantity(int cartItemId) async {
    try {
      // Find the item across all packages
      CartItem? item;
      for (var package in _packages) {
        for (var cartItem in package.items) {
          if (cartItem.id == cartItemId) {
            item = cartItem;
            break;
          }
        }
        if (item != null) break;
      }

      if (item == null) {
        debugPrint('Cart item not found: $cartItemId');
        return;
      }

      await updateCartItemQuantity(cartItemId, quantity: item.quantity + 1);
    } catch (e) {
      debugPrint('Error increasing item quantity: $e');
    }
  }

  // Decrease quantity of a cart item (package-aware)
  Future<void> decreaseItemQuantity(int cartItemId) async {
    try {
      // Find the item across all packages
      CartItem? item;
      for (var package in _packages) {
        for (var cartItem in package.items) {
          if (cartItem.id == cartItemId) {
            item = cartItem;
            break;
          }
        }
        if (item != null) break;
      }

      if (item == null) {
        debugPrint('Cart item not found: $cartItemId');
        return;
      }

      if (item.quantity > 1) {
        await updateCartItemQuantity(cartItemId, quantity: item.quantity - 1);
      } else {
        // Remove item if quantity would be 0
        await removeFromCart(cartItemId);
      }
    } catch (e) {
      debugPrint('Error decreasing item quantity: $e');
    }
  }

  // Remove entire cart item from package
  Future<void> removeCartItem(int cartItemId) async {
    await removeFromCart(cartItemId);
  }

  // Duplicate package - creates a copy of the package with all its items
  Future<void> duplicatePackage(int packageId) async {
    try {
      setLoadingState(true);

      APIResponse response = await cartService.duplicatePackage(packageId);

      if (response.status.toLowerCase() == "success") {
        showToast(message: "Package duplicated successfully", isError: false);
        // Refresh cart to show the new package
        await fetchCart();
      } else {
        showToast(message: response.message, isError: true);
      }
    } catch (e) {
      showToast(message: "Failed to duplicate package: $e", isError: true);
      debugPrint('Error duplicating package: $e');
    } finally {
      setLoadingState(false);
    }
  }

  // Show add to cart success bottom sheet
  void _showAddToCartSuccessBottomSheet(String itemName, int quantity) {
    Get.bottomSheet(
      AddToCartSuccessBottomSheet(
        itemName: itemName,
        quantity: quantity,
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }

  // Show error bottom sheet
  void _showErrorBottomSheet({
    required String title,
    required String message,
    String? actionButtonText,
    VoidCallback? onActionPressed,
    bool autoDismiss = true,
  }) {
    Get.bottomSheet(
      ErrorBottomSheet(
        title: title,
        message: message,
        actionButtonText: actionButtonText,
        onActionPressed: onActionPressed,
        autoDismiss: autoDismiss,
      ),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
