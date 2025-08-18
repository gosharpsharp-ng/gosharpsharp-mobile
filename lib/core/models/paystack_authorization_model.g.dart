// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paystack_authorization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayStackAuthorizationModel _$PayStackAuthorizationModelFromJson(
        Map<String, dynamic> json) =>
    PayStackAuthorizationModel(
      authorizationUrl: json['authorization_url'] as String,
      accessCode: json['access_code'] as String,
      reference: json['reference'] as String,
    );

Map<String, dynamic> _$PayStackAuthorizationModelToJson(
        PayStackAuthorizationModel instance) =>
    <String, dynamic>{
      'authorization_url': instance.authorizationUrl,
      'access_code': instance.accessCode,
      'reference': instance.reference,
    };
