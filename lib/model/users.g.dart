// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      key: json['key'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profile_image: json['profile_image'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'email': instance.email,
      'profile_image': instance.profile_image,
    };
