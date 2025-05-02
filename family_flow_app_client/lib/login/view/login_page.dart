// ignore_for_file: use_build_context_synchronously

import 'package:authentication_repository/authentication_repository.dart';
import 'package:family_flow_app_client/notifications/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notification_repository/notification_repository.dart';

import '../bloc/login_bloc.dart';
import 'login_form.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final notificationRepository = context.read<NotificationRepository>();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create:
              (context) => LoginBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
              ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 52),
                const Text(
                  'Вход',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                LoginForm(
                  onLoginSuccess: () async {
                    print('Вход выполнен успешно');
                  },
                ),
                const SizedBox(height: 16),
                const LoginActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
