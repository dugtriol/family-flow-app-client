import 'package:json_annotation/json_annotation.dart';

part 'diary_update_input.g.dart';

@JsonSerializable()
class DiaryUpdateInput {
  final String title;
  final String description;
  final String emoji;

  DiaryUpdateInput({
    required this.title,
    required this.description,
    required this.emoji,
  });

  factory DiaryUpdateInput.fromJson(Map<String, dynamic> json) =>
      _$DiaryUpdateInputFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryUpdateInputToJson(this);
}
