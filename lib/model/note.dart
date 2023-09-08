import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';
@JsonSerializable()
class NoteModel {
  String title;
  String? image;
  String description;

  NoteModel(
      {required this.title, required this.image, required this.description});

  factory NoteModel.fromJson(Map<String, dynamic> json) => _$NoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelToJson(this);
}
