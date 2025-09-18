import 'package:gosharpsharp/core/models/categories_model.dart';
import 'package:gosharpsharp/core/models/restaurant_model.dart';

import 'item_file_model.dart';

class MenuItemModel {
  final int id;
  final String name;
  final CategoryModel category;
  final double price;
  final String duration;
  final RestaurantModel restaurant;
  final String image;
  final int isAvailable;
  final int availableQuantity;
  final String? description;
  final String? plateSize;
  final List<ItemFileModel> files;
  final bool? showOnCustomerApp;

  MenuItemModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.duration,
    required this.image,
    required this.isAvailable,
    required this.availableQuantity,
    this.description,
    required this.restaurant,
    this.plateSize,
    this.showOnCustomerApp,
    required this.files,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    final filesJson = json['files'] as List<dynamic>? ?? [];
    return MenuItemModel(
      id: json['id']??1 ,
      name: json['name']?.toString() ?? '',
      category: CategoryModel.fromJson(json['category']),
      restaurant: RestaurantModel.fromJson(json['restaurant']),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      duration: json['duration']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isAvailable: json['is_available'] ?? true,
      availableQuantity: int.tryParse(json['available_quantity']?.toString() ?? '0') ?? 0,
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
      'category': category,
      'price': price,
      'duration': duration,
      'image': image,
      'is_available': isAvailable,
      'available_quantity': availableQuantity,
      'description': description,
      'plate_size': plateSize,
      'show_on_customer_app': showOnCustomerApp,
      'files': files,
    };
  }


}

