class RestaurantModel {
  final int id;
  final String? banner;
  final String? logo;
  final String name;
  final String? description;
  final String email;
  final String phone;
  final String? cuisineType;
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
      id: json['id'],
      banner: json['banner'],
      logo: json['logo'],
      name: json['name'],
      description: json['description'],
      email: json['email'],
      phone: json['phone'],
      cuisineType: json['cuisine_type'],
      isActive: json['is_active'],
      isFeatured: json['is_featured'],
      commissionRate: json['commission_rate'],
      businessRegistrationNumber: json['business_registration_number'],
      taxIdentificationNumber: json['tax_identification_number'],
      status: json['status'],
      userId: json['user_id'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      id: json['id'],
      restaurantId: json['restaurant_id'],
      dayOfWeek: json['day_of_week'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
