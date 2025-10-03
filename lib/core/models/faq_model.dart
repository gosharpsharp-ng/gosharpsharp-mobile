import 'package:json_annotation/json_annotation.dart';

part 'faq_model.g.dart';

@JsonSerializable()
class FAQModel {
  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'faq')
  final List<FAQItem> faq;

  FAQModel({required this.category, required this.faq});

  factory FAQModel.fromJson(Map<String, dynamic> json) =>
      _$FAQModelFromJson(json);
  Map<String, dynamic> toJson() => _$FAQModelToJson(this);
}

@JsonSerializable()
class FAQItem {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'question')
  final String question;

  @JsonKey(name: 'answer')
  final String answer;

  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'is_published')
  final bool isPublished;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FAQItem.fromJson(Map<String, dynamic> json) =>
      _$FAQItemFromJson(json);
  Map<String, dynamic> toJson() => _$FAQItemToJson(this);
}
