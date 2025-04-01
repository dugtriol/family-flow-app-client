// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/family_api/lib/src/models/input_get_members.dart
import 'package:json_annotation/json_annotation.dart';

part 'input_get_members.g.dart';

@JsonSerializable()
class InputGetMembers {
  @JsonKey(name: 'family_id')
  final String familyId;

  InputGetMembers({
    required this.familyId,
  });

  factory InputGetMembers.fromJson(Map<String, dynamic> json) =>
      _$InputGetMembersFromJson(json);

  Map<String, dynamic> toJson() => _$InputGetMembersToJson(this);
}
