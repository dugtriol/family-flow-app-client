// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
  id: json['id'] as String,
  chatId: json['chat_id'] as String,
  senderId: json['sender_id'] as String,
  content: json['content'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
  'id': instance.id,
  'chat_id': instance.chatId,
  'sender_id': instance.senderId,
  'content': instance.content,
  'created_at': instance.createdAt?.toIso8601String(),
};
