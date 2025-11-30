import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryService extends CoreService {
  Future<DeliveryService> init() async => this;

  Future<APIResponse> createDelivery(dynamic data) async {
    return await send("/shipments", data);
  }

  Future<APIResponse> createParcelDelivery(dynamic data) async {
    return await send("/customers/deliveries", data);
  }

  Future<APIResponse> getAllParcelDeliveries() async {
    return await fetch("/customers/deliveries");
  }

  Future<APIResponse> getParcelDelivery(int id) async {
    return await fetch("/customers/deliveries/$id");
  }

  Future<APIResponse> confirmDelivery(dynamic data) async {
    return await send(
      "/shipments/${data['tracking_id']}?courier_id=${data['courier_id']}&action=${data['action']}&payment_method_id=${data['payment_method_id']}",
      null,
    );
  }

  Future<APIResponse> confirmParcelDelivery({
    required String trackingId,
    required int courierId,
    required String paymentMethodCode,
  }) async {
    return await send(
      "/customers/deliveries/$trackingId/trigger?action=confirm",
      {'courier_type_id': courierId, 'payment_method_code': paymentMethodCode},
    );
  }

  Future<APIResponse> updateDeliveryStatus(dynamic data) async {
    return await send(
      "/shipments/${data['tracking_id'].toString()}?action=${data['action']}",
      null,
    );
  }

  Future<APIResponse> rateDelivery({
    required dynamic data,
    required int deliveryId,
  }) async {
    return await send("/shipments/$deliveryId/ratings", data);
  }

  Future<APIResponse> raiseDispute({required dynamic data}) async {
    return await send("/disputes", data);
  }

  Future<APIResponse> getAllDeliveries(dynamic data) async {
    return await fetch(
      "/shipments?page=${data['page']}&per_page=${data['per_page']}",
    );
  }

  Future<APIResponse> searchDeliveries(dynamic data) async {
    return await fetch("/shipments?search=${data['search']}");
  }

  Future<APIResponse> getDelivery(dynamic data) async {
    return await fetch("/shipments/${data['id']}");
  }

  Future<APIResponse> trackDelivery(dynamic data) async {
    return await fetch("/shipments/tracking/${data['tracking_id']}");
  }

  Future<APIResponse> trackParcelDelivery(String trackingId) async {
    return await fetch("/customers/deliveries/tracking/$trackingId");
  }

  Future<APIResponse> rateParcelDelivery({
    required int deliveryId,
    required dynamic data,
  }) async {
    return await send("/customers/deliveries/$deliveryId/ratings", data);
  }

  Future<APIResponse> getRider(dynamic data) async {
    return await send("/api/auth/password-reset", data);
  }
}
