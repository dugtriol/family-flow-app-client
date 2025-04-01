import 'package:json_annotation/json_annotation.dart';

part 'input_create.g.dart';

@JsonSerializable()
class WishlistCreateInput {
  final String name;
  final String description;
  final String link;

  WishlistCreateInput({
    required this.name,
    required this.description,
    required this.link,
  });

  factory WishlistCreateInput.fromJson(Map<String, dynamic> json) =>
      _$WishlistCreateInputFromJson(json);

  Map<String, dynamic> toJson() => _$WishlistCreateInputToJson(this);
}
