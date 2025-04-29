// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpForm _$SignUpFormFromJson(Map<String, dynamic> json) => SignUpForm(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$SignUpFormToJson(SignUpForm instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'role': instance.role,
    };
