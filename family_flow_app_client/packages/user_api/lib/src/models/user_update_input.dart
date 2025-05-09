import 'dart:io' show File;

import 'package:json_annotation/json_annotation.dart';

part 'user_update_input.g.dart';

@JsonSerializable()
class UserUpdateInput {
  const UserUpdateInput({
    required this.name,
    required this.email,
    required this.role,
    required this.gender,
    required this.birthDate,
    required this.avatar,
  });

  final String name;
  final String email;
  final String role;
  final String gender;
  final DateTime? birthDate;
  final File? avatar;

  // UserUpdateInput _$UserUpdateInputFromJson(Map<String, dynamic> json) =>
  //     UserUpdateInput(
  //       name: json['name'] as String,
  //       email: json['email'] as String,
  //       role: json['role'] as String,
  //       gender: json['gender'] as String,
  //       birthDate: json['birthDate'] as String,
  //       avatar: json['avatar'] as String,
  //     );

  factory UserUpdateInput.fromJson(Map<String, dynamic> json) {
    return UserUpdateInput(
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      gender: json['gender'] as String,
      birthDate:
          json['birth_date'] != null
              ? DateTime.parse(json['birth_date'] as String)
              : null,
      avatar: null,
    );
  }

  Map<String, dynamic> toJson() => _$UserUpdateInputToJson(this);
}
