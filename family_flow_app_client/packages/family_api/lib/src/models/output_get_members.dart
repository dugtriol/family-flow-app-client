// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/family_api/lib/src/models/output_get_members.dart
import 'package:json_annotation/json_annotation.dart';
import 'package:user_repository/user_repository.dart' show User;

part 'output_get_members.g.dart';

@JsonSerializable()
class OutputGetMembers {
  final List<User> users;

  OutputGetMembers({
    required this.users,
  });

  factory OutputGetMembers.fromJson(Map<String, dynamic> json) =>
      _$OutputGetMembersFromJson(json);

  Map<String, dynamic> toJson() => _$OutputGetMembersToJson(this);
}
