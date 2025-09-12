import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:gosharpsharp/modules/cart/views/checkout_screen.dart';
import 'package:gosharpsharp/modules/cart/views/order_tracking_screen.dart';

class CartController extends GetxController {
  RxList<CartItem> cartItems = <CartItem>[].obs;
  RxBool isLoading = false.obs;
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
    // Add mock cart items for testing
    addMockItems();
  }

  void addMockItems() {
    cartItems.addAll([
      CartItem(
        id: '1',
        name: 'Meal title',
        price: 2000.00,
        quantity: 1,
        image: PngAssets.chow1,
        options: 'Opt. 3',
      ),
      CartItem(
        id: '2',
        name: 'Meal title',
        price: 3000.00,
        quantity: 1,
        image: PngAssets.chow2,
        options: 'Opt. 3',
      ),
      CartItem(
        id: '3',
        name: 'Meal title',
        price: 3000.00,
        quantity: 1,
        image: PngAssets.chow3,
        options: 'Opt. 3',
      ),
      CartItem(
        id: '4',
        name: 'Meal title',
        price: 2500.00,
        quantity: 1,
        image: PngAssets.chow1,
        options: 'Opt. 3',
      ),
      CartItem(
        id: '5',
        name: 'Meal title',
        price: 2500.00,
        quantity: 1,
        image: PngAssets.chow2,
        options: 'Opt. 3',
      ),
      CartItem(
        id: '6',
        name: 'Meal title',
        price: 2000.00,
        quantity: 1,
        image: PngAssets.chow3,
        options: 'Opt. 3',
      ),
    ]);
  }

  void clearCart() {
    cartItems.clear();
  }

  void removeItem(String itemId) {
    cartItems.removeWhere((item) => item.id == itemId);
  }

  void updateQuantity(String itemId, int quantity) {
    int index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity > 0) {
        cartItems[index] = cartItems[index].copyWith(quantity: quantity);
      } else {
        removeItem(itemId);
      }
    }
  }

  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get deliveryFee => 600.00;
  double get serviceCharge => 1200.00;
  double get total => subtotal + deliveryFee + serviceCharge;

  void selectPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> placeOrder() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    orderPlaced.value = true;
    isLoading.value = false;

    // Navigate to checkout success
    Get.to(() => CheckoutScreen());
  }

  void trackOrderProgress() {
    Get.to(() => OrderTrackingScreen());
  }

  void goBackToHome() {
    orderPlaced.value = false;
    cartItems.clear();
    Get.offAllNamed(Routes.DASHBOARD);
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String image;
  final String options;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.options,
  });

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? image,
    String? options,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image: image ?? this.image,
      options: options ?? this.options,
    );
  }
}
