// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_update_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryUpdateInput _$DiaryUpdateInputFromJson(Map<String, dynamic> json) =>
    DiaryUpdateInput(
      title: json['title'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
    );

Map<String, dynamic> _$DiaryUpdateInputToJson(DiaryUpdateInput instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'emoji': instance.emoji,
    };
