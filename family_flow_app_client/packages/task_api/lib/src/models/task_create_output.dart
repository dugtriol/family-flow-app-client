import 'package:json_annotation/json_annotation.dart';

part 'task_create_output.g.dart';

@JsonSerializable()
class TaskCreateOutput {
  final String id;

  TaskCreateOutput({required this.id});

  factory TaskCreateOutput.fromJson(Map<String, dynamic> json) =>
      _$TaskCreateOutputFromJson(json);

  Map<String, dynamic> toJson() => _$TaskCreateOutputToJson(this);
}
