// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoItem _$TodoItemFromJson(Map<String, dynamic> json) => TodoItem(
  id: json['id'] as String,
  familyId: json['family_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  status: json['status'] as String,
  deadline: DateTime.parse(json['deadline'] as String),
  assignedTo: json['assigned_to'] as String,
  createdBy: json['created_by'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  point: (json['point'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TodoItemToJson(TodoItem instance) => <String, dynamic>{
  'id': instance.id,
  'family_id': instance.familyId,
  'title': instance.title,
  'description': instance.description,
  'status': instance.status,
  'deadline': instance.deadline.toIso8601String(),
  'assigned_to': instance.assignedTo,
  'created_by': instance.createdBy,
  'created_at': instance.createdAt.toIso8601String(),
  'point': instance.point,
};
