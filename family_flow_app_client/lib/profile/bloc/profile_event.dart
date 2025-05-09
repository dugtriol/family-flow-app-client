part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для запроса профиля
class ProfileRequested extends ProfileEvent {}

/// Событие для выхода из аккаунта
class ProfileLogoutRequested extends ProfileEvent {}

/// Событие для сброса состояния профиля
class ProfileReset extends ProfileEvent {}

/// Событие для обновления профиля
class ProfileUpdateRequested extends ProfileEvent {
  const ProfileUpdateRequested({
    required this.name,
    required this.email,
    required this.role,
    required this.gender,
    required this.birthDate,
    required this.avatar,
  });

  final String name;
  final String email;
  final String role;
  final String gender;
  final String birthDate;
  final String avatar;

  @override
  List<Object?> get props => [name, email, role, gender, birthDate, avatar];
}
