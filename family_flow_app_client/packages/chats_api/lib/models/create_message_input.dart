import 'package:json_annotation/json_annotation.dart';

part 'create_message_input.g.dart';

@JsonSerializable()
class CreateMessageInput {
  @JsonKey(name: 'chat_id')
  final String chatId;

  @JsonKey(name: 'sender_id')
  final String senderId;

  final String content;

  CreateMessageInput({
    required this.chatId,
    required this.senderId,
    required this.content,
  });

  factory CreateMessageInput.fromJson(Map<String, dynamic> json) =>
      _$CreateMessageInputFromJson(json);

  Map<String, dynamic> toJson() => _$CreateMessageInputToJson(this);
}
