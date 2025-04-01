// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoCreateInput _$TodoCreateInputFromJson(Map<String, dynamic> json) =>
    TodoCreateInput(
      familyId: json['family_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      assignedTo: json['assigned_to'] as String,
    );

Map<String, dynamic> _$TodoCreateInputToJson(TodoCreateInput instance) =>
    <String, dynamic>{
      'family_id': instance.familyId,
      'title': instance.title,
      'description': instance.description,
      'deadline': instance.deadline.toIso8601String(),
      'assigned_to': instance.assignedTo,
    };
