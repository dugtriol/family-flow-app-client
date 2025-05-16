// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_update_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardUpdateInput _$RewardUpdateInputFromJson(Map<String, dynamic> json) =>
    RewardUpdateInput(
      familyId: json['family_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      cost: (json['cost'] as num).toInt(),
    );

Map<String, dynamic> _$RewardUpdateInputToJson(RewardUpdateInput instance) =>
    <String, dynamic>{
      'family_id': instance.familyId,
      'title': instance.title,
      'description': instance.description,
      'cost': instance.cost,
    };
