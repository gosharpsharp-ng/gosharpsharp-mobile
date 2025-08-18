import 'package:json_annotation/json_annotation.dart';

part 'bank_model.g.dart';

@JsonSerializable()
class BankModel {
  final int id;
  final String name;
  final String slug;
  final String code;
  final String? longcode;
  final String? gateway;
  @JsonKey(name: 'pay_with_bank')
  final bool payWithBank;
  @JsonKey(name: 'supports_transfer')
  final bool supportsTransfer;
  final bool active;
  final String country;
  final String currency;
  final String type;
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  BankModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.code,
    this.longcode,
    this.gateway,
    required this.payWithBank,
    required this.supportsTransfer,
    required this.active,
    required this.country,
    required this.currency,
    required this.type,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory method to generate a `BankModel` instance from JSON
  factory BankModel.fromJson(Map<String, dynamic> json) => _$BankModelFromJson(json);

  /// Method to convert `BankModel` instance to JSON
  Map<String, dynamic> toJson() => _$BankModelToJson(this);
}