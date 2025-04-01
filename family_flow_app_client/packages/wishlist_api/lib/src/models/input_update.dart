import 'package:json_annotation/json_annotation.dart';

part 'input_update.g.dart';

@JsonSerializable()
class WishlistUpdateInput {
  final String name;
  final String description;
  final String link;
  final String status;
  @JsonKey(name: 'is_reserved')
  final bool isReserved;

  WishlistUpdateInput({
    required this.name,
    required this.description,
    required this.link,
    required this.status,
    required this.isReserved,
  });

  factory WishlistUpdateInput.fromJson(Map<String, dynamic> json) =>
      _$WishlistUpdateInputFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistUpdateInputToJson(this);
}
