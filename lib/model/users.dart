import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'users.g.dart';

@JsonSerializable()
class UserModel {
  String name;
  String email;
  String profile_image;

  UserModel(
      {required this.name, required this.email, required this.profile_image});
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        profile_image: map['profile_image'] ?? '');
  }
}
