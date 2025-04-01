import 'package:json_annotation/json_annotation.dart';

part 'task_create_input.g.dart';

@JsonSerializable()
class TaskCreate {
  final String title;
  final String description;
  final DateTime deadline;
  @JsonKey(name: 'assigned_to')
  final String assignedTo;
  final int reward;

  TaskCreate({
    required this.title,
    required this.description,
    required this.deadline,
    required this.assignedTo,
    required this.reward,
  });

  factory TaskCreate.fromJson(Map<String, dynamic> json) =>
      _$TaskCreateFromJson(json);

  Map<String, dynamic> toJson() => _$TaskCreateToJson(this);
}
