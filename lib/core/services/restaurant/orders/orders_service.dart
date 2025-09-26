import 'package:gosharpsharp/core/utils/exports.dart';

class OrdersService extends CoreService {
  Future<OrdersService> init() async => this;

  Future<APIResponse> getAllOrders(dynamic data) async {
    return await fetch("/customers/orders/menu");
  }

  Future<APIResponse> getOrderById(dynamic data) async {
    return await fetch("/customers/menus/${data['id']}");
  }

  Future<APIResponse> updateOrder(dynamic data, int orderId) async {
    return await generalPatch("/restaurants/orders/$orderId/status", data);
  }

  Future<APIResponse> createOrder(dynamic data) async {
    return await generalPatch("/customers/orders/menu/create-and-pay", data);
  }
}
