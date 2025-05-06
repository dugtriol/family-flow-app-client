import 'package:json_annotation/json_annotation.dart';

part 'chat_participant.g.dart';

@JsonSerializable()
class ChatParticipant {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'chat_id')
  final String chatId;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'joined_at')
  final DateTime joinedAt;

  ChatParticipant({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.joinedAt,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ChatParticipantToJson(this);
}
