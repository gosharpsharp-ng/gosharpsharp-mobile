class AvailableRiderModel {
  final String riderId;
  final String name;
  final CourierType courierType;
  final String status;

  AvailableRiderModel({
    required this.riderId,
    required this.name,
    required this.courierType,
    required this.status,
  });

  factory AvailableRiderModel.fromJson(Map<String, dynamic> json) {
    return AvailableRiderModel(
      riderId: json['riderId'] as String,
      name: json['name'] as String,
      courierType: CourierType.fromJson(json['courierType']),
      status: json['status'] as String,
    );
  }
}

class CourierType {
  final int id;
  final String name;
  final String description;

  CourierType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CourierType.fromJson(Map<String, dynamic> json) {
    return CourierType(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}
