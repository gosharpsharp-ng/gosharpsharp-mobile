// Wallet Model
class WalletModel {
  final int id;
  final double balance;
  final double bonusBalance;
  final int currencyId;
  final String walletableType;
  final int walletableId;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  WalletModel({
    required this.id,
    required this.balance,
    required this.bonusBalance,
    required this.currencyId,
    required this.walletableType,
    required this.walletableId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? 0,
      balance: double.tryParse(json['balance']?.toString() ?? '0') ?? 0.0,
      bonusBalance:
          double.tryParse(json['bonus_balance']?.toString() ?? '0') ?? 0.0,
      currencyId: json['currency_id'] ?? 0,
      walletableType: json['walletable_type']?.toString() ?? '',
      walletableId: json['walletable_id'] ?? 0,
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance.toString(),
      'bonus_balance': bonusBalance.toString(),
      'currency_id': currencyId,
      'walletable_type': walletableType,
      'walletable_id': walletableId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  double get totalBalance => balance + bonusBalance;
}

// Notification Model
class NotificationModel {
  final int id;
  final String notifiableType;
  final int notifiableId;
  final String title;
  final String message;
  final String? status;
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
    this.status,
    required this.message,
    required this.priority,
    this.readAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      notifiableType: json['notifiable_type']?.toString() ?? '',
      notifiableId: json['notifiable_id'] ?? 0,
      title: json['title']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      priority: json['priority']?.toString() ?? 'medium',
      readAt: json['read_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
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

  bool get isRead => readAt != null;
  bool get isUnread => readAt == null;
}

// User Profile Model
class UserProfile {
  final int id;
  final String? avatar;
  final String? avatarUrl;
  final String fname;
  final String lname;
  final String phone;
  final String? dob;
  final String email;
  final String status;
  final String referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int failedLoginAttempts;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final WalletModel? wallet;
  final List<NotificationModel> notifications;
  final dynamic cart;
  final List<dynamic> carts;
  final List<dynamic> ratings;
  final List<dynamic> transactions;
  final dynamic bankAccount;

  UserProfile({
    required this.id,
    this.avatar,
    this.avatarUrl,
    required this.fname,
    required this.lname,
    required this.phone,
    this.dob,
    required this.email,
    required this.status,
    required this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    required this.failedLoginAttempts,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.wallet,
    this.notifications = const [],
    this.cart,
    this.carts = const [],
    this.ratings = const [],
    this.transactions = const [],
    this.bankAccount,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Parse notifications with null safety
    List<NotificationModel> parsedNotifications = [];
    if (json['notifications'] != null) {
      final notificationsJson = json['notifications'] as List<dynamic>?;
      if (notificationsJson != null) {
        parsedNotifications = notificationsJson
            .where((n) => n != null)
            .map((n) {
              try {
                return NotificationModel.fromJson(n as Map<String, dynamic>);
              } catch (e) {
                return null;
              }
            })
            .where((n) => n != null)
            .cast<NotificationModel>()
            .toList();
      }
    }

    // Parse wallet with null safety
    WalletModel? wallet;
    if (json['wallet'] != null) {
      try {
        wallet = WalletModel.fromJson(json['wallet'] as Map<String, dynamic>);
      } catch (e) {
        wallet = null;
      }
    }

    return UserProfile(
      id: json['id'] ?? 0,
      avatar: json['avatar']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      fname: json['fname']?.toString() ?? '',
      lname: json['lname']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      dob: json['dob']?.toString(),
      email: json['email']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      referralCode: json['referral_code']?.toString() ?? '',
      referredBy: json['referred_by']?.toString(),
      lastLoginAt: json['last_login_at']?.toString(),
      failedLoginAttempts: json['failed_login_attempts'] ?? 0,
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      wallet: wallet,
      notifications: parsedNotifications,
      cart: json['cart'],
      carts: json['carts'] as List<dynamic>? ?? [],
      ratings: json['ratings'] as List<dynamic>? ?? [],
      transactions: json['transactions'] as List<dynamic>? ?? [],
      bankAccount: json['bank_account'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'avatar_url': avatarUrl,
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'dob': dob,
      'email': email,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'wallet': wallet?.toJson(),
      'notifications': notifications.map((n) => n.toJson()).toList(),
      'cart': cart,
      'carts': carts,
      'ratings': ratings,
      'transactions': transactions,
      'bank_account': bankAccount,
    };
  }

  // Convenience getter for full name
  String get fullName => '$fname $lname';

  // Convenience getter to check if user is verified
  bool get isVerified => status == 'verified';

  // Convenience getter to check if user is active (not deleted)
  bool get isActive => deletedAt == null;

  // Wallet balance getter
  double get walletBalance => wallet?.balance ?? 0.0;
  double get walletBonusBalance => wallet?.bonusBalance ?? 0.0;
  double get totalWalletBalance => wallet?.totalBalance ?? 0.0;

  // Notifications getters
  int get unreadNotificationsCount =>
      notifications.where((n) => n.isUnread).length;
  bool get hasUnreadNotifications => unreadNotificationsCount > 0;
  List<NotificationModel> get unreadNotifications =>
      notifications.where((n) => n.isUnread).toList();
}
