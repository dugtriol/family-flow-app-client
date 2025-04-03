import 'package:family_flow_app_client/family/family.dart';
import 'package:family_flow_app_client/profile/bloc/profile_bloc.dart';
import 'package:family_repository/family_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/authentication.dart';

import 'package:family_flow_app_client/family/bloc/family_bloc.dart';
import 'package:family_repository/family_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = context.read<AuthenticationBloc>();
    final familyRepository = context.read<FamilyRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileBloc(
              authenticationBloc: authenticationBloc,
              familyRepository: familyRepository)
            ..add(ProfileRequested()),
        ),
        // BlocProvider(
        //   create: (_) => FamilyBloc(familyRepository: familyRepository)
        //     ..add(FamilyRequested()),
        // ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профиль'),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadSuccess) {
              final user = state.user;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Аватар и информация о пользователе
                      Row(
                        children: [
                          const ProfileAvatar(),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.familyId.isNotEmpty
                                    ? 'Семья: ${state.familyName ?? 'Загрузка...'}'
                                    : 'Семья: отсутствует',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Вкладки для перехода
                      ProfileOption(
                        icon: Icons.group,
                        label: 'Семья',
                        onTap: () {
                          // Переход на экран семьи с передачей FamilyBloc
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<FamilyBloc>(),
                                child: const FamilyPage(),
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      ProfileOption(
                        icon: Icons.book,
                        label: 'Дневник',
                        onTap: () {
                          // Переход на экран дневника (заглушка)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const PlaceholderScreen(
                                title: 'Дневник',
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(),

                      // Кнопка "Выйти"
                      ProfileOption(
                        icon: Icons.logout,
                        label: 'Выйти',
                        onTap: () {
                          context
                              .read<ProfileBloc>()
                              .add(ProfileLogoutRequested());
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileLoadFailure) {
              return Center(
                child: Text(
                  'Не удалось загрузить профиль: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 40,
      backgroundColor: Colors.blueAccent,
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  const ProfileOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Theme.of(context).iconTheme.color,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Экран "$title" в разработке',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
