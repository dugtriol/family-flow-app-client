import 'package:chats_api/models/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'chat_participant.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'participants')
  final List<ChatParticipant> participants;
  @JsonKey(name: 'last_message')
  final Message? lastMessage;

  Chat({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.participants,
    this.lastMessage,
  });

  Chat copyWith({
    String? id,
    String? name,
    List<ChatParticipant>? participants,
    Message? lastMessage,
    bool? hasNewMessages,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: this.createdAt,
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
