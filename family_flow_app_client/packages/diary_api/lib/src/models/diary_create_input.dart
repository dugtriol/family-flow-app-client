import 'package:json_annotation/json_annotation.dart';

part 'diary_create_input.g.dart';

@JsonSerializable()
class DiaryCreateInput {
  final String title;
  final String description;
  final String emoji;

  DiaryCreateInput({
    required this.title,
    required this.description,
    required this.emoji,
  });

  factory DiaryCreateInput.fromJson(Map<String, dynamic> json) =>
      _$DiaryCreateInputFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryCreateInputToJson(this);
}
