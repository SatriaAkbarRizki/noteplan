import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class NoteModel {
  String title;
  String? image;
  String description;
  String date;
  String time;

  NoteModel(
      {required this.title,
      required this.date,
      required this.time,
      required this.image,
      required this.description});

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      _$NoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelToJson(this);

  // factory NoteModel.fromMap(Map<dynamic, dynamic> map) {
  //   return NoteModel(
  //       title: map['title'],
  //       date: map['date'],
  //       time: map['time'],
  //       image: map['image'] ?? null,
  //       description: map['description']);
  // }

    factory NoteModel.fromMap(Map<dynamic, dynamic> map) {
    return NoteModel(
        title: map['title'] ?? '',
        date: map['date'] ?? '',
        time: map['time'] ?? '',
        image: map['image'] ?? '',
        description: map['description'] ?? '');
  }
}
