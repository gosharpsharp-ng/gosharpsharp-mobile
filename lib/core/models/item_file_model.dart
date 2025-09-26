class ItemFileModel {
  final int id;
  final String url;
  final String disk;
  final String mimeType;
  final String fileableType;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItemFileModel({
    required this.id,
    required this.url,
    required this.disk,
    required this.mimeType,
    required this.fileableType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemFileModel.fromJson(Map<String, dynamic> json) {
    return ItemFileModel(
      id: json['id'] ?? 0,
      url: json['url']?.toString() ?? '',
      disk: json['disk']?.toString() ?? '',
      mimeType: json['mime_type']?.toString() ?? '',
      fileableType: json['fileable_type']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'disk': disk,
      'mime_type': mimeType,
      'fileable_type': fileableType,
      // 'fileable_id' omitted as requested
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
