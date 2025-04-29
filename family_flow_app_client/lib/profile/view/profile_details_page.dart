import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:family_flow_app_client/profile/bloc/profile_bloc.dart';
import 'package:user_repository/user_repository.dart' show User;

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late String initialName;
  late String initialEmail;

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileLoadSuccess) {
      nameController = TextEditingController(text: profileState.user.name);
      emailController = TextEditingController(text: profileState.user.email);
      initialName = profileState.user.name;
      initialEmail = profileState.user.email;
    } else {
      nameController = TextEditingController();
      emailController = TextEditingController();
      initialName = '';
      initialEmail = '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfileIfChanged() async {
    final currentName = nameController.text;
    final currentEmail = emailController.text;

    if (currentName != initialName || currentEmail != initialEmail) {
      context.read<ProfileBloc>().add(
        ProfileUpdateRequested(name: currentName, email: currentEmail),
      );

      // Обновляем начальное значение
      initialName = currentName;
      initialEmail = currentEmail;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = context.read<ProfileBloc>().state;

    if (profileState is! ProfileLoadSuccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Данные пользователя')),
        body: const Center(
          child: Text('Не удалось загрузить данные пользователя.'),
        ),
      );
    }

    final user = profileState.user;

    return WillPopScope(
      onWillPop: () async {
        await _updateProfileIfChanged();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Профиль',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () async {
              await _updateProfileIfChanged();
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileBloc>().add(ProfileRequested());
            await Future.delayed(
              const Duration(seconds: 1),
            ); // Для имитации загрузки
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Поле для имени
                        Row(
                          children: [
                            const Icon(Icons.person, color: Colors.deepPurple),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: nameController,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Имя',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // Поле для email
                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.deepPurple),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: emailController,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                ),
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // Поле для роли
                        Row(
                          children: [
                            const Icon(Icons.work, color: Colors.deepPurple),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                  text: user.role,
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Роль',
                                ),
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),

                        // Кнопка сохранения изменений
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await _updateProfileIfChanged();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Изменения сохранены!'),
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text(
                              'Сохранить',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
