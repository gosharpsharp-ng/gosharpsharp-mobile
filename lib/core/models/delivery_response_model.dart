class DeliveryResponseModel {
  final int id;
  final String trackingId;
  final int? orderId;
  final String status;
  final String paymentStatus;
  final double distance;
  final double cost;
  final int userId;
  final int? riderId;
  final int currencyId;
  final Receiver receiver;
  final List<Item> items;
  final ShipmentLocation pickupLocation;
  final ShipmentLocation destinationLocation;
  final UserModel user;
  final RiderModel? rider;
  final String createdAt;
  final String updatedAt;

  DeliveryResponseModel({
    required this.id,
    required this.trackingId,
    this.orderId,
    required this.status,
    required this.paymentStatus,
    required this.distance,
    required this.cost,
    required this.userId,
    this.riderId,
    required this.currencyId,
    required this.receiver,
    required this.items,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.user,
    this.rider,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryResponseModel.fromJson(Map<String, dynamic> json) {
    return DeliveryResponseModel(
      id: json['id'],
      trackingId: json['tracking_id'],
      orderId: json['order_id'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      distance: (json['distance'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      userId: json['user_id'],
      riderId: json['rider_id'],
      currencyId: json['currency_id'],
      receiver: Receiver.fromJson(json['receiver']),
      items: (json['items'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
      pickupLocation: ShipmentLocation.fromJson(json['pickup_location']),
      destinationLocation: ShipmentLocation.fromJson(
        json['destination_location'],
      ),
      user: UserModel.fromJson(json['user']),
      rider: json['rider'] != null ? RiderModel.fromJson(json['rider']) : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tracking_id': trackingId,
      'order_id': orderId,
      'status': status,
      'payment_status': paymentStatus,
      'distance': distance,
      'cost': cost,
      'user_id': userId,
      'rider_id': riderId,
      'currency_id': currencyId,
      'receiver': receiver.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'pickup_location': pickupLocation.toJson(),
      'destination_location': destinationLocation.toJson(),
      'user': user.toJson(),
      'rider': rider?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Receiver {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String address;

  Receiver({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.address,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}

class Item {
  final int id;
  final String name;
  final String description;
  final String category;
  final String weight;
  final int quantity;
  final List<dynamic> files;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.weight,
    required this.quantity,
    required this.files,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? "",
      category: json['category'] ?? "",
      weight: json['weight'] ?? "",
      quantity: json['quantity'] ?? "",
      files: json['files'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'weight': weight,
      'quantity': quantity,
      'files': files,
    };
  }
}

class ShipmentLocation {
  final int id;
  final String name;
  final String latitude;
  final String longitude;

  ShipmentLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory ShipmentLocation.fromJson(Map<String, dynamic> json) {
    return ShipmentLocation(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class UserModel {
  final int id;
  final String name;
  final String phone;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone, 'email': email};
  }
}

class RiderModel {
  final int id;
  final String name;
  final String phone;
  final String? email;

  RiderModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
  });

  factory RiderModel.fromJson(Map<String, dynamic> json) {
    return RiderModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone, 'email': email};
  }
}
