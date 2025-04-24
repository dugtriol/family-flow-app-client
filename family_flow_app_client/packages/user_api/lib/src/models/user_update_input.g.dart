// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateInput _$UserUpdateInputFromJson(Map<String, dynamic> json) =>
    UserUpdateInput(
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$UserUpdateInputToJson(UserUpdateInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'role': instance.role,
    };
