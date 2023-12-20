// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
      title: json['title'] as String,
      listPlan:
          (json['listPlan'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
      'title': instance.title,
      'listPlan': instance.listPlan,
    };
