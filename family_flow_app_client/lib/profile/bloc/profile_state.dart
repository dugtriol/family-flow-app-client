part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние профиля
class ProfileInitial extends ProfileState {}

/// Состояние, когда данные профиля успешно загружены
class ProfileLoadSuccess extends ProfileState {
  const ProfileLoadSuccess({
    required this.user,
    this.familyName,
  });

  final User user;
  final String? familyName;

  @override
  List<Object?> get props => [user, familyName];
}

/// Состояние, когда произошла ошибка при загрузке профиля
class ProfileLoadFailure extends ProfileState {
  const ProfileLoadFailure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
