// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/shopping_api/lib/src/models/input_update.dart
import 'package:json_annotation/json_annotation.dart';

part 'input_update.g.dart';

@JsonSerializable()
class ShoppingUpdateInput {
  // final String id;
  final String title;
  final String description;
  final String status;
  final String visibility;
  @JsonKey(name: 'is_archived')
  final bool isArchived;

  ShoppingUpdateInput({
    // required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.visibility,
    required this.isArchived,
  });

  factory ShoppingUpdateInput.fromJson(Map<String, dynamic> json) =>
      _$ShoppingUpdateInputFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingUpdateInputToJson(this);
}
