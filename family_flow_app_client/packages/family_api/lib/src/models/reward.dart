import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward.g.dart';

@JsonSerializable()
class Reward extends Equatable {
  final String id;
  @JsonKey(name: 'family_id')
  final String familyId;
  final String title;
  final String description;
  final int cost;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Reward({
    required this.id,
    required this.familyId,
    required this.title,
    required this.description,
    required this.cost,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Фабрика для создания объекта `Reward` из JSON
  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);

  /// Метод для преобразования объекта `Reward` в JSON
  Map<String, dynamic> toJson() => _$RewardToJson(this);

  @override
  List<Object?> get props => [
    id,
    familyId,
    title,
    description,
    cost,
    createdAt,
    updatedAt,
  ];
}
