import 'package:flutter/material.dart';

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

  /// Check if the restaurant is currently open based on schedules
  bool isOpen() {
    if (schedules == null || schedules!.isEmpty) {
      // If no schedules, assume open (or you can return false to be strict)
      return true;
    }

    final now = DateTime.now();
    final currentDayOfWeek = _getDayOfWeekString(now.weekday);
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);

    // Find today's schedule
    final todaySchedule = schedules!.firstWhere(
      (schedule) => schedule.dayOfWeek.toLowerCase() == currentDayOfWeek.toLowerCase(),
      orElse: () => Schedule(
        id: 0,
        restaurantId: id,
        dayOfWeek: '',
        openTime: '',
        closeTime: '',
        createdAt: '',
        updatedAt: '',
      ),
    );

    // If no schedule for today, restaurant is closed
    if (todaySchedule.dayOfWeek.isEmpty) {
      return false;
    }

    // Parse open and close times
    final openTime = _parseTimeOfDay(todaySchedule.openTime);
    final closeTime = _parseTimeOfDay(todaySchedule.closeTime);

    if (openTime == null || closeTime == null) {
      // If times can't be parsed, assume open to avoid blocking
      return true;
    }

    // Convert TimeOfDay to minutes for comparison
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final openMinutes = openTime.hour * 60 + openTime.minute;
    final closeMinutes = closeTime.hour * 60 + closeTime.minute;

    // Handle cases where closing time is past midnight
    if (closeMinutes < openMinutes) {
      // Restaurant is open past midnight
      return currentMinutes >= openMinutes || currentMinutes <= closeMinutes;
    } else {
      // Normal case: open and close on same day
      return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
    }
  }

  /// Get operating hours text for display
  String getOperatingHoursText() {
    if (schedules == null || schedules!.isEmpty) {
      return 'Hours not available';
    }

    final now = DateTime.now();
    final currentDayOfWeek = _getDayOfWeekString(now.weekday);

    final todaySchedule = schedules!.firstWhere(
      (schedule) => schedule.dayOfWeek.toLowerCase() == currentDayOfWeek.toLowerCase(),
      orElse: () => Schedule(
        id: 0,
        restaurantId: id,
        dayOfWeek: '',
        openTime: '',
        closeTime: '',
        createdAt: '',
        updatedAt: '',
      ),
    );

    if (todaySchedule.dayOfWeek.isEmpty) {
      return 'Closed today';
    }

    final openTime = _formatTime(todaySchedule.openTime);
    final closeTime = _formatTime(todaySchedule.closeTime);

    return '$openTime - $closeTime';
  }

  /// Helper to get day of week string from weekday number
  String _getDayOfWeekString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  /// Helper to parse time string (HH:mm:ss or HH:mm) to TimeOfDay
  TimeOfDay? _parseTimeOfDay(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      // Return null if parsing fails
    }
    return null;
  }

  /// Helper to format time string for display
  String _formatTime(String timeString) {
    final timeOfDay = _parseTimeOfDay(timeString);
    if (timeOfDay == null) return timeString;

    final hour = timeOfDay.hour;
    final minute = timeOfDay.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
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