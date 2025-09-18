import 'package:gosharpsharp/core/utils/exports.dart';

class OrdersService extends CoreService {
  Future<OrdersService> init() async => this;

  Future<APIResponse> getAllOrders(dynamic data) async {
    return await fetch(
        "/restaurant/orders");
  }
  Future<APIResponse> getOrderById(dynamic data) async {
    return await fetch("/restaurants/orders/${data['id']}");
  }


  Future<APIResponse> updateOrder(dynamic data, int orderId) async {
    return await generalPatch("restaurants/orders/$orderId/status", data);
  }


}
