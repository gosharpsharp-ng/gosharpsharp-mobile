import 'package:gosharpsharp/core/models/payment_method_model.dart';
import 'delivery_response_model.dart';

class DeliveryModel {
  final int id;
  final int userId;
  final String trackingId;
  final String? status;
  final String? cost;
  final ShipmentLocation pickUpLocation;
  final ShipmentLocation destinationLocation;
  final Receiver receiver;
  final Sender? sender;
  final Rider? rider;
  final List<Item> items;
  final String distance;
  final List<CourierTypePrice>? courierTypePrices;
  final List<PaymentMethodModel>? paymentMethods;
  final String createdAt;
  final String updatedAt;
  final String? timestamp;
  final Rating? rating;

  DeliveryModel({
    required this.id,
    required this.userId,
    required this.trackingId,
    this.status,
    this.cost,
    required this.pickUpLocation,
    required this.destinationLocation,
    required this.receiver,
    this.sender,
    this.rider,
    required this.items,
    required this.distance,
    this.courierTypePrices,
    this.paymentMethods,
    required this.createdAt,
    required this.updatedAt,
    this.timestamp,
    this.rating,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'],
      userId: json['user_id'],
      trackingId: json['tracking_id'],
      status: json['status'] ?? "",
      cost: json['cost']?.toString(),
      pickUpLocation: ShipmentLocation.fromJson(json['pickup_location']),
      destinationLocation: ShipmentLocation.fromJson(
        json['destination_location'],
      ),
      receiver: Receiver.fromJson(json['receiver']),
      sender: json['sender'] != null ? Sender.fromJson(json['sender']) : null,
      rider: json['rider'] != null ? Rider.fromJson(json['rider']) : null,
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e))
          .toList(),
      distance: _parseDistance(json['distance']),
      courierTypePrices: json['courier_type_prices'] != null
          ? (json['courier_type_prices'] as List)
                .map((e) => CourierTypePrice.fromJson(e))
                .toList()
          : null,
      paymentMethods: json['payment_methods'] != null
          ? (json['payment_methods'] as List)
                .map((e) => PaymentMethodModel.fromJson(e))
                .toList()
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      timestamp: json['timestamp'],
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'tracking_id': trackingId,
      'status': status,
      'cost': cost,
      'origin_location': pickUpLocation.toJson(),
      'destination_location': destinationLocation.toJson(),
      'receiver': receiver.toJson(),
      'sender': sender?.toJson(),
      'rider': rider?.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'distance': distance,
      'courier_type_prices': courierTypePrices?.map((e) => e.toJson()).toList(),
      'payment_methods': paymentMethods?.map((e) => e.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'timestamp': timestamp,
      'rating': rating?.toJson(),
    };
  }

  static String _parseDistance(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is double || value is int) {
      return value.toString();
    } else {
      return "0";
    }
  }
}

class Sender {
  final int id;
  final String? avatar;
  final String? firstName;
  final String? lastName;
  final String phone;
  final String? dob;
  final String email;
  final String role;
  final String status;
  final String referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int failedLoginAttempts;
  final String createdAt;
  final String updatedAt;

  Sender({
    required this.id,
    this.avatar,
    this.firstName,
    this.lastName,
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

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      avatar: json['avatar'],
      firstName: json['fname'],
      lastName: json['lname'],
      phone: json['phone'],
      dob: json['dob'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      referralCode: json['referral_code'],
      referredBy: json['referred_by'],
      lastLoginAt: json['last_login_at'],
      failedLoginAttempts: json['failed_login_attempts'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'fname': firstName,
      'lname': lastName,
      'phone': phone,
      'dob': dob,
      'email': email,
      'role': role,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Rider {
  final int id;
  final String? avatar;
  final String? firstName;
  final String? lastName;
  final String phone;
  final String? dob;
  final String email;
  final String role;
  final String status;
  final String referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int failedLoginAttempts;
  final String createdAt;
  final String updatedAt;

  Rider({
    required this.id,
    this.avatar,
    this.firstName,
    this.lastName,
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

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['id'],
      avatar: json['avatar'],
      firstName: json['fname'],
      lastName: json['lname'],
      phone: json['phone'],
      dob: json['dob'],
      email: json['email'],
      role: json['role'],
      status: json['status'],
      referralCode: json['referral_code'],
      referredBy: json['referred_by'],
      lastLoginAt: json['last_login_at'],
      failedLoginAttempts: json['failed_login_attempts'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'fname': firstName,
      'lname': lastName,
      'phone': phone,
      'dob': dob,
      'email': email,
      'role': role,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class CourierTypePrice {
  final int courierTypeId;
  final String courierType;
  final double price;

  CourierTypePrice({
    required this.courierTypeId,
    required this.courierType,
    required this.price,
  });

  factory CourierTypePrice.fromJson(Map<String, dynamic> json) {
    return CourierTypePrice(
      courierTypeId: json['courier_type_id'],
      courierType: json['courier_type'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courier_type_id': courierTypeId,
      'courier_type': courierType,
      'price': price,
    };
  }
}

class Rating {
  final int id;
  final num points;
  final String review;
  final int shipmentId;
  final int userId;

  Rating({
    required this.id,
    required this.points,
    required this.review,
    required this.shipmentId,
    required this.userId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      points: json['points'],
      review: json['review'],
      shipmentId: json['shipment_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'review': review,
      'shipment_id': shipmentId,
      'user_id': userId,
    };
  }
}
