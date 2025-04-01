import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_repository/todo_repository.dart';
import 'package:shopping_repository/shopping_repository.dart'; // Импортируем ShoppingRepository
import 'package:user_repository/user_repository.dart';
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
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        _todoRepository = todoRepository,
        _shoppingRepository =
            shoppingRepository, // Инициализируем ShoppingRepository
        super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
    on<AuthenticationUserRefreshed>(_onUserRefreshed);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final TodoRepository _todoRepository;
  final ShoppingRepository _shoppingRepository; // Поле для ShoppingRepository

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.status,
      onData: (status) async {
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            _todoRepository.updateFamilyId(null);
            _shoppingRepository.updateFamilyId(
                null); // Сбрасываем familyId в ShoppingRepository
            return emit(const AuthenticationState.unauthenticated());
          case AuthenticationStatus.authenticated:
            final user = await _tryGetUser();
            _todoRepository.updateFamilyId(user?.familyId);
            _shoppingRepository.updateFamilyId(
                user?.familyId); // Обновляем familyId в ShoppingRepository
            return emit(
              user != null
                  ? AuthenticationState.authenticated(user)
                  : const AuthenticationState.unauthenticated(),
            );
          case AuthenticationStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
    _todoRepository.updateFamilyId(null);
    _shoppingRepository
        .updateFamilyId(null); // Сбрасываем familyId в ShoppingRepository
  }

  Future<void> _onUserRefreshed(
    AuthenticationUserRefreshed event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      final user = await _userRepository.getUser();
      _todoRepository.updateFamilyId(user?.familyId);
      _shoppingRepository.updateFamilyId(
          user?.familyId); // Обновляем familyId в ShoppingRepository
      if (user != null) {
        emit(AuthenticationState.authenticated(user));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
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
}
