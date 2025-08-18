// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryModel _$DeliveryModelFromJson(Map<String, dynamic> json) =>
    DeliveryModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      trackingId: json['tracking_id'] as String,
      cost: json['cost'] as String?,
      status: json['status'] as String?,
      originLocation: ShipmentLocation.fromJson(
          json['origin_location'] as Map<String, dynamic>),
      destinationLocation: ShipmentLocation.fromJson(
          json['destination_location'] as Map<String, dynamic>),
      receiver: Receiver.fromJson(json['receiver'] as Map<String, dynamic>),
      sender: json['sender'] == null
          ? null
          : Sender.fromJson(json['sender'] as Map<String, dynamic>),
      rider: json['rider'] == null
          ? null
          : Rider.fromJson(json['rider'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      distance: DeliveryModel._parseDistance(json['distance']),
      courierTypePrices: (json['courier_type_prices'] as List<dynamic>?)
          ?.map((e) => CourierTypePrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: (json['payment_methods'] as List<dynamic>?)
          ?.map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      rating: json['rating'] == null
          ? null
          : Rating.fromJson(json['rating'] as Map<String, dynamic>),
      timestamp: json['timestamp'] as String? ?? '',
    );

Map<String, dynamic> _$DeliveryModelToJson(DeliveryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'tracking_id': instance.trackingId,
      'status': instance.status,
      'cost': instance.cost,
      'origin_location': instance.originLocation,
      'destination_location': instance.destinationLocation,
      'receiver': instance.receiver,
      'sender': instance.sender,
      'rider': instance.rider,
      'items': instance.items,
      'distance': instance.distance,
      'courier_type_prices': instance.courierTypePrices,
      'payment_methods': instance.paymentMethods,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'timestamp': instance.timestamp,
      'rating': instance.rating,
    };

ShipmentLocation _$ShipmentLocationFromJson(Map<String, dynamic> json) =>
    ShipmentLocation(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      locationableType: json['locationable_type'] as String,
      locationableId: (json['locationable_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ShipmentLocationToJson(ShipmentLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'locationable_type': instance.locationableType,
      'locationable_id': instance.locationableId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Receiver _$ReceiverFromJson(Map<String, dynamic> json) => Receiver(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      shipmentId: (json['shipment_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ReceiverToJson(Receiver instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'shipment_id': instance.shipmentId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Sender _$SenderFromJson(Map<String, dynamic> json) => Sender(
      id: (json['id'] as num).toInt(),
      avatar: json['avatar'] as String?,
      firstName: json['fname'] as String?,
      lastName: json['lname'] as String?,
      phone: json['phone'] as String,
      dob: json['dob'] as String?,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      referralCode: json['referral_code'] as String,
      referredBy: json['referred_by'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      failedLoginAttempts: (json['failed_login_attempts'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$SenderToJson(Sender instance) => <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'fname': instance.firstName,
      'lname': instance.lastName,
      'phone': instance.phone,
      'dob': instance.dob,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
      'referral_code': instance.referralCode,
      'referred_by': instance.referredBy,
      'last_login_at': instance.lastLoginAt,
      'failed_login_attempts': instance.failedLoginAttempts,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Rider _$RiderFromJson(Map<String, dynamic> json) => Rider(
      id: (json['id'] as num).toInt(),
      avatar: json['avatar'] as String?,
      firstName: json['fname'] as String?,
      lastName: json['lname'] as String?,
      phone: json['phone'] as String,
      dob: json['dob'] as String?,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      referralCode: json['referral_code'] as String,
      referredBy: json['referred_by'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      failedLoginAttempts: (json['failed_login_attempts'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$RiderToJson(Rider instance) => <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'fname': instance.firstName,
      'lname': instance.lastName,
      'phone': instance.phone,
      'dob': instance.dob,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
      'referral_code': instance.referralCode,
      'referred_by': instance.referredBy,
      'last_login_at': instance.lastLoginAt,
      'failed_login_attempts': instance.failedLoginAttempts,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String,
      weight: json['weight'] as String,
      quantity: (json['quantity'] as num).toInt(),
      image: json['image'] as String,
      shipmentId: (json['shipment_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'weight': instance.weight,
      'quantity': instance.quantity,
      'shipment_id': instance.shipmentId,
      'created_at': instance.createdAt,
      'image': instance.image,
      'updated_at': instance.updatedAt,
    };

CourierTypePrice _$CourierTypePriceFromJson(Map<String, dynamic> json) =>
    CourierTypePrice(
      courierTypeId: (json['courier_type_id'] as num).toInt(),
      courierType: json['courier_type'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$CourierTypePriceToJson(CourierTypePrice instance) =>
    <String, dynamic>{
      'courier_type_id': instance.courierTypeId,
      'courier_type': instance.courierType,
      'price': instance.price,
    };

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      id: (json['id'] as num).toInt(),
      points: json['points'] as num,
      review: json['review'] as String,
      shipmentId: (json['shipment_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'id': instance.id,
      'points': instance.points,
      'review': instance.review,
      'shipment_id': instance.shipmentId,
      'user_id': instance.userId,
    };
