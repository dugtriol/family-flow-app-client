import 'package:json_annotation/json_annotation.dart';

part 'add_participant_input.g.dart';

@JsonSerializable()
class AddParticipantInput {
  @JsonKey(name: 'chat_id')
  final String chatId;

  @JsonKey(name: 'user_id')
  final String userId;

  AddParticipantInput({required this.chatId, required this.userId});

  factory AddParticipantInput.fromJson(Map<String, dynamic> json) =>
      _$AddParticipantInputFromJson(json);

  Map<String, dynamic> toJson() => _$AddParticipantInputToJson(this);
}
