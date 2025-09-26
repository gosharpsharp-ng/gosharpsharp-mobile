import 'package:gosharpsharp/core/models/categories_model.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';

import 'item_file_model.dart';
import 'order_model.dart';

class Cart {
  int id;
  int userId;
  String? sessionId;
  String totalAmount;
  int totalItems;
  bool isActive;
  String? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  List<CartItem> items;

  Cart({
    required this.id,
    required this.userId,
    this.sessionId,
    required this.totalAmount,
    required this.totalItems,
    required this.isActive,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    id: json["id"],
    userId: json["user_id"],
    sessionId: json["session_id"],
    totalAmount: json["total_amount"],
    totalItems: json["total_items"],
    isActive: json["is_active"] == 1,
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    items: List<CartItem>.from(json["items"].map((x) => CartItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "session_id": sessionId,
    "total_amount": totalAmount,
    "total_items": totalItems,
    "is_active": isActive ? 1 : 0,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class CartItem {
  int id;
  int cartId;
  String price;
  String total;
  String discount;
  int quantity;
  dynamic options;
  String purchasableType;
  int purchasableId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Purchasable purchasable;

  CartItem({
    required this.id,
    required this.cartId,
    required this.price,
    required this.total,
    required this.discount,
    required this.quantity,
    this.options,
    required this.purchasableType,
    required this.purchasableId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.purchasable,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json["id"],
    cartId: json["cart_id"],
    price: json["price"],
    total: json["total"],
    discount: json["discount"],
    quantity: json["quantity"],
    options: json["options"],
    purchasableType: json["purchasable_type"],
    purchasableId: json["purchasable_id"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    purchasable: Purchasable.fromJson(json["purchasable"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "cart_id": cartId,
    "price": price,
    "total": total,
    "discount": discount,
    "quantity": quantity,
    "options": options,
    "purchasable_type": purchasableType,
    "purchasable_id": purchasableId,
    "deleted_at": deletedAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "purchasable": purchasable.toJson(),
  };

  // Adapter method to create CartItem from OrderItemModel
  static CartItem fromOrderItem(OrderItemModel orderItem, int cartId) {
    return CartItem(
      id: orderItem.id,
      cartId: cartId,
      price: orderItem.price.toString(),
      total: orderItem.total.toString(),
      discount: "0", // Orders typically don't have discounts at item level
      quantity: orderItem.quantity,
      options: orderItem.options,
      purchasableType: orderItem.orderableType,
      purchasableId: orderItem.orderableId,
      deletedAt: null,
      createdAt: orderItem.createdAt.toIso8601String(),
      updatedAt: orderItem.updatedAt.toIso8601String(),
      purchasable: Purchasable.fromOrderableItem(orderItem.orderable),
    );
  }
}

class Purchasable {
  int id;
  int restaurantId;
  String name;
  String description;
  String plateSize;
  int quantity;
  int isAvailable;
  String price;
  int prepTimeMinutes;
  int categoryId;
  int isPublished;
  String? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  final List<ItemFileModel> files;
  RestaurantModel restaurant;
  CategoryModel category;

  Purchasable({
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
    required this.restaurant,
    required this.category,
    required this.files,
  });

  factory Purchasable.fromJson(Map<String, dynamic> json) {
    final filesJson = json['files'] as List<dynamic>? ?? [];
    return Purchasable(
      id: json["id"],
      restaurantId: json["restaurant_id"],
      name: json["name"],
      description: json["description"],
      plateSize: json["plate_size"],
      quantity: json["quantity"],
      isAvailable: json["is_available"],
      price: json["price"],
      prepTimeMinutes: json["prep_time_minutes"],
      categoryId: json["category_id"],
      isPublished: json["is_published"],
      deletedAt: json["deleted_at"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      restaurant: RestaurantModel.fromJson(json["restaurant"]),
      category: CategoryModel.fromJson(json["category"]),
      files: filesJson.map((e) => ItemFileModel.fromJson(e)).toList(),
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": name,
    "description": description,
    "plate_size": plateSize,
    "quantity": quantity,
    "is_available": isAvailable,
    "price": price,
    "prep_time_minutes": prepTimeMinutes,
    "category_id": categoryId,
    "is_published": isPublished,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "restaurant": restaurant.toJson(),
    "category": category.toJson(),
  };

  // Adapter method to create Purchasable from OrderableItemModel
  static Purchasable fromOrderableItem(dynamic orderableItem) {
    return Purchasable(
      id: orderableItem.id,
      restaurantId: orderableItem.restaurantId,
      name: orderableItem.name,
      description: orderableItem.description,
      plateSize: orderableItem.plateSize,
      quantity: orderableItem.quantity,
      isAvailable: orderableItem.isAvailable ? 1 : 0,
      price: orderableItem.price.toString(),
      prepTimeMinutes: orderableItem.prepTimeMinutes,
      categoryId: orderableItem.categoryId,
      isPublished: orderableItem.isPublished ? 1 : 0,
      deletedAt: orderableItem.deletedAt?.toIso8601String(),
      createdAt: orderableItem.createdAt,
      updatedAt: orderableItem.updatedAt,
      files: orderableItem.files,
      restaurant: _createEmptyRestaurant(),
      category: orderableItem.category ?? _createEmptyCategory(),
    );
  }

  static RestaurantModel _createEmptyRestaurant() {
    return RestaurantModel(
      id: 0,
      name: '',
      email: '',
      phone: '',
      isActive: 1,
      isFeatured: 0,
      distance: '0.0',
      commissionRate: '0.0',
      status: '',
      userId: 0,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  static CategoryModel _createEmptyCategory() {
    return CategoryModel(
      id: 0,
      name: '',
      description: '',
    );
  }
}


