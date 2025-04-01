// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/shopping_api/lib/src/models/input_create.dart
import 'package:json_annotation/json_annotation.dart';

part 'input_create.g.dart';

@JsonSerializable()
class ShoppingCreateInput {
  @JsonKey(name: 'family_id')
  final String familyId;
  final String title;
  final String description;
  final String visibility;

  ShoppingCreateInput({
    required this.familyId,
    required this.title,
    required this.description,
    required this.visibility,
  });

  factory ShoppingCreateInput.fromJson(Map<String, dynamic> json) =>
      _$ShoppingCreateInputFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingCreateInputToJson(this);
}
