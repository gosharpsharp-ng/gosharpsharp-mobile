// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryResponseModel _$DeliveryResponseModelFromJson(
        Map<String, dynamic> json) =>
    DeliveryResponseModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      trackingId: json['tracking_id'] as String,
      status: json['status'] as String?,
      originLocation: ShipmentLocation.fromJson(
          json['origin_location'] as Map<String, dynamic>),
      destinationLocation: ShipmentLocation.fromJson(
          json['destination_location'] as Map<String, dynamic>),
      receiver: Receiver.fromJson(json['receiver'] as Map<String, dynamic>),
      sender: json['sender'] == null
          ? null
          : Sender.fromJson(json['sender'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      distance: (json['distance'] as num).toDouble(),
      courierTypePrices: (json['courier_type_prices'] as List<dynamic>)
          .map((e) => CourierTypePrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: (json['payment_methods'] as List<dynamic>)
          .map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      timestamp: json['timestamp'] as String? ?? '',
    );

Map<String, dynamic> _$DeliveryResponseModelToJson(
        DeliveryResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'tracking_id': instance.trackingId,
      'status': instance.status,
      'origin_location': instance.originLocation,
      'destination_location': instance.destinationLocation,
      'receiver': instance.receiver,
      'sender': instance.sender,
      'items': instance.items,
      'distance': instance.distance,
      'courier_type_prices': instance.courierTypePrices,
      'payment_methods': instance.paymentMethods,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'timestamp': instance.timestamp,
    };
