// ignore_for_file: use_build_context_synchronously

import 'package:family_flow_app_client/notifications/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formz/formz.dart';
import 'package:notification_repository/notification_repository.dart';

import '../bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback? onLoginSuccess;
  LoginForm({super.key, this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmailInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(onLoginSuccess: onLoginSuccess),
          ],
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginBloc bloc) => bloc.state.email.displayError,
    );

    return TextField(
      key: const Key('loginForm_emailInput_textField'),
      onChanged: (email) {
        context.read<LoginBloc>().add(LoginEmailChanged(email));
      },
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: displayError != null ? 'invalid email' : null,
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginBloc bloc) => bloc.state.password.displayError,
    );

    return TextField(
      key: const Key('loginForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<LoginBloc>().add(LoginPasswordChanged(password));
      },
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Пароль',
        errorText: displayError != null ? 'invalid password' : null,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final VoidCallback? onLoginSuccess;

  const _LoginButton({this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
      (LoginBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );

    if (isInProgressOrSuccess) return const CircularProgressIndicator();

    final isValid = context.select((LoginBloc bloc) => bloc.state.isValid);

    return ElevatedButton(
      key: const Key('loginForm_continue_raisedButton'),
      onPressed:
          isValid
              ? () async {
                // Выполняем вход
                context.read<LoginBloc>().add(LoginSubmitted());

                // Подписываемся на изменения состояния
                context.read<LoginBloc>().stream.listen((state) async {
                  if (state.status.isSuccess) {
                    // Вход выполнен успешно
                    onLoginSuccess?.call();

                    // Получаем FCM токен
                    final fcmToken =
                        await FirebaseMessaging.instance.getToken();
                    if (fcmToken != null) {
                      // Отправляем события в NotificationsBloc
                      context.read<NotificationsBloc>().add(
                        SaveFcmToken(fcmToken),
                      );
                      context.read<NotificationsBloc>().add(
                        SendLoginNotification(),
                      );
                    }
                  }
                });
              }
              : null,
      child: const Text('Войти'),
    );
  }
}
