// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_participant_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddParticipantInput _$AddParticipantInputFromJson(Map<String, dynamic> json) =>
    AddParticipantInput(
      chatId: json['chat_id'] as String,
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$AddParticipantInputToJson(
  AddParticipantInput instance,
) => <String, dynamic>{'chat_id': instance.chatId, 'user_id': instance.userId};
