import 'package:json_annotation/json_annotation.dart';
part 'profile.g.dart';

@JsonSerializable()
class ProfileModel {
  String? key;
  String? name;
  String? email;
  String? image;

  ProfileModel(
      {required this.key,
      required this.name,
      required this.email,
      required this.image});

  factory ProfileModel.fromJson(Map<String, String> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  factory ProfileModel.fromMap(String key, Map<dynamic, dynamic> map) {
    return ProfileModel(
        key: key,
        name: map['name'],
        email: map['email'],
        image: map['image']);
  }
}
