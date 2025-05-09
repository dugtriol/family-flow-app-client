// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
  id: json['id'] as String,
  familyId: json['family_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  cost: (json['cost'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
  'id': instance.id,
  'family_id': instance.familyId,
  'title': instance.title,
  'description': instance.description,
  'cost': instance.cost,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
