import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  const ForgotPasswordPage({super.key, required this.authenticationRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => ForgotPasswordBloc(
            authenticationRepository: authenticationRepository,
          ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Восстановление пароля')),
        body: const ForgotPasswordForm(),
      ),
    );
  }
}

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Пароль успешно изменён')),
          );
          // Navigator.of(context).pushReplacementNamed('/login');
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          if (state is ForgotPasswordInitial) {
            return _EmailInput();
          } else if (state is ForgotPasswordEmailVerified) {
            return _PasswordInput(email: state.email);
          } else if (state is ForgotPasswordLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Введите ваш email', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ForgotPasswordBloc>().add(
                ForgotPasswordEmailSubmitted(_emailController.text),
              );
            },
            child: const Text('Далее'),
          ),
        ],
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final String email; // Добавляем email

  _PasswordInput({required this.email}); // Конструктор принимает email

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Введите новый пароль', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Новый пароль',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Подтвердите пароль',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_passwordController.text == _confirmPasswordController.text) {
                context.read<ForgotPasswordBloc>().add(
                  ForgotPasswordPasswordSubmitted(
                    email, // Передаем email
                    _passwordController.text,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Пароли не совпадают')),
                );
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
