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
  const ProfileUpdateRequested({required this.name, required this.email});

  final String name;
  final String email;

  @override
  List<Object?> get props => [name, email];
}
