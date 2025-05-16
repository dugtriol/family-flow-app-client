// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_create_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryCreateInput _$DiaryCreateInputFromJson(Map<String, dynamic> json) =>
    DiaryCreateInput(
      title: json['title'] as String,
      description: json['description'] as String,
      emoji: json['emoji'] as String,
    );

Map<String, dynamic> _$DiaryCreateInputToJson(DiaryCreateInput instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'emoji': instance.emoji,
    };
