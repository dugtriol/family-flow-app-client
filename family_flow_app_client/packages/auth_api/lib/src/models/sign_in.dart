import 'package:json_annotation/json_annotation.dart';

part 'sign_in.g.dart';

@JsonSerializable()
class SignInForm {
  const SignInForm({
    required this.email,
    required this.password,
  });

  factory SignInForm.fromJson(Map<String, dynamic> json) =>
      _$SignInFormFromJson(json);

  Map<String, dynamic> toJson() => _$SignInFormToJson(this);

  final String email;
  final String password;
}
