// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_redemption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardRedemption _$RewardRedemptionFromJson(Map<String, dynamic> json) =>
    RewardRedemption(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      rewardId: json['reward_id'] as String,
      redeemedAt: DateTime.parse(json['redeemed_at'] as String),
      reward: Reward.fromJson(json['reward'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RewardRedemptionToJson(RewardRedemption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'reward_id': instance.rewardId,
      'redeemed_at': instance.redeemedAt.toIso8601String(),
      'reward': instance.reward,
    };
