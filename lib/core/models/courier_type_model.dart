class DeliveryCourierType {
  final int id;
  final String name;
  final String? description;
  final String pricePerKilometer;
  final double baseFare;
  final double distanceCost;
  final double discount;
  final double additionalCharge;
  final double subtotal;
  final double vatRate;
  final double vatAmount;
  final double finalPrice;

  DeliveryCourierType({
    required this.id,
    required this.name,
    this.description,
    required this.pricePerKilometer,
    required this.baseFare,
    required this.distanceCost,
    required this.discount,
    required this.additionalCharge,
    required this.subtotal,
    required this.vatRate,
    required this.vatAmount,
    required this.finalPrice,
  });

  factory DeliveryCourierType.fromJson(Map<String, dynamic> json) {
    return DeliveryCourierType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pricePerKilometer: json['price_per_kilometer'],
      baseFare: (json['base_fare'] as num).toDouble(),
      distanceCost: (json['distance_cost'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      additionalCharge: (json['additional_charge'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      vatRate: (json['vat_rate'] as num).toDouble(),
      vatAmount: (json['vat_amount'] as num).toDouble(),
      finalPrice: (json['final_price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_per_kilometer': pricePerKilometer,
      'base_fare': baseFare,
      'distance_cost': distanceCost,
      'discount': discount,
      'additional_charge': additionalCharge,
      'subtotal': subtotal,
      'vat_rate': vatRate,
      'vat_amount': vatAmount,
      'final_price': finalPrice,
    };
  }

  // Helper method to get bike icon based on courier type name
  String get bikeIcon {
    final lowerName = name.toLowerCase();

    if (lowerName.contains('bike') || lowerName.contains('bicycle')) {
      return 'assets/images/png/local_ride_icon.png';
    } else if (lowerName.contains('express') || lowerName.contains('motorcycle')) {
      return 'assets/images/png/express_ride_icon.png';
    } else if (lowerName.contains('van') || lowerName.contains('cargo')) {
      return 'assets/images/png/van_icon.png';
    } else if (lowerName.contains('premium') || lowerName.contains('vip') || lowerName.contains('white glove')) {
      return 'assets/images/png/premium_car_icon.png';
    } else if (lowerName.contains('refrigerated') || lowerName.contains('cold')) {
      return 'assets/images/png/refrigerated_icon.png';
    } else if (lowerName.contains('freight') || lowerName.contains('heavy')) {
      return 'assets/images/png/freight_icon.png';
    } else {
      // Default icon
      return 'assets/images/png/local_ride_icon.png';
    }
  }
}
