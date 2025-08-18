import 'package:gosharpsharp/core/models/payment_method_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_model.g.dart';

@JsonSerializable()
class DeliveryModel {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'tracking_id')
  final String trackingId;
  final String? status;
  final String? cost;
  @JsonKey(name: 'origin_location')
  final ShipmentLocation originLocation;
  @JsonKey(name: 'destination_location')
  final ShipmentLocation destinationLocation;
  final Receiver receiver;
  final Sender? sender;
  final Rider? rider;
  final List<Item> items;
  @JsonKey(fromJson: _parseDistance)
  final String distance;
  @JsonKey(name: 'courier_type_prices')
  final List<CourierTypePrice>? courierTypePrices;
  @JsonKey(name: 'payment_methods')
  final List<PaymentMethodModel>? paymentMethods;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'timestamp', defaultValue: "")
  final String? timestamp;
  final Rating? rating;

  DeliveryModel({
    required this.id,
    required this.userId,
    required this.trackingId,
    required this.cost,
    this.status,
    required this.originLocation,
    required this.destinationLocation,
    required this.receiver,
    required this.sender,
    required this.rider,
    required this.items,
    required this.distance,
    required this.courierTypePrices,
    required this.paymentMethods,
    required this.createdAt,
    required this.updatedAt,
    required this.rating,
    required this.timestamp,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryModelToJson(this);
  // Custom deserialization for distance
  static String _parseDistance(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is double || value is int) {
      return value.toString();
    } else {
      return "0"; // Default to "0" for unexpected values
    }
  }
}

@JsonSerializable()
class ShipmentLocation {
  final int id;
  final String name;
  final String latitude;
  final String longitude;
  @JsonKey(name: 'locationable_type')
  final String locationableType;
  @JsonKey(name: 'locationable_id')
  final int locationableId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ShipmentLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.locationableType,
    required this.locationableId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShipmentLocation.fromJson(Map<String, dynamic> json) =>
      _$ShipmentLocationFromJson(json);
  Map<String, dynamic> toJson() => _$ShipmentLocationToJson(this);
}

@JsonSerializable()
class Receiver {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String? email;
  @JsonKey(name: 'shipment_id')
  final int shipmentId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Receiver({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.shipmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) =>
      _$ReceiverFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiverToJson(this);
}

@JsonSerializable()
class Sender {
  final int id;
  final String? avatar;
  @JsonKey(name: 'fname')
  final String? firstName;
  @JsonKey(name: 'lname')
  final String? lastName;
  final String phone;
  final String? dob;
  final String email;
  final String role;
  final String status;
  @JsonKey(name: 'referral_code')
  final String referralCode;
  @JsonKey(name: 'referred_by')
  final String? referredBy;
  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;
  @JsonKey(name: 'failed_login_attempts')
  final int failedLoginAttempts;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Sender({
    required this.id,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.dob,
    required this.email,
    required this.role,
    required this.status,
    required this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    required this.failedLoginAttempts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => _$SenderFromJson(json);
  Map<String, dynamic> toJson() => _$SenderToJson(this);
}

@JsonSerializable()
class Rider {
  final int id;
  final String? avatar;
  @JsonKey(name: 'fname')
  final String? firstName;
  @JsonKey(name: 'lname')
  final String? lastName;
  final String phone;
  final String? dob;
  final String email;
  final String role;
  final String status;
  @JsonKey(name: 'referral_code')
  final String referralCode;
  @JsonKey(name: 'referred_by')
  final String? referredBy;
  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;
  @JsonKey(name: 'failed_login_attempts')
  final int failedLoginAttempts;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Rider({
    required this.id,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.dob,
    required this.email,
    required this.role,
    required this.status,
    required this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    required this.failedLoginAttempts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Rider.fromJson(Map<String, dynamic> json) => _$RiderFromJson(json);
  Map<String, dynamic> toJson() => _$RiderToJson(this);
}

@JsonSerializable()
class Item {
  final int id;
  final String name;
  @JsonKey(name: 'description', defaultValue: "")
  final String? description;
  final String category;
  final String weight;
  final int quantity;
  @JsonKey(name: 'shipment_id')
  final int shipmentId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String image;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.weight,
    required this.quantity,
    required this.image,
    required this.shipmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class CourierTypePrice {
  @JsonKey(name: 'courier_type_id')
  final int courierTypeId;
  @JsonKey(name: 'courier_type')
  final String courierType;
  final double price;

  CourierTypePrice({
    required this.courierTypeId,
    required this.courierType,
    required this.price,
  });

  factory CourierTypePrice.fromJson(Map<String, dynamic> json) =>
      _$CourierTypePriceFromJson(json);
  Map<String, dynamic> toJson() => _$CourierTypePriceToJson(this);
}

@JsonSerializable()
class Rating {
  final int id;
  final num points;
  final String review;
  @JsonKey(name: "shipment_id")
  final int shipmentId;
  @JsonKey(name: "user_id")
  final int userId;

  Rating({
    required this.id,
    required this.points,
    required this.review,
    required this.shipmentId,
    required this.userId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
