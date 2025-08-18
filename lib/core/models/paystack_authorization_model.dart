import 'package:json_annotation/json_annotation.dart';

part 'paystack_authorization_model.g.dart';

@JsonSerializable()
class PayStackAuthorizationModel {
  @JsonKey(name: 'authorization_url')
  final String authorizationUrl;
  @JsonKey(name: 'access_code')
  final String accessCode;
  final String reference;

  PayStackAuthorizationModel({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  // Factory method to create an instance from JSON
  factory PayStackAuthorizationModel.fromJson(Map<String, dynamic> json) =>
      _$PayStackAuthorizationModelFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$PayStackAuthorizationModelToJson(this);
}
