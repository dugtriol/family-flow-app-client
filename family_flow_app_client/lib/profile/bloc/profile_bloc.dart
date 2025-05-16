import 'dart:io' show File;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_flow_app_client/authentication/bloc/authentication_bloc.dart';
import 'package:family_flow_app_client/family/family.dart';
import 'package:user_api/user_api.dart' show User;

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required AuthenticationBloc authenticationBloc,
    required FamilyBloc familyBloc,
  }) : _authenticationBloc = authenticationBloc,
       _familyBloc = familyBloc,
       super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
    on<ProfileLogoutRequested>(_onLogoutRequested);
    on<ProfileReset>(_onReset);
    on<ProfileUpdateRequested>(_onProfileUpdateRequested);
  }

  final AuthenticationBloc _authenticationBloc;
  final FamilyBloc _familyBloc;
  bool _isProfileLoading = false;

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    _authenticationBloc.add(AuthenticationUserRefreshed());
    if (_isProfileLoading) return; // Если профиль уже загружается, выходим
    _isProfileLoading = true;

    print('ProfileRequested event received');
    final user = _authenticationBloc.state.user;

    if (user != null) {
      print('User found: ${user.id}');
      try {
        String? familyName;

        if (user.familyId != null && user.familyId!.isNotEmpty) {
          print('Fetching family data for familyId: ${user.familyId}');
          final familyState = _familyBloc.state;

          // Проверяем, загружены ли данные семьи
          if (familyState is FamilyLoadSuccess) {
            final family = familyState.members.firstWhere(
              (member) => member.id == user.familyId,
              orElse: () => User.empty,
            );
            familyName = family.name;
            print('Family data fetched successfully: $familyName');
          } else {
            // Если данные семьи не загружены, отправляем событие для загрузки
            _familyBloc.add(FamilyRequested());
            print('Family data not loaded yet, requesting family data...');
          }
        } else {
          print('User has no familyId');
        }

        emit(ProfileLoadSuccess(user: user, familyName: familyName));
        print('ProfileLoadSuccess emitted');
      } catch (e) {
        print('Error fetching family data: $e');
        emit(const ProfileLoadFailure(error: 'Failed to load family data.'));
      }
    } else {
      print('User not found in authentication state');
      emit(const ProfileLoadFailure(error: 'User not found.'));
    }

    _isProfileLoading = false; // Сбрасываем флаг после завершения загрузки
  }

  void _onLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) {
    _authenticationBloc.add(AuthenticationLogoutPressed());
  }

  void _onReset(ProfileReset event, Emitter<ProfileState> emit) {
    emit(ProfileInitial());
  }

  void _onProfileUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) {
    _authenticationBloc.add(AuthenticationUserRefreshed());
    print('ProfileUpdateRequested event received');
    print('Updating profile with name: ${event.name}, email: ${event.email}');

    final avatarFile = event.avatar.isNotEmpty ? File(event.avatar) : null;
    final avatarUrl = event.avatar.isNotEmpty ? 'empty' : event.avatarUrl;
    final formattedBirthDate =
        event.birthDate.isNotEmpty
            ? DateTime.parse(event.birthDate).toIso8601String().split('T').first
            : null;
    // Отправляем событие в AuthenticationBloc
    print(
      'Dispatching AuthenticationProfileUpdateRequested with the following fields:',
    );
    print('Name: ${event.name}');
    print('Email: ${event.email}');
    print('Role: ${event.role}');
    print('Gender: ${event.gender}');
    print('BirthDate: ${event.birthDate}');
    print(
      'Avatar: ${event.avatar.isNotEmpty ? event.avatar : 'No avatar provided'}',
    );
    print('AvatarUrl: $avatarUrl');
    _authenticationBloc.add(
      AuthenticationProfileUpdateRequested(
        name: event.name,
        email: event.email,
        role: event.role,
        gender: event.gender,
        birthDate: event.birthDate,
        avatar: avatarFile,
        avatarUrl: avatarUrl,
      ),
    );

    print('AuthenticationProfileUpdateRequested event dispatched');
  }
}
