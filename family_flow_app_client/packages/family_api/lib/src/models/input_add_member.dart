// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/family_api/lib/src/models/input_add_member.dart
import 'package:json_annotation/json_annotation.dart';

part 'input_add_member.g.dart';

@JsonSerializable()
class InputAddMemberToFamily {
  @JsonKey(name: 'email_user')
  final String emailUser;

  @JsonKey(name: 'family_id')
  final String familyId;

  InputAddMemberToFamily({
    required this.emailUser,
    required this.familyId,
  });

  factory InputAddMemberToFamily.fromJson(Map<String, dynamic> json) =>
      _$InputAddMemberToFamilyFromJson(json);

  Map<String, dynamic> toJson() => _$InputAddMemberToFamilyToJson(this);
}
