import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'input_respond_to_invite.g.dart'; // Указываем файл для сгенерированного кода

@JsonSerializable()
class RespondToInviteInput extends Equatable {
  @JsonKey(name: 'family_id')
  final String familyId;
  final String role;
  final String response;

  const RespondToInviteInput({
    required this.familyId,
    required this.role,
    required this.response,
  });

  /// Фабричный метод для создания объекта из JSON
  factory RespondToInviteInput.fromJson(Map<String, dynamic> json) =>
      _$RespondToInviteInputFromJson(json);

  /// Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => _$RespondToInviteInputToJson(this);

  @override
  List<Object?> get props => [familyId, role, response];
}
