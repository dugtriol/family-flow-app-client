import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../forgot_password/forgot_password.dart';
import '../../register/view/registration_page.dart';

class LoginActions extends StatelessWidget {
  const LoginActions({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationRepository = context.read<AuthenticationRepository>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const RegistrationPage()));
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: const Text('Зарегистрироваться'),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
            // );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (_) => ForgotPasswordPage(
                      authenticationRepository: authenticationRepository,
                    ),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: const Text('Забыли пароль?'),
        ),
      ],
    );
  }
}
