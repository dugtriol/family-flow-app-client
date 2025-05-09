import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'input_create_reward.g.dart';

@JsonSerializable()
class RewardCreateInput extends Equatable {
  @JsonKey(name: 'family_id')
  final String familyId;
  final String title;
  final String? description;
  final int cost;

  RewardCreateInput({
    required this.familyId,
    required this.title,
    this.description,
    required this.cost,
  });

  /// Фабрика для создания объекта `RewardCreateInput` из JSON
  factory RewardCreateInput.fromJson(Map<String, dynamic> json) =>
      _$RewardCreateInputFromJson(json);

  /// Метод для преобразования объекта `RewardCreateInput` в JSON
  Map<String, dynamic> toJson() => _$RewardCreateInputToJson(this);

  @override
  List<Object?> get props => [familyId, title, description, cost];
}
