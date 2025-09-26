class WalletBalanceDataModel {
  final String balance;
  final String bonusBalance;
  final int currencyId;

  WalletBalanceDataModel({
    required this.balance,
    required this.bonusBalance,
    required this.currencyId,
  });

  factory WalletBalanceDataModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceDataModel(
      balance: json['balance'] as String,
      bonusBalance: json['bonus_balance'] as String,
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
