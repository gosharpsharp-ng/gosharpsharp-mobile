class FaqDataModel {
  final String name;
  final List<FaqItem> faqs;

  FaqDataModel({required this.name, required this.faqs});

  factory FaqDataModel.fromJson(Map<String, dynamic> json) {
    var faqList = json['faqs'] as List;
    List<FaqItem> faqItems = faqList.map((faq) => FaqItem.fromJson(faq)).toList();

    return FaqDataModel(
      name: json['name'] as String,
      faqs: faqItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'faqs': faqs.map((faq) => faq.toJson()).toList(),
    };
  }
}

class FaqItem {
  final int id;
  final String question;
  final String answer;
  final int category_id;
  final bool is_active;
  final String created_at;
  final String updated_at;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category_id,
    required this.is_active,
    required this.created_at,
    required this.updated_at,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
      category_id: json['category_id'] as int,
      is_active: json['is_active'] as bool,
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category_id': category_id,
      'is_active': is_active,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
