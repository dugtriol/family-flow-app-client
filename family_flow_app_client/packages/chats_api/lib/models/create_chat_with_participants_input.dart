import 'package:json_annotation/json_annotation.dart';

part 'create_chat_with_participants_input.g.dart';

@JsonSerializable()
class CreateChatWithParticipantsInput {
  final String name;

  @JsonKey(name: 'participant_ids')
  final List<String> participantIds;

  CreateChatWithParticipantsInput({
    required this.name,
    required this.participantIds,
  });

  factory CreateChatWithParticipantsInput.fromJson(Map<String, dynamic> json) =>
      _$CreateChatWithParticipantsInputFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateChatWithParticipantsInputToJson(this);
}
