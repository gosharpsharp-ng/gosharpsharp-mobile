// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faq_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FAQModel _$FAQModelFromJson(Map<String, dynamic> json) => FAQModel(
      category: json['category'] as String,
      faq: (json['faq'] as List<dynamic>)
          .map((e) => FAQItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FAQModelToJson(FAQModel instance) => <String, dynamic>{
      'category': instance.category,
      'faq': instance.faq,
    };

FAQItem _$FAQItemFromJson(Map<String, dynamic> json) => FAQItem(
      id: (json['id'] as num).toInt(),
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: json['category'] as String,
      isPublished: json['is_published'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$FAQItemToJson(FAQItem instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'answer': instance.answer,
      'category': instance.category,
      'is_published': instance.isPublished,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
