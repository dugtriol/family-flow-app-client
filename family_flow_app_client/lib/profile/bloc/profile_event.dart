part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для запроса данных профиля
class ProfileRequested extends ProfileEvent {}
