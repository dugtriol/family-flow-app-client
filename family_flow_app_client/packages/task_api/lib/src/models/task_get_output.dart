import 'package:json_annotation/json_annotation.dart';

part 'task_get_output.g.dart';

@JsonSerializable()
class TaskGetOutputList {
  final List<TaskGetOutput> tasks;

  TaskGetOutputList({required this.tasks});

  factory TaskGetOutputList.fromJson(Map<String, dynamic> json) =>
      _$TaskGetOutputListFromJson(json);

  Map<String, dynamic> toJson() => _$TaskGetOutputListToJson(this);
}

@JsonSerializable()
class TaskGetOutput {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime? deadline;
  @JsonKey(name: 'assigned_to')
  final String? assignedTo;
  @JsonKey(name: 'created_by')
  final String createdBy;
  final int reward;

  TaskGetOutput({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.deadline,
    this.assignedTo,
    required this.createdBy,
    required this.reward,
  });

  factory TaskGetOutput.fromJson(Map<String, dynamic> json) =>
      _$TaskGetOutputFromJson(json);

  Map<String, dynamic> toJson() => _$TaskGetOutputToJson(this);
}
