import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'reward.dart';

part 'reward_redemption.g.dart';

@JsonSerializable()
class RewardRedemption extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'reward_id')
  final String rewardId;
  @JsonKey(name: 'redeemed_at')
  final DateTime redeemedAt;
  final Reward reward;

  RewardRedemption({
    required this.id,
    required this.userId,
    required this.rewardId,
    required this.redeemedAt,
    required this.reward,
  });

  /// Фабрика для создания объекта `RewardRedemption` из JSON
  factory RewardRedemption.fromJson(Map<String, dynamic> json) =>
      _$RewardRedemptionFromJson(json);

  /// Метод для преобразования объекта `RewardRedemption` в JSON
  Map<String, dynamic> toJson() => _$RewardRedemptionToJson(this);

  @override
  List<Object?> get props => [id, userId, rewardId, redeemedAt, reward];
}
