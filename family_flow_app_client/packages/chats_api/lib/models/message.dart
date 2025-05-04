import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'chat_id')
  final String chatId;

  @JsonKey(name: 'sender_id')
  final String senderId;

  final String? content;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.content,
    this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
