// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_create_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardCreateInput _$RewardCreateInputFromJson(Map<String, dynamic> json) =>
    RewardCreateInput(
      familyId: json['family_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      cost: (json['cost'] as num).toInt(),
    );

Map<String, dynamic> _$RewardCreateInputToJson(RewardCreateInput instance) =>
    <String, dynamic>{
      'family_id': instance.familyId,
      'title': instance.title,
      'description': instance.description,
      'cost': instance.cost,
    };
