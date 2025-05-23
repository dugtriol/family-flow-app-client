import 'package:authentication_repository/authentication_repository.dart'
    show AuthenticationRepository;
import 'package:family_flow_app_client/family/family.dart';
import 'package:family_flow_app_client/profile/bloc/profile_bloc.dart';
import 'package:family_repository/family_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../authentication/authentication.dart';
import '../../diary/diary.dart';
import '../../notifications/notifications.dart';
import 'profile_details_page.dart';
import 'widgets/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static var _isProfileLoaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Отправляем событие только один раз
    // if (!_isProfileLoaded) {
    //   context.read<ProfileBloc>().add(ProfileRequested());
    //   _isProfileLoaded = true;
    // }
    context.read<ProfileBloc>().add(ProfileRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.person, color: Colors.deepPurple, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Профиль',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Устанавливаем цвет фона как у AppBar
      body: RefreshIndicator(
        onRefresh: () async {
          // Отправляем событие для обновления профиля
          context.read<ProfileBloc>().add(ProfileRequested());
          context.read<FamilyBloc>().add(FamilyRequested());
          await Future.delayed(
            const Duration(seconds: 1),
          ); // Для имитации загрузки
        },
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationProfileUpdated) {
              // Обновляем данные профиля, но не переходим на другой экран
              context.read<ProfileBloc>().add(ProfileRequested());
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoadSuccess) {
                final user = state.user;
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Аватар и информация о пользователе
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
                                      value: context.read<ProfileBloc>(),
                                      child: const ProfileDetailsPage(),
                                    ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              // const ProfileAvatar(),
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.deepPurple,
                                backgroundImage:
                                    user.avatar != null &&
                                            user.avatar!.isNotEmpty
                                        ? NetworkImage(
                                          user.avatar!,
                                        ) // Загружаем фото, если оно есть
                                        : null,
                                child:
                                    user.avatar == null || user.avatar!.isEmpty
                                        ? Text(
                                          user.name.isNotEmpty
                                              ? user.name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        )
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Вкладки для перехода
                        // ProfileOption(
                        //   icon: Icons.notifications,
                        //   label: 'Уведомления',
                        //   onTap: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder:
                        //             (_) => const NotificationsSettingsPage(),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // const Divider(),
                        ProfileOption(
                          icon: Icons.group,
                          label: 'Семья',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
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
                            // Отправляем событие DiaryRequested
                            context.read<DiaryBloc>().add(DiaryRequested());

                            // Переходим на страницу дневника
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
                                      value: context.read<DiaryBloc>(),
                                      child: const DiaryPage(),
                                    ),
                              ),
                            );
                          },
                        ),
                        const Divider(),
                        // ProfileOption(
                        //   icon: Icons.password,
                        //   label: 'Сбросить пароль',
                        //   onTap: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder:
                        //             (_) => const PlaceholderScreen(
                        //               title: 'Сбросить пароль',
                        //             ),
                        //       ),
                        //     );
                        //   },
                        // ),
                        ProfileOption(
                          icon: Icons.password,
                          label: 'Сбросить пароль',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => ResetPasswordPage(
                                      authenticationRepository:
                                          context
                                              .read<AuthenticationRepository>(),
                                      email: user.email,
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
                            context.read<ProfileBloc>().add(
                              ProfileLogoutRequested(),
                            );
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
      child: Icon(Icons.person, size: 40, color: Colors.white),
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
        color: isDestructive ? Colors.red : Colors.deepPurple,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Colors.black87,
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
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Экран "$title" в разработке',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
