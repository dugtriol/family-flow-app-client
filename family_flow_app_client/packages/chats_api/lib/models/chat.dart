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

  Chat({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.participants,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
