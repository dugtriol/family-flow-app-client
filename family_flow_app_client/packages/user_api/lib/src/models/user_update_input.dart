// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/user_api/lib/src/models/user_update.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_update_input.g.dart';

@JsonSerializable()
class UserUpdateInput {
  const UserUpdateInput({
    required this.name,
    required this.email,
    required this.role,
  });

  final String name;
  final String email;
  final String role;

  factory UserUpdateInput.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateInputFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdateInputToJson(this);
}
