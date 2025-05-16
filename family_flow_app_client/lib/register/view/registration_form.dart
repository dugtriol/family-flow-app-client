import 'package:authentication_repository/authentication_repository.dart';
import 'package:family_flow_app_client/register/view/verification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/register_bloc.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     const SnackBar(content: Text('Ошибка регистрации')),
          //   );
        } else if (state.isCodeSent) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: context.read<RegisterBloc>(),
                    child: const VerificationPage(),
                  ),
            ),
          );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _EmailInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _RoleSwitch(),
            const Padding(padding: EdgeInsets.all(12)),
            _RegisterButton(),
          ],
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('registerForm_nameInput_textField'),
      onChanged: (name) {
        context.read<RegisterBloc>().add(RegisterNameChanged(name));
      },
      decoration: const InputDecoration(labelText: 'Имя'),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('registerForm_emailInput_textField'),
      onChanged: (email) {
        context.read<RegisterBloc>().add(RegisterEmailChanged(email));
      },
      decoration: const InputDecoration(labelText: 'Email'),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('registerForm_passwordInput_textField'),
      onChanged: (password) {
        context.read<RegisterBloc>().add(RegisterPasswordChanged(password));
      },
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Пароль'),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (RegisterBloc bloc) => bloc.state.status.isInProgress,
    );

    if (isInProgress) return const CircularProgressIndicator();

    final isValid = context.select((RegisterBloc bloc) => bloc.state.isValid);

    return ElevatedButton(
      key: const Key('registerForm_continue_raisedButton'),
      onPressed:
          isValid
              ? () => context.read<RegisterBloc>().add(RegisterSendCode())
              : null,
      child: const Text('Зарегистрироваться'),
    );
  }
}

class _RoleSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isParent = context.select((RegisterBloc bloc) => bloc.state.isParent);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: isParent,
          onChanged: (value) {
            context.read<RegisterBloc>().add(RegisterRoleChanged(value));
          },
        ),
        const SizedBox(width: 8),
        const Text('Вы родитель?'),
      ],
    );
  }
}
