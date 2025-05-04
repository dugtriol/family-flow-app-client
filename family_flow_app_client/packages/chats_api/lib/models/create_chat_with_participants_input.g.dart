// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_chat_with_participants_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateChatWithParticipantsInput _$CreateChatWithParticipantsInputFromJson(
  Map<String, dynamic> json,
) => CreateChatWithParticipantsInput(
  name: json['name'] as String,
  participantIds:
      (json['participant_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$CreateChatWithParticipantsInputToJson(
  CreateChatWithParticipantsInput instance,
) => <String, dynamic>{
  'name': instance.name,
  'participant_ids': instance.participantIds,
};
