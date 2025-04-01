// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_get_output.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskGetOutputList _$TaskGetOutputListFromJson(Map<String, dynamic> json) =>
    TaskGetOutputList(
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => TaskGetOutput.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskGetOutputListToJson(TaskGetOutputList instance) =>
    <String, dynamic>{
      'tasks': instance.tasks,
    };

TaskGetOutput _$TaskGetOutputFromJson(Map<String, dynamic> json) =>
    TaskGetOutput(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      assignedTo: json['assigned_to'] as String?,
      createdBy: json['created_by'] as String,
      reward: (json['reward'] as num).toInt(),
    );

Map<String, dynamic> _$TaskGetOutputToJson(TaskGetOutput instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'deadline': instance.deadline?.toIso8601String(),
      'assigned_to': instance.assignedTo,
      'created_by': instance.createdBy,
      'reward': instance.reward,
    };
