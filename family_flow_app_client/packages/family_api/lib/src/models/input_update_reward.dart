import 'package:json_annotation/json_annotation.dart';

part 'input_update_reward.g.dart';

@JsonSerializable()
class RewardUpdateInput {
  @JsonKey(name: 'family_id')
  final String familyId;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'description')
  final String? description;

  @JsonKey(name: 'cost')
  final int cost;

  RewardUpdateInput({
    required this.familyId,
    required this.title,
    this.description,
    required this.cost,
  });

  /// Фабрика для создания объекта из JSON
  factory RewardUpdateInput.fromJson(Map<String, dynamic> json) =>
      _$RewardUpdateInputFromJson(json);

  /// Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => _$RewardUpdateInputToJson(this);
}
