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
    this.latitude,
    this.longitude,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  @JsonKey(name: 'family_id') // Указываем имя ключа в JSON
  final String familyId;
  final double? latitude;
  final double? longitude;

  @override
  List<Object> get props => [
    id,
    name,
    email,
    role,
    familyId,
    latitude ?? 0,
    longitude ?? 0,
  ];

  /// Пустой пользователь
  static const empty = User(
    id: '-',
    name: '',
    email: '',
    role: '',
    familyId: '',
    latitude: null,
    longitude: null,
  );

  /// Фабрика для создания объекта из JSON
  // factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      familyId: json['family_id']['String'] as String,
      latitude:
          (json['latitude']['Valid'] as bool)
              ? json['latitude']['Float64'] as double
              : null,
      longitude:
          (json['longitude']['Valid'] as bool)
              ? json['longitude']['Float64'] as double
              : null,
    );
  }

  /// Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
