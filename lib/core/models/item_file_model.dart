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
      id: json['id'],
      url: json['url'],
      disk: json['disk'],
      mimeType: json['mime_type'],
      fileableType: json['fileable_type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
