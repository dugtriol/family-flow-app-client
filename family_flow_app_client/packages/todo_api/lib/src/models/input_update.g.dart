// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputTodoUpdate _$InputTodoUpdateFromJson(Map<String, dynamic> json) =>
    InputTodoUpdate(
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      assignedTo: json['assigned_to'] as String,
      point: (json['point'] as num).toInt(),
    );

Map<String, dynamic> _$InputTodoUpdateToJson(InputTodoUpdate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'deadline': instance.deadline.toIso8601String(),
      'assigned_to': instance.assignedTo,
      'point': instance.point,
    };
