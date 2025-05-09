import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'family.g.dart';

@JsonSerializable()
class Family extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final String? photo; // Поле для ссылки на изображение

  Family({
    required this.id,
    required this.name,
    required this.createdAt,
    this.photo,
  });

  /// Обновлённая фабрика для обработки `photo` как `sql.NullString`
  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      photo:
          json['photo']['Valid']
                  as bool // Обработка поля photo
              ? json['photo']['String'] as String
              : null,
    );
  }

  Map<String, dynamic> toJson() => _$FamilyToJson(this);

  @override
  List<Object?> get props => [id, name, createdAt, photo];
}
