import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class Transaction {
  final int id;
  @JsonKey(name: 'payment_reference')
  final String paymentReference;
  final String amount;
  final String type;
  final String description;
  final String status;
  @JsonKey(name: 'currency_id')
  final int? currencyId;
  @JsonKey(name: 'gateway_id')
  final int? gatewayId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Transaction({
    required this.id,
    required this.paymentReference,
    required this.amount,
    required this.type,
    required this.description,
    required this.status,
    this.currencyId,
    this.gatewayId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
