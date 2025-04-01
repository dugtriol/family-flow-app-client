// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_create_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskCreate _$TaskCreateFromJson(Map<String, dynamic> json) => TaskCreate(
      title: json['title'] as String,
      description: json['description'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      assignedTo: json['assigned_to'] as String,
      reward: (json['reward'] as num).toInt(),
    );

Map<String, dynamic> _$TaskCreateToJson(TaskCreate instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'deadline': instance.deadline.toIso8601String(),
      'assigned_to': instance.assignedTo,
      'reward': instance.reward,
    };
