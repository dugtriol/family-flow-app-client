// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_add_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputAddMemberToFamily _$InputAddMemberToFamilyFromJson(
  Map<String, dynamic> json,
) => InputAddMemberToFamily(
  emailUser: json['email_user'] as String,
  familyId: json['family_id'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$InputAddMemberToFamilyToJson(
  InputAddMemberToFamily instance,
) => <String, dynamic>{
  'email_user': instance.emailUser,
  'family_id': instance.familyId,
  'role': instance.role,
};
