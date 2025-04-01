import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todo_item.g.dart';

@JsonSerializable()
class TodoItem extends Equatable {
  final String id;
  @JsonKey(name: 'family_id')
  final String familyId;
  final String title;
  final String description;
  final String status;
  final DateTime deadline;
  @JsonKey(name: 'assigned_to')
  final String assignedTo;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  const TodoItem({
    required this.id,
    required this.familyId,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    required this.assignedTo,
    required this.createdBy,
    required this.createdAt,
  });

  /// Фабрика для создания объекта из JSON
  factory TodoItem.fromJson(Map<String, dynamic> json) =>
      _$TodoItemFromJson(json);

  /// Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => _$TodoItemToJson(this);

  @override
  List<Object?> get props => [
        id,
        familyId,
        title,
        description,
        status,
        deadline,
        assignedTo,
        createdBy,
        createdAt,
      ];
}
