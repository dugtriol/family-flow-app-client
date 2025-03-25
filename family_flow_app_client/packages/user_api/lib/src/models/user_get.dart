import 'package:json_annotation/json_annotation.dart';

part 'user_get.g.dart';

@JsonSerializable()
class UserGet {
  const UserGet({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.familyId,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  @JsonKey(name: 'family_id')
  final String familyId;

  factory UserGet.fromJson(Map<String, dynamic> json) =>
      _$UserGetFromJson(json);

  Map<String, dynamic> toJson() => _$UserGetToJson(this);
}
