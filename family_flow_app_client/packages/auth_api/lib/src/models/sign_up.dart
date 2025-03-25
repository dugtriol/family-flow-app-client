import 'package:json_annotation/json_annotation.dart';

part 'sign_up.g.dart';

@JsonSerializable()
class SignUpForm {
  const SignUpForm({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory SignUpForm.fromJson(Map<String, dynamic> json) =>
      _$SignUpFormFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpFormToJson(this);

  final String name;
  final String email;
  final String password;
  final String role;
}
