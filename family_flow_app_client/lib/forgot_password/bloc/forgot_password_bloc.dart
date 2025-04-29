import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart'
    show AuthenticationRepository;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(ForgotPasswordInitial()) {
    on<ForgotPasswordEmailSubmitted>(_onEmailSubmitted);
    on<ForgotPasswordPasswordSubmitted>(_onPasswordSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onEmailSubmitted(
    ForgotPasswordEmailSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      final emailExists = await _authenticationRepository.checkUserExists(
        event.email,
      );
      if (emailExists) {
        emit(ForgotPasswordEmailVerified(event.email));
      } else {
        emit(ForgotPasswordFailure('Email не найден'));
      }
    } catch (error) {
      emit(ForgotPasswordFailure('Ошибка проверки email: $error'));
    }
  }

  Future<void> _onPasswordSubmitted(
    ForgotPasswordPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    try {
      await _authenticationRepository.updatePassword(
        event.email,
        event.password,
      );
      emit(ForgotPasswordSuccess());
    } catch (error) {
      emit(ForgotPasswordFailure('Ошибка обновления пароля: $error'));
    }
  }
}
