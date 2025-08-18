import 'package:gosharpsharp/core/models/payment_method_model.dart';
import 'package:gosharpsharp/core/utils/exports.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_response_model.g.dart';

@JsonSerializable()
class DeliveryResponseModel {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'tracking_id')
  final String trackingId;
  final String? status;
  @JsonKey(name: 'origin_location')
  final ShipmentLocation originLocation;
  @JsonKey(name: 'destination_location')
  final ShipmentLocation destinationLocation;
  final Receiver receiver;
  final Sender? sender;
  final List<Item> items;
  final double distance;
  @JsonKey(name: 'courier_type_prices')
  final List<CourierTypePrice> courierTypePrices;
  @JsonKey(name: 'payment_methods')
  final List<PaymentMethodModel> paymentMethods;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'timestamp',defaultValue: "")
  final String? timestamp;

  DeliveryResponseModel({
    required this.id,
    required this.userId,
    required this.trackingId,
    this.status,
    required this.originLocation,
    required this.destinationLocation,
    required this.receiver,
    required this.sender,
    required this.items,
    required this.distance,
    required this.courierTypePrices,
    required this.paymentMethods,
    required this.createdAt,
    required this.updatedAt,
    required this.timestamp,
  });

  factory DeliveryResponseModel.fromJson(Map<String, dynamic> json) => _$DeliveryResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryResponseModelToJson(this);
}

