import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_repository/todo_repository.dart';
import 'package:shopping_repository/shopping_repository.dart'; // Импортируем ShoppingRepository
import 'package:user_repository/user_repository.dart';
import 'package:user_api/user_api.dart';
import 'package:authentication_repository/authentication_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    required TodoRepository todoRepository,
    required ShoppingRepository
    shoppingRepository, // Добавляем ShoppingRepository
  }) : _authenticationRepository = authenticationRepository,
       _userRepository = userRepository,
       _todoRepository = todoRepository,
       _shoppingRepository =
           shoppingRepository, // Инициализируем ShoppingRepository
       super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
    on<AuthenticationUserRefreshed>(_onUserRefreshed);
    on<AuthenticationProfileUpdateRequested>(_onProfileUpdateRequested);
    on<AuthenticationLocationUpdateRequested>(
      _onAuthenticationLocationUpdateRequested,
    );
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final TodoRepository _todoRepository;
  final ShoppingRepository _shoppingRepository; // Поле для ShoppingRepository

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      // Проверяем статус аутентификации
      await emit.onEach(
        _authenticationRepository.status,
        onData: (status) async {
          switch (status) {
            case AuthenticationStatus.unauthenticated:
              _todoRepository.updateFamilyId(null);
              _shoppingRepository.updateFamilyId(null);
              emit(const AuthenticationState.unauthenticated());
              break;
            case AuthenticationStatus.authenticated:
              final user = await _tryGetUser();
              if (user != null) {
                _todoRepository.updateFamilyId(user.familyId);
                _shoppingRepository.updateFamilyId(user.familyId);
                emit(AuthenticationState.authenticated(user));
              } else {
                // Если токен недействителен, переводим в состояние unauthenticated
                emit(const AuthenticationState.unauthenticated());
              }
              break;
            case AuthenticationStatus.unknown:
              emit(const AuthenticationState.unknown());
              break;
          }
        },
        onError: (error, stackTrace) {
          // Если произошла ошибка, переводим в состояние unauthenticated
          emit(const AuthenticationState.unauthenticated());
        },
      );
    } catch (_) {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
    _todoRepository.updateFamilyId(null);
    _shoppingRepository.updateFamilyId(
      null,
    ); // Сбрасываем familyId в ShoppingRepository
  }

  Future<void> _onUserRefreshed(
    AuthenticationUserRefreshed event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = await _userRepository.getUser();
      _todoRepository.updateFamilyId(user?.familyId);
      _shoppingRepository.updateFamilyId(
        user?.familyId,
      ); // Обновляем familyId в ShoppingRepository
      // if (user != null) {
      //   // emit(AuthenticationState.authenticated(user));
      //   emit(AuthenticationState.authenticated(user));
      // } else {
      //   emit(const AuthenticationState.unauthenticated());
      // }
    } catch (_) {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<User?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUser();
      return user;
    } catch (_) {
      return null;
    }
  }

  void _onProfileUpdateRequested(
    AuthenticationProfileUpdateRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = state.user;
      if (user != null) {
        print('Updating profile for user: ${user.id}');
        await _userRepository.updateUser(
          UserUpdateInput(
            name: event.name,
            email: event.email,
            role: event.role,
            gender: event.gender,
            birthDate:
                event.birthDate != null && event.birthDate.isNotEmpty
                    ? DateTime.parse(event.birthDate)
                    : null,
            avatar: event.avatar, // Передаем файл, если он есть
            avatarURL: event.avatarUrl, // Передаем URL, если файл отсутствует
          ),
        );
        print('Profile updated successfully for user: ${user.id}');

        // Обновляем данные пользователя
        final updatedUser = await _tryGetUser();
        if (updatedUser != null) {
          emit(AuthenticationState.authenticated(updatedUser));
          print('User state updated after profile update');
        } else {
          emit(const AuthenticationState.unauthenticated());
        }
      }
    } catch (e) {
      print('Failed to update profile for user: ${state.user?.id}, error: $e');
      emit(const AuthenticationState.unauthenticated());
    }
  }

  void _onAuthenticationLocationUpdateRequested(
    AuthenticationLocationUpdateRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = state.user;
      if (user != null) {
        await _userRepository.updateUserLocation(
          latitude: event.latitude,
          longitude: event.longitude,
        );
        print(
          'Локация пользователя обновлена: ${event.latitude}, ${event.longitude}',
        );
      } else {
        print('Ошибка: пользователь не аутентифицирован');
      }
    } catch (e) {
      print('Ошибка при обновлении локации: $e');
    }
  }
}
