import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
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
  @JsonKey(name: 'family_id') // Указываем имя ключа в JSON
  final String familyId;

  @override
  List<Object> get props => [id, name, email, role, familyId];

  /// Пустой пользователь
  static const empty = User(
    id: '-',
    name: '',
    email: '',
    role: '',
    familyId: '',
  );

  /// Фабрика для создания объекта из JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
