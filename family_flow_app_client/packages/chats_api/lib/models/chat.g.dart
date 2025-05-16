// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
  id: json['id'] as String,
  name: json['name'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  participants:
      (json['participants'] as List<dynamic>)
          .map((e) => ChatParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
  lastMessage:
      json['last_message'] == null
          ? null
          : Message.fromJson(json['last_message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'created_at': instance.createdAt.toIso8601String(),
  'participants': instance.participants,
  'last_message': instance.lastMessage,
};
