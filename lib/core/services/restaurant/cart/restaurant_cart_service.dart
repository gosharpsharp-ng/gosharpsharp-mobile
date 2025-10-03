import 'package:gosharpsharp/core/utils/exports.dart';

class RestaurantCartService extends CoreService {
  Future<RestaurantCartService> init() async => this;

  Future<APIResponse> getMenuCart() async {
    return await fetch("/menu-cart");
  }

  Future<APIResponse> removeFromMenuCart(dynamic data) async {
    return await remove("/menu-cart/items/${data['id']}");
  }

  Future<APIResponse> updateMenuCart({required int id, dynamic data}) async {
    return await update("/menu-cart/items/$id", data);
  }

  Future<APIResponse> clearCart() async {
    return await remove("/menu-cart");
  }

  Future<APIResponse> addToMenuCart(dynamic data) async {
    return await send("/menu-cart/items", data);
  }

  Future<APIResponse> createOrder(dynamic data) async {
    return await send("/customers/orders/menu/create-and-pay", data);
  }
}
