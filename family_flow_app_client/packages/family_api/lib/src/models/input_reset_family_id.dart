// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/family_api/lib/src/models/input_reset_family_id.dart
import 'package:json_annotation/json_annotation.dart';

part 'input_reset_family_id.g.dart';

@JsonSerializable()
class ResetFamilyIdInput {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'family_id')
  final String familyId;

  ResetFamilyIdInput({required this.id, required this.familyId});

  factory ResetFamilyIdInput.fromJson(Map<String, dynamic> json) =>
      _$ResetFamilyIdInputFromJson(json);

  Map<String, dynamic> toJson() => _$ResetFamilyIdInputToJson(this);
}
