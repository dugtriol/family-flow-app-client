// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/todo_api/lib/src/models/input_create.dart
import 'package:json_annotation/json_annotation.dart';

part 'input_create.g.dart';

@JsonSerializable()
class TodoCreateInput {
  @JsonKey(name: 'family_id')
  final String familyId;
  final String title;
  final String description;
  final DateTime deadline;
  @JsonKey(name: 'assigned_to')
  final String assignedTo;

  TodoCreateInput({
    required this.familyId,
    required this.title,
    required this.description,
    required this.deadline,
    required this.assignedTo,
  });

  factory TodoCreateInput.fromJson(Map<String, dynamic> json) =>
      _$TodoCreateInputFromJson(json);

  Map<String, dynamic> toJson() => _$TodoCreateInputToJson(this);
}
