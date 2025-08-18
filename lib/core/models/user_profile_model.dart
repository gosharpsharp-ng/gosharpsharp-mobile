import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfile {
  final int id;
  final String? avatar;
  final String fname;
  final String lname;
  final String phone;
  @JsonKey(name: "leaf", defaultValue: 0)
  final int leaf;
  final String email;
  final String role;
  final String status;
  @JsonKey(name: 'referral_code')
  final String? referralCode;
  @JsonKey(name: 'referred_by')
  final String? referredBy;
  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;
  @JsonKey(name: 'failed_login_attempts')
  final int failedLoginAttempts;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'is_email_verified')
  final bool isEmailVerified;
  @JsonKey(name: 'is_phone_verified')
  final bool isPhoneVerified;

  UserProfile({
    required this.id,
    this.avatar,
    required this.fname,
    required this.leaf,
    required this.lname,
    required this.phone,
    required this.email,
    required this.role,
    required this.status,
    this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    required this.failedLoginAttempts,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    required this.isPhoneVerified,
  });

  // Factory method to create an instance from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
