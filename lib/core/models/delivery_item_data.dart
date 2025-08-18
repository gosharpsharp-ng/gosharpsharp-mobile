import 'dart:io';

class DeliveryItemData {
  String name;
  String description;
  String category;
  int quantity;
  double weight;
  double height;
  String image;
  DeliveryItemData({
    required this.name,
    required this.description,
    required this.category,
    required this.quantity,
    required this.weight,
    required this.height,
    required this.image,
  });

  // From JSON
  factory DeliveryItemData.fromJson(Map<String, dynamic> json) {
    return DeliveryItemData(
        name: json['name'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        quantity: json['quantity'] as int,
        height: json['height'] as double,
        weight: json['weight'] as double,
        image: json['image'] as String);
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'quantity': quantity,
      'height': height,
      'weight': weight,
      'image': image,
    };
  }
}
