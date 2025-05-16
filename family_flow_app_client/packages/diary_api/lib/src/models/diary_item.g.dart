// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiaryItem _$DiaryItemFromJson(Map<String, dynamic> json) => DiaryItem(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  emoji: json['emoji'] as String,
  createdBy: json['created_by'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$DiaryItemToJson(DiaryItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'emoji': instance.emoji,
  'created_by': instance.createdBy,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
