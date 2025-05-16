import 'package:json_annotation/json_annotation.dart';

part 'diary_item.g.dart';

@JsonSerializable()
class DiaryItem {
  final String id;
  final String title;
  final String description;
  final String emoji;
  @JsonKey(name: 'created_by')
  final String createdBy;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  DiaryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DiaryItem.fromJson(Map<String, dynamic> json) =>
      _$DiaryItemFromJson(json);

  Map<String, dynamic> toJson() => _$DiaryItemToJson(this);
}
