import 'package:gosharpsharp/core/models/categories_model.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';

import 'item_file_model.dart';

class MenuItemModel {
  final int id;
  final String name;
  final CategoryModel category;
  final double price;
  final int prepTimeMinutes;
  final RestaurantModel restaurant;
  final int isAvailable;
  final int isPublished;
  final int quantity;
  final String? description;
  final String? plateSize;
  final List<ItemFileModel> files;
  final bool? showOnCustomerApp;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.prepTimeMinutes,
    required this.restaurant,
    required this.isAvailable,
    required this.isPublished,
    required this.quantity,
    this.description,
    this.plateSize,
    this.showOnCustomerApp,
    required this.files,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final filesJson = json['files'] as List<dynamic>? ?? [];

    return MenuItemModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      category: CategoryModel.fromJson(json['category']),
      restaurant: RestaurantModel.fromJson(json['restaurant']),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      prepTimeMinutes: json['prep_time_minutes'] ?? 0,
      // image: filesJson.isNotEmpty ? filesJson.first['url']?.toString() : null,
      isAvailable: json['is_available'] ?? 0,
      isPublished: json['is_published'] ?? 0,
      quantity: json['quantity'] ?? 0,
      description: json['description']?.toString(),
      plateSize: json['plate_size']?.toString(),
      showOnCustomerApp: json['show_on_customer_app'],
      files: filesJson.map((e) => ItemFileModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toJson(),
      'restaurant': restaurant.toJson(),
      'price': price,
      'prep_time_minutes': prepTimeMinutes,
      // 'image': image,
      'is_available': isAvailable,
      'is_published': isPublished,
      'quantity': quantity,
      'description': description,
      'plate_size': plateSize,
      'show_on_customer_app': showOnCustomerApp,
      'files': files.map((e) => e.toJson()).toList(),
    };
  }
}


