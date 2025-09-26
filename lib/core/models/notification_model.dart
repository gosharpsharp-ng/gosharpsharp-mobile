class NotificationModel {
  final int id;
  final String notifiableType;
  final int notifiableId;
  final String title;
  final String message;
  final String priority;
  final String? readAt;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.notifiableType,
    required this.notifiableId,
    required this.title,
    required this.message,
    required this.priority,
    this.readAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      notifiableType: json['notifiable_type'],
      notifiableId: json['notifiable_id'],
      title: json['title'],
      message: json['message'],
      priority: json['priority'],
      readAt: json['read_at'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notifiable_type': notifiableType,
      'notifiable_id': notifiableId,
      'title': title,
      'message': message,
      'priority': priority,
      'read_at': readAt,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
