// order_model.dart
class OrderModel {
  final int id;
  final String orderableType;
  final int orderableId;
  final int userId;
  final String ref;
  final String status;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final String notes;
  final int? discountId;
  final double discountAmount;
  final int? paymentMethodId;
  final String paymentReference;
  final double total;
  final DateTime? confirmedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final DateTime? paidAt;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItemModel> items;
  final OrderUserModel user;
  final DeliveryLocationModel deliveryLocation;

  OrderModel({
    required this.id,
    required this.orderableType,
    required this.orderableId,
    required this.userId,
    required this.ref,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.notes,
    this.discountId,
    required this.discountAmount,
    this.paymentMethodId,
    required this.paymentReference,
    required this.total,
    this.confirmedAt,
    this.completedAt,
    this.cancelledAt,
    this.paidAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.user,
    required this.deliveryLocation,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderableType: json['orderable_type'] ?? '',
      orderableId: json['orderable_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      ref: json['ref'] ?? '',
      status: json['status'] ?? 'pending',
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '0') ?? 0.0,
      deliveryFee: double.tryParse(json['delivery_fee']?.toString() ?? '0') ?? 0.0,
      notes: json['notes'] ?? '',
      discountId: json['discount_id'],
      discountAmount: double.tryParse(json['discount_amount']?.toString() ?? '0') ?? 0.0,
      paymentMethodId: json['payment_method_id'],
      paymentReference: json['payment_reference'] ?? '',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      confirmedAt: json['confirmed_at'] != null
          ? DateTime.tryParse(json['confirmed_at'])
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.tryParse(json['cancelled_at'])
          : null,
      paidAt: json['paid_at'] != null
          ? DateTime.tryParse(json['paid_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItemModel.fromJson(item))
          .toList() ?? [],
      user: OrderUserModel.fromJson(json['user'] ?? {}),
      deliveryLocation: DeliveryLocationModel.fromJson(json['delivery_location'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderable_type': orderableType,
      'orderable_id': orderableId,
      'user_id': userId,
      'ref': ref,
      'status': status,
      'subtotal': subtotal.toString(),
      'tax': tax.toString(),
      'delivery_fee': deliveryFee.toString(),
      'notes': notes,
      'discount_id': discountId,
      'discount_amount': discountAmount.toString(),
      'payment_method_id': paymentMethodId,
      'payment_reference': paymentReference,
      'total': total.toString(),
      'confirmed_at': confirmedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'user': user.toJson(),
      'delivery_location': deliveryLocation.toJson(),
    };
  }

  OrderModel copyWith({
    int? id,
    String? orderableType,
    int? orderableId,
    int? userId,
    String? ref,
    String? status,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    String? notes,
    int? discountId,
    double? discountAmount,
    int? paymentMethodId,
    String? paymentReference,
    double? total,
    DateTime? confirmedAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? paidAt,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItemModel>? items,
    OrderUserModel? user,
    DeliveryLocationModel? deliveryLocation,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderableType: orderableType ?? this.orderableType,
      orderableId: orderableId ?? this.orderableId,
      userId: userId ?? this.userId,
      ref: ref ?? this.ref,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      notes: notes ?? this.notes,
      discountId: discountId ?? this.discountId,
      discountAmount: discountAmount ?? this.discountAmount,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      paymentReference: paymentReference ?? this.paymentReference,
      total: total ?? this.total,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      paidAt: paidAt ?? this.paidAt,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
      user: user ?? this.user,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
    );
  }

  // Helper getters for backward compatibility
  String get customerId => userId.toString();
  String get customerName => "${user.fname} ${user.lname}".trim();
  String get customerPhone => user.phone;
  String get deliveryAddress => deliveryLocation.name;
  DateTime get orderDate => createdAt;
  String get estimatedDeliveryTime => "25-30 mins"; // You can calculate this based on your logic
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}

// order_item_model.dart
class OrderItemModel {
  final int id;
  final int orderId;
  final String orderableType;
  final int orderableId;
  final Map<String, dynamic>? options;
  final int quantity;
  final double price;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OrderableItemModel orderable;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.orderableType,
    required this.orderableId,
    this.options,
    required this.quantity,
    required this.price,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.orderable,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      orderId: json['order_id'] ?? 0,
      orderableType: json['orderable_type'] ?? '',
      orderableId: json['orderable_id'] ?? 0,
      options: json['options'],
      quantity: json['quantity'] ?? 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      orderable: OrderableItemModel.fromJson(json['orderable'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'orderable_type': orderableType,
      'orderable_id': orderableId,
      'options': options,
      'quantity': quantity,
      'price': price.toString(),
      'total': total.toString(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'orderable': orderable.toJson(),
    };
  }

  OrderItemModel copyWith({
    int? id,
    int? orderId,
    String? orderableType,
    int? orderableId,
    Map<String, dynamic>? options,
    int? quantity,
    double? price,
    double? total,
    DateTime? createdAt,
    DateTime? updatedAt,
    OrderableItemModel? orderable,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderableType: orderableType ?? this.orderableType,
      orderableId: orderableId ?? this.orderableId,
      options: options ?? this.options,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderable: orderable ?? this.orderable,
    );
  }

  // Helper getters for backward compatibility
  String get name => orderable.name;
  String get image => "assets/imgs/${orderable.name.toLowerCase().replaceAll(' ', '_')}.png";
  String get specialInstructions => options?.toString() ?? "";
  double get totalPrice => total;
}

// orderable_item_model.dart
class OrderableItemModel {
  final int id;
  final int restaurantId;
  final String name;
  final String description;
  final String plateSize;
  final int quantity;
  final bool isAvailable;
  final double price;
  final int prepTimeMinutes;
  final int categoryId;
  final bool isPublished;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderableItemModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.plateSize,
    required this.quantity,
    required this.isAvailable,
    required this.price,
    required this.prepTimeMinutes,
    required this.categoryId,
    required this.isPublished,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderableItemModel.fromJson(Map<String, dynamic> json) {
    return OrderableItemModel(
      id: json['id'] ?? 0,
      restaurantId: json['restaurant_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      plateSize: json['plate_size'] ?? '',
      quantity: json['quantity'] ?? 1,
      isAvailable: json['is_available'] == 1,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      prepTimeMinutes: json['prep_time_minutes'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      isPublished: json['is_published'] == 1,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'plate_size': plateSize,
      'quantity': quantity,
      'is_available': isAvailable ? 1 : 0,
      'price': price.toString(),
      'prep_time_minutes': prepTimeMinutes,
      'category_id': categoryId,
      'is_published': isPublished ? 1 : 0,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// user_model.dart
class OrderUserModel {
  final int id;
  final String? avatar;
  final String fname;
  final String lname;
  final String phone;
  final String? dob;
  final String email;
  final String status;
  final String referralCode;
  final int? referredBy;
  final DateTime? lastLoginAt;
  final int failedLoginAttempts;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderUserModel({
    required this.id,
    this.avatar,
    required this.fname,
    required this.lname,
    required this.phone,
    this.dob,
    required this.email,
    required this.status,
    required this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    required this.failedLoginAttempts,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    return OrderUserModel(
      id: json['id'] ?? 0,
      avatar: json['avatar'],
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      phone: json['phone'] ?? '',
      dob: json['dob'],
      email: json['email'] ?? '',
      status: json['status'] ?? '',
      referralCode: json['referral_code'] ?? '',
      referredBy: json['referred_by'],
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'])
          : null,
      failedLoginAttempts: json['failed_login_attempts'] ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'dob': dob,
      'email': email,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'failed_login_attempts': failedLoginAttempts,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// delivery_location_model.dart
class DeliveryLocationModel {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String locationableType;
  final int locationableId;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeliveryLocationModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.locationableType,
    required this.locationableId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryLocationModel.fromJson(Map<String, dynamic> json) {
    return DeliveryLocationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0') ?? 0.0,
      locationableType: json['locationable_type'] ?? '',
      locationableId: json['locationable_id'] ?? 0,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'locationable_type': locationableType,
      'locationable_id': locationableId,
      'deleted_at': deletedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}