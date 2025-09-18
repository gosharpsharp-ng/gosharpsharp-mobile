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
    isActive: json["is_active"],
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
    "is_active": isActive,
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
  Restaurant restaurant;
  Category category;

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
  });

  factory Purchasable.fromJson(Map<String, dynamic> json) => Purchasable(
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
    restaurant: Restaurant.fromJson(json["restaurant"]),
    category: Category.fromJson(json["category"]),
  );

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
}

class Restaurant {
  int id;
  String? banner;
  String? logo;
  String name;
  String description;
  String email;
  String phone;
  String cuisineType;
  int isActive;
  int isFeatured;
  String commissionRate;
  String businessRegistrationNumber;
  String taxIdentificationNumber;
  String status;
  int userId;
  String? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Restaurant({
    required this.id,
    this.banner,
    this.logo,
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    required this.cuisineType,
    required this.isActive,
    required this.isFeatured,
    required this.commissionRate,
    required this.businessRegistrationNumber,
    required this.taxIdentificationNumber,
    required this.status,
    required this.userId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    banner: json["banner"],
    logo: json["logo"],
    name: json["name"],
    description: json["description"],
    email: json["email"],
    phone: json["phone"],
    cuisineType: json["cuisine_type"],
    isActive: json["is_active"],
    isFeatured: json["is_featured"],
    commissionRate: json["commission_rate"],
    businessRegistrationNumber: json["business_registration_number"],
    taxIdentificationNumber: json["tax_identification_number"],
    status: json["status"],
    userId: json["user_id"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "banner": banner,
    "logo": logo,
    "name": name,
    "description": description,
    "email": email,
    "phone": phone,
    "cuisine_type": cuisineType,
    "is_active": isActive,
    "is_featured": isFeatured,
    "commission_rate": commissionRate,
    "business_registration_number": businessRegistrationNumber,
    "tax_identification_number": taxIdentificationNumber,
    "status": status,
    "user_id": userId,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Category {
  int id;
  String name;
  String description;
  int order;
  String? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.order,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    order: json["order"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "order": order,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
