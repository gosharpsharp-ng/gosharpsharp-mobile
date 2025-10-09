import 'package:gosharpsharp/core/models/categories_model.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';

import 'item_file_model.dart';
import 'order_model.dart';

class Cart {
  int id;
  int userId;
  String? sessionId;
  String totalAmount;
  int totalPackages;
  int totalItems;
  bool isActive;
  String? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;
  List<CartItem> items;
  List<dynamic> packages;

  Cart({
    required this.id,
    required this.userId,
    this.sessionId,
    required this.totalAmount,
    required this.totalPackages,
    required this.totalItems,
    required this.isActive,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    this.packages = const [],
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    try {
      return Cart(
        id: json["id"] ?? 0,
        userId: json["user_id"] ?? 0,
        sessionId: json["session_id"],
        totalAmount: json["total_amount"]?.toString() ?? "0.00",
        totalPackages: json["total_packages"] ?? 0,
        totalItems: json["total_items"] ?? 0,
        isActive: json["is_active"] == true || json["is_active"] == 1,
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"]) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"]) ?? DateTime.now()
            : DateTime.now(),
        items: _parseCartItems(json["items"]),
        packages: json["packages"] as List<dynamic>? ?? [],
      );
    } catch (e) {
      print("Error parsing Cart: $e");
      return Cart(
        id: 0,
        userId: 0,
        sessionId: null,
        totalAmount: "0.00",
        totalPackages: 0,
        totalItems: 0,
        isActive: false,
        deletedAt: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        items: [],
        packages: [],
      );
    }
  }

  static List<CartItem> _parseCartItems(dynamic itemsJson) {
    try {
      if (itemsJson == null) return [];
      if (itemsJson is! List) return [];

      final items = <CartItem>[];
      for (final item in itemsJson) {
        if (item is Map<String, dynamic>) {
          try {
            items.add(CartItem.fromJson(item));
          } catch (e) {
            print("Error parsing CartItem: $e");
            // Skip invalid items
          }
        }
      }
      return items;
    } catch (e) {
      print("Error parsing cart items list: $e");
      return [];
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "session_id": sessionId,
    "total_amount": totalAmount,
    "total_packages": totalPackages,
    "total_items": totalItems,
    "is_active": isActive,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "packages": packages,
  };
}

class CartItem {
  int id;
  int cartId;
  String price;
  String total;
  String discount;
  int? packageId;
  int quantity;
  dynamic options;
  String purchasableType;
  int purchasableId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Purchasable purchasable;
  List<dynamic> addons;

  CartItem({
    required this.id,
    required this.cartId,
    required this.price,
    required this.total,
    required this.discount,
    this.packageId,
    required this.quantity,
    this.options,
    required this.purchasableType,
    required this.purchasableId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.purchasable,
    this.addons = const [],
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    try {
      // Validate required fields
      if (json["id"] == null || json["cart_id"] == null) {
        throw Exception("Missing required fields: id or cart_id");
      }

      // Check if purchasable exists
      if (json["purchasable"] == null) {
        throw Exception("Missing purchasable data for cart item ${json["id"]}");
      }

      return CartItem(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()) ?? 0,
        cartId: json["cart_id"] is int ? json["cart_id"] : int.tryParse(json["cart_id"].toString()) ?? 0,
        price: json["price"]?.toString() ?? "0.00",
        total: json["total"]?.toString() ?? "0.00",
        discount: json["discount"]?.toString() ?? "0.00",
        packageId: json["package_id"] is int
            ? json["package_id"]
            : (json["package_id"] != null ? int.tryParse(json["package_id"].toString()) : null),
        quantity: json["quantity"] is int ? json["quantity"] : int.tryParse(json["quantity"]?.toString() ?? "1") ?? 1,
        options: json["options"],
        purchasableType: json["purchasable_type"]?.toString() ?? "",
        purchasableId: json["purchasable_id"] is int
            ? json["purchasable_id"]
            : int.tryParse(json["purchasable_id"]?.toString() ?? "0") ?? 0,
        deletedAt: json["deleted_at"]?.toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        purchasable: Purchasable.fromJson(json["purchasable"] as Map<String, dynamic>),
        addons: _parseAddons(json["addons"]),
      );
    } catch (e) {
      print("Error parsing CartItem: $e - JSON: $json");
      rethrow; // Re-throw to be caught by parent parser
    }
  }

  static List<dynamic> _parseAddons(dynamic addonsJson) {
    try {
      if (addonsJson == null) return [];
      if (addonsJson is List) return addonsJson;
      return [];
    } catch (e) {
      print("Error parsing addons: $e");
      return [];
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "cart_id": cartId,
    "price": price,
    "total": total,
    "discount": discount,
    "package_id": packageId,
    "quantity": quantity,
    "options": options,
    "purchasable_type": purchasableType,
    "purchasable_id": purchasableId,
    "deleted_at": deletedAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "purchasable": purchasable.toJson(),
    "addons": addons,
  };

  // Adapter method to create CartItem from OrderItemModel
  static CartItem fromOrderItem(OrderItemModel orderItem, int cartId) {
    return CartItem(
      id: orderItem.id,
      cartId: cartId,
      price: orderItem.price.toString(),
      total: orderItem.total.toString(),
      discount: "0", // Orders typically don't have discounts at item level
      packageId: null,
      quantity: orderItem.quantity,
      options: orderItem.options,
      purchasableType: orderItem.orderableType,
      purchasableId: orderItem.orderableId,
      deletedAt: null,
      createdAt: orderItem.createdAt.toIso8601String(),
      updatedAt: orderItem.updatedAt.toIso8601String(),
      purchasable: Purchasable.fromOrderableItem(orderItem.orderable),
      addons: [],
    );
  }
}

class Purchasable {
  int id;
  int restaurantId;
  String name;
  String description;
  String plateSize;
  String? packaging;
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
    this.packaging,
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
    try {
      // Validate required fields
      if (json["id"] == null) {
        throw Exception("Missing required field: id");
      }

      // Parse files safely
      final filesJson = json['files'] as List<dynamic>? ?? [];
      final files = <ItemFileModel>[];
      for (final fileJson in filesJson) {
        try {
          if (fileJson is Map<String, dynamic>) {
            files.add(ItemFileModel.fromJson(fileJson));
          }
        } catch (e) {
          print("Error parsing file in purchasable: $e");
          // Skip invalid file
        }
      }

      // Parse restaurant safely
      RestaurantModel restaurant;
      try {
        restaurant = json["restaurant"] != null
            ? RestaurantModel.fromJson(json["restaurant"] as Map<String, dynamic>)
            : _createEmptyRestaurant();
      } catch (e) {
        print("Error parsing restaurant in purchasable: $e");
        restaurant = _createEmptyRestaurant();
      }

      // Parse category safely
      CategoryModel category;
      try {
        category = json["category"] != null
            ? CategoryModel.fromJson(json["category"] as Map<String, dynamic>)
            : _createEmptyCategory();
      } catch (e) {
        print("Error parsing category in purchasable: $e");
        category = _createEmptyCategory();
      }

      return Purchasable(
        id: json["id"] is int ? json["id"] : int.tryParse(json["id"].toString()) ?? 0,
        restaurantId: json["restaurant_id"] is int
            ? json["restaurant_id"]
            : int.tryParse(json["restaurant_id"]?.toString() ?? "0") ?? 0,
        name: json["name"]?.toString() ?? "",
        description: json["description"]?.toString() ?? "",
        plateSize: json["plate_size"]?.toString() ?? "",
        packaging: json["packaging"]?.toString(),
        quantity: json["quantity"] is int ? json["quantity"] : int.tryParse(json["quantity"]?.toString() ?? "0") ?? 0,
        isAvailable: json["is_available"] is int
            ? json["is_available"]
            : (json["is_available"] == true ? 1 : 0),
        price: json["price"]?.toString() ?? "0.00",
        prepTimeMinutes: json["prep_time_minutes"] is int
            ? json["prep_time_minutes"]
            : int.tryParse(json["prep_time_minutes"]?.toString() ?? "0") ?? 0,
        categoryId: json["category_id"] is int
            ? json["category_id"]
            : int.tryParse(json["category_id"]?.toString() ?? "0") ?? 0,
        isPublished: json["is_published"] is int
            ? json["is_published"]
            : (json["is_published"] == true ? 1 : 0),
        deletedAt: json["deleted_at"]?.toString(),
        createdAt: json["created_at"] != null
            ? DateTime.tryParse(json["created_at"]) ?? DateTime.now()
            : DateTime.now(),
        updatedAt: json["updated_at"] != null
            ? DateTime.tryParse(json["updated_at"]) ?? DateTime.now()
            : DateTime.now(),
        restaurant: restaurant,
        category: category,
        files: files,
      );
    } catch (e) {
      print("Error parsing Purchasable: $e - JSON: $json");
      rethrow;
    }
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "restaurant_id": restaurantId,
    "name": name,
    "description": description,
    "plate_size": plateSize,
    "packaging": packaging,
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
    "files": files.map((e) => e.toJson()).toList(),
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


