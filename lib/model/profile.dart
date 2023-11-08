import 'package:json_annotation/json_annotation.dart';
part 'profile.g.dart';

@JsonSerializable()
class ProfileModel {
  String? name;
  String? email;
  String? image;

  ProfileModel({required this.name, required this.email, required this.image});

  factory ProfileModel.fromJson(Map<String, String> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
        name: map['name'] ?? null,
        email: map['email'] ?? null,
        image: map['image'] ?? null);
  }
}
