import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/profile/bloc/profile_bloc.dart';
import 'package:user_repository/user_repository.dart' show User;

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<ProfileBloc>().state;
    final familyState = context.read<FamilyBloc>().state;

    if (profileState is! ProfileLoadSuccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Данные пользователя')),
        body: const Center(
          child: Text('Не удалось загрузить данные пользователя.'),
        ),
      );
    }

    final user = profileState.user;
    final familyName =
        (familyState is FamilyLoadSuccess)
            ? familyState.members
                .firstWhere(
                  (member) => member.id == user.familyId,
                  orElse: () => User.empty,
                )
                ?.name
            : 'Отсутствует';

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль пользователя')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Аватар пользователя
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blueAccent,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Имя пользователя
              TextFormField(
                initialValue: user.name,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              // Email пользователя (только для чтения)
              TextFormField(
                initialValue: user.email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Имя семьи и кнопка для копирования ID семьи
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: familyName,
                      decoration: const InputDecoration(
                        labelText: 'Семья',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.group),
                      ),
                      readOnly: true, // Поле только для чтения
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: user.familyId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('ID семьи скопирован в буфер обмена'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Роль пользователя (только для чтения)
              TextFormField(
                initialValue: user.role,
                decoration: const InputDecoration(
                  labelText: 'Роль',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 32),

              // Кнопка сохранения изменений
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Логика сохранения изменений
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Изменения сохранены!')),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Сохранить изменения'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
