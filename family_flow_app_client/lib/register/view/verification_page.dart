import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../bloc/register_bloc.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _codeController = TextEditingController();

  void _submitCode() {
    final code = _codeController.text;
    if (code.length == 4) {
      context.read<RegisterBloc>().add(RegisterVerifyCode(code));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите 4-значный код')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isCodeVerified &&
            state.status == FormzSubmissionStatus.success &&
            !state.isRegistered) {
          // Если код подтвержден, отправляем событие для регистрации
          context.read<RegisterBloc>().add(RegisterSubmitted(context: context));
        } else if (state.isRegistered) {
          // Если регистрация успешна, перенаправляем на главный экран
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Успешная регистрация')),
            );
        } else {
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     const SnackBar(content: Text('Ошибка регистрации')),
          //   );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Подтверждение'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Введите код подтверждения',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Код',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitCode,
                child: const Text('Отправить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
