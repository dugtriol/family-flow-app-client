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

  const AuthenticationProfileUpdateRequested({
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, role];
}
