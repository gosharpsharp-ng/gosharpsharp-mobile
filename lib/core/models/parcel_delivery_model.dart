class ParcelDeliveryModel {
  final int id;
  final int? orderId;
  final String trackingId;
  final String status;
  final String paymentStatus;
  final String distance;
  final String cost;
  final int userId;
  final int? riderId;
  final int currencyId;
  final int? paymentMethodId;
  final int? courierTypeId;
  final String createdAt;
  final String updatedAt;
  final ParcelReceiver receiver;
  final List<ParcelItem> items;
  final ParcelUser user;
  final ParcelRider? rider;
  final ParcelCurrency currency;
  final ParcelPaymentMethod? paymentMethod;
  final ParcelLocation pickupLocation;
  final ParcelLocation destinationLocation;

  ParcelDeliveryModel({
    required this.id,
    this.orderId,
    required this.trackingId,
    required this.status,
    required this.paymentStatus,
    required this.distance,
    required this.cost,
    required this.userId,
    this.riderId,
    required this.currencyId,
    this.paymentMethodId,
    this.courierTypeId,
    required this.createdAt,
    required this.updatedAt,
    required this.receiver,
    required this.items,
    required this.user,
    this.rider,
    required this.currency,
    this.paymentMethod,
    required this.pickupLocation,
    required this.destinationLocation,
  });

  factory ParcelDeliveryModel.fromJson(Map<String, dynamic> json) {
    return ParcelDeliveryModel(
      id: json['id'],
      orderId: json['order_id'],
      trackingId: json['tracking_id'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      distance: json['distance'].toString(),
      cost: json['cost'].toString(),
      userId: json['user_id'],
      riderId: json['rider_id'],
      currencyId: json['currency_id'],
      paymentMethodId: json['payment_method_id'],
      courierTypeId: json['courier_type_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      receiver: ParcelReceiver.fromJson(json['receiver']),
      items: (json['items'] as List)
          .map((item) => ParcelItem.fromJson(item))
          .toList(),
      user: ParcelUser.fromJson(json['user']),
      rider: json['rider'] != null ? ParcelRider.fromJson(json['rider']) : null,
      currency: ParcelCurrency.fromJson(json['currency']),
      paymentMethod: json['payment_method'] != null
          ? ParcelPaymentMethod.fromJson(json['payment_method'])
          : null,
      pickupLocation: ParcelLocation.fromJson(json['pickup_location']),
      destinationLocation: ParcelLocation.fromJson(json['destination_location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'tracking_id': trackingId,
      'status': status,
      'payment_status': paymentStatus,
      'distance': distance,
      'cost': cost,
      'user_id': userId,
      'rider_id': riderId,
      'currency_id': currencyId,
      'payment_method_id': paymentMethodId,
      'courier_type_id': courierTypeId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'receiver': receiver.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'user': user.toJson(),
      'rider': rider?.toJson(),
      'currency': currency.toJson(),
      'payment_method': paymentMethod?.toJson(),
      'pickup_location': pickupLocation.toJson(),
      'destination_location': destinationLocation.toJson(),
    };
  }
}

class ParcelReceiver {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String? email;
  final int deliveryId;
  final String createdAt;
  final String updatedAt;

  ParcelReceiver({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.email,
    required this.deliveryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParcelReceiver.fromJson(Map<String, dynamic> json) {
    return ParcelReceiver(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      deliveryId: json['delivery_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'delivery_id': deliveryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ParcelItem {
  final int id;
  final String name;
  final String? image;
  final String? description;
  final String category;
  final String weight;
  final int quantity;
  final int deliveryId;
  final String createdAt;
  final String updatedAt;
  final List<dynamic> files;

  ParcelItem({
    required this.id,
    required this.name,
    this.image,
    this.description,
    required this.category,
    required this.weight,
    required this.quantity,
    required this.deliveryId,
    required this.createdAt,
    required this.updatedAt,
    required this.files,
  });

  factory ParcelItem.fromJson(Map<String, dynamic> json) {
    return ParcelItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      category: json['category'],
      weight: json['weight'].toString(),
      quantity: json['quantity'],
      deliveryId: json['delivery_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      files: json['files'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'category': category,
      'weight': weight,
      'quantity': quantity,
      'delivery_id': deliveryId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'files': files,
    };
  }
}

class ParcelUser {
  final int id;
  final String fname;
  final String lname;
  final String email;
  final String phone;

  ParcelUser({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
  });

  factory ParcelUser.fromJson(Map<String, dynamic> json) {
    return ParcelUser(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'email': email,
      'phone': phone,
    };
  }
}

class ParcelRider {
  final int id;
  final String fname;
  final String lname;
  final String email;
  final String phone;

  ParcelRider({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
  });

  factory ParcelRider.fromJson(Map<String, dynamic> json) {
    return ParcelRider(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'email': email,
      'phone': phone,
    };
  }
}

class ParcelCurrency {
  final int id;
  final String code;
  final String name;
  final String symbol;
  final String exchangeRate;
  final String createdAt;
  final String updatedAt;

  ParcelCurrency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.exchangeRate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ParcelCurrency.fromJson(Map<String, dynamic> json) {
    return ParcelCurrency(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      symbol: json['symbol'],
      exchangeRate: json['exchange_rate'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'symbol': symbol,
      'exchange_rate': exchangeRate,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class ParcelPaymentMethod {
  final int id;
  final String name;
  final String code;

  ParcelPaymentMethod({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ParcelPaymentMethod.fromJson(Map<String, dynamic> json) {
    return ParcelPaymentMethod(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}

class ParcelLocation {
  final int id;
  final String name;
  final String latitude;
  final String longitude;

  ParcelLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory ParcelLocation.fromJson(Map<String, dynamic> json) {
    return ParcelLocation(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
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
