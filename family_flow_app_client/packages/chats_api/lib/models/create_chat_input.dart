import 'package:json_annotation/json_annotation.dart';

part 'create_chat_input.g.dart';

@JsonSerializable()
class CreateChatInput {
  final String name;

  CreateChatInput({required this.name});

  factory CreateChatInput.fromJson(Map<String, dynamic> json) =>
      _$CreateChatInputFromJson(json);

  Map<String, dynamic> toJson() => _$CreateChatInputToJson(this);
}
