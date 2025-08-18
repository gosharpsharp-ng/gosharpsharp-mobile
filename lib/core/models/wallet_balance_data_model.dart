import 'package:json_annotation/json_annotation.dart';

part 'wallet_balance_data_model.g.dart';

@JsonSerializable()
class WalletBalanceDataModel {
  final int id;
  @JsonKey(name: 'available_balance')
  final String availableBalance;
  @JsonKey(name: 'pending_balance')
  final String pendingBalance;
  @JsonKey(name: 'bonus_balance')
  final String bonusBalance;
  @JsonKey(name: 'currency_id')
  final int? currencyId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  WalletBalanceDataModel({
    required this.id,
    required this.availableBalance,
    required this.pendingBalance,
    required this.bonusBalance,
    this.currencyId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory WalletBalanceDataModel.fromJson(Map<String, dynamic> json) => _$WalletBalanceDataModelFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$WalletBalanceDataModelToJson(this);
}
