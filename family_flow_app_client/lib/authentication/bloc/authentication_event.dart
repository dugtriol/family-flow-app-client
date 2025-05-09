part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationSubscriptionRequested extends AuthenticationEvent {}

final class AuthenticationLogoutPressed extends AuthenticationEvent {}

final class AuthenticationUserRefreshed
    extends AuthenticationEvent {} // Новое событие

final class AuthenticationProfileUpdateRequested extends AuthenticationEvent {
  final String name;
  final String email;
  final String role;
  final String gender;
  final String birthDate;
  final File? avatar;

  const AuthenticationProfileUpdateRequested({
    required this.name,
    required this.email,
    required this.role,
    required this.gender,
    required this.birthDate,
    this.avatar,
  });

  @override
  List<Object?> get props => [name, email, role, gender, birthDate, avatar];
}

final class AuthenticationLocationUpdateRequested extends AuthenticationEvent {
  final double latitude;
  final double longitude;

  const AuthenticationLocationUpdateRequested({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}
