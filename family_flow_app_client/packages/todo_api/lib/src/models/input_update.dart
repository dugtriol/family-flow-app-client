import 'package:json_annotation/json_annotation.dart';

part 'input_update.g.dart';

@JsonSerializable()
class InputTodoUpdate {
  final String title;
  final String description;
  final String status;
  final DateTime deadline;
  @JsonKey(name: 'assigned_to')
  final String assignedTo;

  InputTodoUpdate({
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    required this.assignedTo,
  });

  factory InputTodoUpdate.fromJson(Map<String, dynamic> json) =>
      _$InputTodoUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$InputTodoUpdateToJson(this);
}
