import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class NotificationApi {
  // static const _baseUrl = 'http://10.0.2.2:8080/api';
  // static const _baseUrl = 'http://family-flow-app-aigul.amvera.io/api';
  static const _baseUrl = 'http://family-flow-app-1-aigul.amvera.io/api';

  /// Отправка FCM токена на сервер
  Future<void> sendFcmTokenToServer(String fcmToken, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/notification/save-fcm-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'fcmToken': fcmToken}),
      );

      if (response.statusCode == 200) {
        print('FCM Token успешно отправлен на сервер');
      } else {
        print('Ошибка при отправке FCM Token: ${response.body}');
      }
    } catch (e) {
      print('Ошибка при отправке FCM Token: $e');
    }
  }

  /// Отправка уведомления
  Future<void> sendNotification(String title, String body, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/notification/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'title': title, 'body': body}),
      );

      if (response.statusCode == 200) {
        print('Уведомление успешно отправлено');
      } else {
        print('Ошибка при отправке уведомления: ${response.body}');
      }
    } catch (e) {
      print('Ошибка при отправке уведомления: $e');
    }
  }

  /// Получение уведомлений
  Future<List<Notification>> getNotifications(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/notification/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> notificationsJson = jsonDecode(response.body);
        return notificationsJson
            .map((json) => Notification.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        print('Ошибка при получении уведомлений: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Ошибка при получении уведомлений: $e');
      return [];
    }
  }

  /// Отправка ответа на приглашение
  Future<void> respondToInvite({
    required RespondToInviteInput input,
    required String token,
  }) async {
    print('Отправка ответа на приглашение: $input');
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/family/respond-invite'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(input.toJson()), // Используем метод toJson из модели
      );

      if (response.statusCode == 200) {
        print('Ответ на приглашение успешно отправлен');
      } else {
        print('Ошибка при отправке ответа на приглашение: ${response.body}');
      }
    } catch (e) {
      print('Ошибка при отправке ответа на приглашение: $e');
    }
  }
}
