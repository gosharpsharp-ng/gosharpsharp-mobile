import 'dart:developer';

import 'package:gosharpsharp/core/utils/exports.dart';

class DeliveryService extends CoreService {
  Future<DeliveryService> init() async => this;

  Future<APIResponse> createDelivery(dynamic data) async {
    return await send("/shipments", data);
  }

  Future<APIResponse> confirmDelivery(dynamic data) async {
    return await send(
        "/shipments/${data['tracking_id']}?courier_id=${data['courier_id']}&action=${data['action']}&payment_method_id=${data['payment_method_id']}",
        null);
  }

  Future<APIResponse> updateDeliveryStatus(dynamic data) async {
    return await send(
        "/shipments/${data['tracking_id'].toString()}?action=${data['action']}",
        null);
  }

  Future<APIResponse> rateDelivery(
      {required dynamic data, required int deliveryId}) async {
    return await send("/shipments/$deliveryId/ratings", data);
  }

  Future<APIResponse> raiseDispute({required dynamic data}) async {
    return await send("/disputes", data);
  }

  Future<APIResponse> getAllDeliveries(dynamic data) async {
    return await fetch(
        "/shipments?page=${data['page']}&per_page=${data['per_page']}");
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

  Future<APIResponse> getRider(dynamic data) async {
    return await send("/api/auth/password-reset", data);
  }
}
