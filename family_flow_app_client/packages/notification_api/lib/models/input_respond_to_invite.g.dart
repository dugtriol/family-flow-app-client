// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_respond_to_invite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RespondToInviteInput _$RespondToInviteInputFromJson(
  Map<String, dynamic> json,
) => RespondToInviteInput(
  familyId: json['family_id'] as String,
  role: json['role'] as String,
  response: json['response'] as String,
);

Map<String, dynamic> _$RespondToInviteInputToJson(
  RespondToInviteInput instance,
) => <String, dynamic>{
  'family_id': instance.familyId,
  'role': instance.role,
  'response': instance.response,
};
