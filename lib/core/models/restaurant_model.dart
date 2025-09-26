class FavouriteRestaurantModel {
  final int id;
  final int userId;
  final String favoritableType;
  final int favoritableId;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final RestaurantModel? favoritable;

  FavouriteRestaurantModel({
    required this.id,
    required this.userId,
    required this.favoritableType,
    required this.favoritableId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.favoritable,
  });

  factory FavouriteRestaurantModel.fromJson(Map<String, dynamic> json) {
    return FavouriteRestaurantModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      favoritableType: json['favoritable_type']?.toString() ?? '',
      favoritableId: json['favoritable_id'] ?? 0,
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      favoritable: json['favoritable'] != null
          ? RestaurantModel.fromJson(json['favoritable'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'favoritable_type': favoritableType,
      'favoritable_id': favoritableId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'favoritable': favoritable?.toJson(),
    };
  }
}

class RestaurantModel {
  final int id;
  final String? banner;
  final String? logo;
  final String name;
  final String? description;
  final String email;
  final String phone;
  final String? cuisineType;
  final String distance;
  final int isActive;
  final int isFeatured;
  final String commissionRate;
  final String? businessRegistrationNumber;
  final String? taxIdentificationNumber;
  final String status;
  final int userId;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final List<Schedule>? schedules;

  RestaurantModel({
    required this.id,
    this.banner,
    this.logo,
    required this.name,
    this.description,
    required this.email,
    required this.phone,
    this.cuisineType,
    required this.isActive,
    required this.isFeatured,
    required this.distance,
    required this.commissionRate,
    this.businessRegistrationNumber,
    this.taxIdentificationNumber,
    required this.status,
    required this.userId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.schedules,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? 0,
      banner: json['banner']?.toString(),
      logo: json['logo']?.toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      distance: json['distance']?.toString() ?? '0.0',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      cuisineType: json['cuisine_type']?.toString(),
      isActive: json['is_active'] ?? 0,
      isFeatured: json['is_featured'] ?? 0,
      commissionRate: json['commission_rate']?.toString() ?? '0.0',
      businessRegistrationNumber: json['business_registration_number']?.toString(),
      taxIdentificationNumber: json['tax_identification_number']?.toString(),
      status: json['status']?.toString() ?? '',
      userId: json['user_id'] ?? 0,
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      schedules: json['schedules'] != null
          ? (json['schedules'] as List)
          .map((s) => Schedule.fromJson(s))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banner': banner,
      'logo': logo,
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'cuisine_type': cuisineType,
      'is_active': isActive,
      'is_featured': isFeatured,
      'commission_rate': commissionRate,
      'business_registration_number': businessRegistrationNumber,
      'tax_identification_number': taxIdentificationNumber,
      'status': status,
      'user_id': userId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'schedules': schedules?.map((s) => s.toJson()).toList(),
    };
  }
}

class Schedule {
  final int id;
  final int restaurantId;
  final String dayOfWeek;
  final String openTime;
  final String closeTime;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  Schedule({
    required this.id,
    required this.restaurantId,
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] ?? 0,
      restaurantId: json['restaurant_id'] ?? 0,
      dayOfWeek: json['day_of_week']?.toString() ?? '',
      openTime: json['open_time']?.toString() ?? '',
      closeTime: json['close_time']?.toString() ?? '',
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'day_of_week': dayOfWeek,
      'open_time': openTime,
      'close_time': closeTime,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}