part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationSubscriptionRequested extends AuthenticationEvent {}

final class AuthenticationLogoutPressed extends AuthenticationEvent {}

class AuthenticationUserRefreshed extends AuthenticationEvent {
  final bool isProfileUpdate;

  const AuthenticationUserRefreshed({this.isProfileUpdate = false});

  @override
  List<Object?> get props => [isProfileUpdate];
}

final class AuthenticationProfileUpdateRequested extends AuthenticationEvent {
  final String name;
  final String email;
  final String role;
  final String gender;
  final String birthDate;
  final File? avatar;
  final String avatarUrl;

  const AuthenticationProfileUpdateRequested({
    required this.name,
    required this.email,
    required this.role,
    required this.gender,
    required this.birthDate,
    this.avatar,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    role,
    gender,
    birthDate,
    avatar,
    avatarUrl,
  ];
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
