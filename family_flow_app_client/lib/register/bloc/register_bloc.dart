import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_flow_app_client/app/view/notification_service.dart'
    show NotificationService;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:form_inputs/form_inputs.dart';

import '../../authentication/authentication.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required AuthenticationRepository authenticationRepository})
    : _authenticationRepository = authenticationRepository,
      super(const RegisterState()) {
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterSendCode>(_onSendCode);
    on<RegisterVerifyCode>(_onVerifyCode);
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterRoleChanged>(_onRoleChanged);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onNameChanged(RegisterNameChanged event, Emitter<RegisterState> emit) {
    final name = Name.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        isValid: Formz.validate([name, state.email, state.password]),
      ),
    );
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.name, email, state.password]),
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.name, state.email, password]),
      ),
    );
  }

  Future<void> _onSendCode(
    RegisterSendCode event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.sendVerificationCode(state.email.value);
      emit(
        state.copyWith(status: FormzSubmissionStatus.success, isCodeSent: true),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> _onVerifyCode(
    RegisterVerifyCode event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      final isValid = await _authenticationRepository.verifyCode(
        state.email.value,
        event.code,
      );
      if (isValid) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            isCodeVerified: true,
          ),
        );
      } else {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (state.isCodeVerified) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.register(
          name: state.name.value,
          email: state.email.value,
          password: state.password.value,
          role: state.isParent ? 'Parent' : 'Child',
        );

        // После успешного входа или регистрации
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.success,
            isRegistered: true,
          ),
        );
        event.context.read<AuthenticationBloc>().add(
          AuthenticationUserRefreshed(),
        );
        await NotificationService().showNotification(
          id: 1,
          title: 'Family Flow',
          body: 'Добро пожаловать в Family Flow!',
        );
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  void _onRoleChanged(RegisterRoleChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(isParent: event.isParent));
  }
}
