// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_message_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateMessageInput _$CreateMessageInputFromJson(Map<String, dynamic> json) =>
    CreateMessageInput(
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$CreateMessageInputToJson(CreateMessageInput instance) =>
    <String, dynamic>{
      'chat_id': instance.chatId,
      'sender_id': instance.senderId,
      'content': instance.content,
    };
