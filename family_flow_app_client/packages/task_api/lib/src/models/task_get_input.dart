import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'task_get_input.g.dart';

/// A model for input to fetch tasks by status.
@JsonSerializable()
@immutable
class TaskGetInput {
  /// The status of the tasks to fetch.
  /// Can be one of: "active", "completed", "overdue".
  final String status;

  const TaskGetInput({required this.status});

  /// Factory constructor for creating a new `TaskGetInput` instance
  /// from a JSON map.
  factory TaskGetInput.fromJson(Map<String, dynamic> json) =>
      _$TaskGetInputFromJson(json);

  /// Converts this `TaskGetInput` instance to a JSON map.
  Map<String, dynamic> toJson() => _$TaskGetInputToJson(this);
}
