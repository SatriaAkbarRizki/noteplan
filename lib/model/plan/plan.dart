import 'package:json_annotation/json_annotation.dart';
part 'plan.g.dart';

@JsonSerializable()
class PlanModel {
  String title;
  List<String> listPlan;
  PlanModel({required this.title, required this.listPlan});

  factory PlanModel.fromJson(Map<String, List> json) =>
      _$PlanModelFromJson(json);

  factory PlanModel.fromMap(String key, Map<dynamic, dynamic> map) =>
      PlanModel(title: map['title'] ?? '', listPlan: map['listPlan'] ?? '');
}
