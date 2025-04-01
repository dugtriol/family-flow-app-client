import 'package:json_annotation/json_annotation.dart';

part 'input_create.g.dart';

@JsonSerializable()
class FamilyCreateInput {
  final String name;

  FamilyCreateInput({
    required this.name,
  });

  factory FamilyCreateInput.fromJson(Map<String, dynamic> json) =>
      _$FamilyCreateInputFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyCreateInputToJson(this);
}
