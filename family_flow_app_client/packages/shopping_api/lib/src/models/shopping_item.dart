// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/shopping_api/lib/src/models/shopping_item.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'shopping_item.g.dart';

@JsonSerializable()
class ShoppingItem extends Equatable {
  final String id;
  @JsonKey(name: 'family_id')
  final String familyId;
  final String title;
  final String description;
  final String status;
  final String visibility;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  ShoppingItem({
    required this.id,
    required this.familyId,
    required this.title,
    required this.description,
    required this.status,
    required this.visibility,
    required this.createdBy,
    required this.createdAt,
  });

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingItemToJson(this);

  @override
  List<Object?> get props => [
        id,
        familyId,
        title,
        description,
        status,
        visibility,
        createdBy,
        createdAt,
      ];
}
