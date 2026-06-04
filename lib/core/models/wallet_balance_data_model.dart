class WalletBalanceDataModel {
  final String balance;
  final String bonusBalance;
  final int currencyId;

  WalletBalanceDataModel({
    required this.balance,
    required this.bonusBalance,
    required this.currencyId,
  });

  /// Helper method to safely convert any value to String
  static String _toStringValue(dynamic value) {
    if (value == null) return '0.0';
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    if (value is String) return value;
    return value.toString();
  }

  factory WalletBalanceDataModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceDataModel(
      balance: _toStringValue(json['balance']),
      bonusBalance: _toStringValue(json['bonus_balance']),
      currencyId: json['currency_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'bonus_balance': bonusBalance,
      'currency_id': currencyId,
    };
  }
}
