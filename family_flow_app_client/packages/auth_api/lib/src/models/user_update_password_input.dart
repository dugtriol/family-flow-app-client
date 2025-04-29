// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/auth_api/lib/src/models/user_update.dart
import 'package:json_annotation/json_annotation.dart';

part 'user_update_password_input.g.dart';

@JsonSerializable()
class UserUpdatePasswordInput {
  const UserUpdatePasswordInput({required this.email, required this.password});

  final String email;
  final String password;

  factory UserUpdatePasswordInput.fromJson(Map<String, dynamic> json) =>
      _$UserUpdatePasswordInputFromJson(json);

  Map<String, dynamic> toJson() => _$UserUpdatePasswordInputToJson(this);
}
