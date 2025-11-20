class CategoryModel {
  final int id;
  final String name;
  final String? slug;
  final String description;
  final String? icon;
  final int? order;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? iconUrl;

  CategoryModel({
    required this.id,
    required this.name,
    this.slug,
    required this.description,
    this.icon,
    this.order,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.iconUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString(),
      order: json['order'] as int?,
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      iconUrl: json['icon_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
      'order': order,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'icon_url': iconUrl,
    };
  }
}