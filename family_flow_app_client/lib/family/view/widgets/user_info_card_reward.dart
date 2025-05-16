import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String userName;
  final int? userPoints;
  final bool isParent;
  final String? avatarUrl; // Добавили поле для аватара

  const UserInfoCard({
    required this.userName,
    this.userPoints,
    required this.isParent,
    this.avatarUrl, // Передаём URL аватара
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.deepPurple,
              backgroundImage:
                  avatarUrl != null && avatarUrl!.isNotEmpty
                      ? NetworkImage(
                        avatarUrl!,
                      ) // Загружаем аватар, если он есть
                      : null,
              child:
                  avatarUrl == null || avatarUrl!.isEmpty
                      ? Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                      : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isParent
                        ? 'Здравствуйте, $userName!'
                        : 'Привет, $userName!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isParent && userPoints != null)
                    Text(
                      'Ваши очки: $userPoints',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
