// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteModel _$NoteModelFromJson(Map<String, dynamic> json) => NoteModel(
      keyData: json['keyData'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      image: json['image'] as String?,
      description: json['description'] as String,
    );

Map<String, dynamic> _$NoteModelToJson(NoteModel instance) => <String, dynamic>{
      'keyData': instance.keyData,
      'title': instance.title,
      'image': instance.image,
      'description': instance.description,
      'date': instance.date,
      'time': instance.time,
    };
