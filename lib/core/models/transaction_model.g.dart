// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: (json['id'] as num).toInt(),
      paymentReference: json['payment_reference'] as String,
      amount: json['amount'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      currencyId: (json['currency_id'] as num?)?.toInt(),
      gatewayId: (json['gateway_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment_reference': instance.paymentReference,
      'amount': instance.amount,
      'type': instance.type,
      'description': instance.description,
      'status': instance.status,
      'currency_id': instance.currencyId,
      'gateway_id': instance.gatewayId,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
