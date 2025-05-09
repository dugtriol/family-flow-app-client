import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.familyId,
    this.latitude,
    this.longitude,
    required this.gender,
    required this.point,
    this.birthDate,
    this.avatar,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  @JsonKey(name: 'family_id') // Указываем имя ключа в JSON
  final String? familyId;
  final double? latitude;
  final double? longitude;
  final String gender;
  final int point;
  @JsonKey(name: 'birth_date') // Указываем имя ключа в JSON
  final DateTime? birthDate;
  final String? avatar;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    password,
    role,
    familyId,
    latitude,
    longitude,
    gender,
    point,
    birthDate,
    avatar,
  ];

  /// Пустой пользователь
  static const empty = User(
    id: '-',
    name: '',
    email: '',
    password: '',
    role: '',
    familyId: null,
    latitude: null,
    longitude: null,
    gender: '',
    point: 0,
    birthDate: null,
    avatar: null,
  );

  /// Фабрика для создания объекта из JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      familyId:
          json['family_id']['Valid'] as bool
              ? json['family_id']['String'] as String
              : null,
      latitude:
          json['latitude']['Valid'] as bool
              ? json['latitude']['Float64'] as double
              : null,
      longitude:
          json['longitude']['Valid'] as bool
              ? json['longitude']['Float64'] as double
              : null,
      gender: json['gender'] as String,
      point: json['point'] as int,
      birthDate:
          json['birth_date']['Valid'] as bool
              ? DateTime.parse(json['birth_date']['Time'] as String)
              : null,
      avatar:
          json['avatar']['Valid'] as bool
              ? json['avatar']['String'] as String
              : null,
    );
  }

  /// Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
