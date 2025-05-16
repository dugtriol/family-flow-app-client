import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Для форматирования времени
import 'package:notification_api/models/models.dart';
import 'package:notification_api/models/notification.dart' as notification_api;

import '../../authentication/authentication.dart';
import '../../family/family.dart';
import '../notifications.dart';

class NotificationsPage extends StatelessWidget {
  final List<notification_api.Notification> notifications;

  const NotificationsPage({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    // Сортируем уведомления по дате (самые новые сначала)
    final sortedNotifications = List<notification_api.Notification>.from(
      notifications,
    )..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    final currentUserFamilyId =
        context.read<AuthenticationBloc>().state.user.familyId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Уведомления',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body:
          sortedNotifications.isEmpty
              ? const Center(
                child: Text(
                  'Нет уведомлений',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                itemCount: sortedNotifications.length,
                itemBuilder: (context, index) {
                  final notification = sortedNotifications[index];

                  final title = notification.title ?? 'Без заголовка';
                  final body = notification.body ?? 'Нет описания';
                  final timestamp =
                      notification.createdAt != null
                          ? DateFormat(
                            'd MMMM yyyy, HH:mm',
                            'ru',
                          ).format(notification.createdAt!)
                          : 'Неизвестно';
                  print('Поля уведомления: ${notification.data}');
                  print('ID уведомления: ${notification.id}');
                  print('ID пользователя: ${notification.userId}');
                  Map<String, dynamic>? parsedData;
                  try {
                    parsedData =
                        jsonDecode(notification.data) as Map<String, dynamic>;
                  } catch (e) {
                    print('Ошибка при парсинге данных уведомления: $e');
                  }

                  final familyId = parsedData?['family_id'] ?? '';
                  final role = parsedData?['role'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications,
                          color: Colors.deepPurple,
                        ),
                        title: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(body, style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(
                              timestamp,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (notification.title == 'Приглашение в семью' &&
                                !notification.hasResponded)
                              currentUserFamilyId == null
                                  ? Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          final input = RespondToInviteInput(
                                            familyId: familyId,
                                            role: role,
                                            response: 'accept',
                                          );
                                          context.read<NotificationsBloc>().add(
                                            RespondToInvite(
                                              notificationId: notification.id,
                                              input: input,
                                            ),
                                          );
                                        },
                                        child: const Text('Принять'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          final input = RespondToInviteInput(
                                            familyId: familyId,
                                            role: role,
                                            response: 'decline',
                                          );
                                          context.read<NotificationsBloc>().add(
                                            RespondToInvite(
                                              notificationId: notification.id,
                                              input: input,
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text('Отклонить'),
                                      ),
                                    ],
                                  )
                                  : const Text(
                                    'Вы уже состоите в семье',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                            if (notification.hasResponded)
                              const Text(
                                'Ответ отправлен',
                                style: TextStyle(color: Colors.green),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
