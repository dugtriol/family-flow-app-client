import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification_api/notification_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationRepository {
  NotificationRepository({
    NotificationApi? notificationApi,
    FirebaseMessaging? firebaseMessaging,
  }) : _notificationApi = notificationApi ?? NotificationApi(),
       _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  final NotificationApi _notificationApi;
  final FirebaseMessaging _firebaseMessaging;

  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Инициализация уведомлений
  Future<void> initializeNotifications() async {
    // Запрашиваем разрешение на уведомления
    await _firebaseMessaging.requestPermission();

    // Слушаем входящие уведомления, когда приложение активно
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Получено уведомление: ${message.notification?.title}');
      // Здесь можно добавить логику для отображения уведомления в приложении
    });

    // Обрабатываем уведомления, когда приложение открывается из фона
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Пользователь открыл уведомление: ${message.notification?.title}');
      // Здесь можно перенаправить пользователя на определённый экран
    });

    // Обрабатываем уведомления, когда приложение закрыто
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print(
        'Приложение открыто из уведомления: ${initialMessage.notification?.title}',
      );
      // Здесь можно обработать переход на экран
    }

    // Слушаем обновления FCM токена
    _firebaseMessaging.onTokenRefresh.listen((String newToken) async {
      print('Обновлённый FCM Token: $newToken');
      await sendFcmToken(newToken);
    });
  }

  /// Отправка FCM токена на сервер
  Future<void> sendFcmToken(String fcmToken) async {
    final token = await _getJwtToken();
    if (token == null) {
      print('JWT token is missing');
      throw Exception('JWT token is missing');
    }
    try {
      print('NotificationRepository - FCM Token: $fcmToken');
      await _notificationApi.sendFcmTokenToServer(fcmToken, token);
    } catch (e) {
      print('Ошибка при отправке FCM Token: $e');
    }
  }

  /// Отправка уведомления
  Future<void> sendNotification(String title, String body) async {
    final token = await _getJwtToken();
    if (token == null) {
      print('JWT token is missing');
      throw Exception('JWT token is missing');
    }
    try {
      await _notificationApi.sendNotification(title, body, token);
    } catch (e) {
      print('Ошибка при отправке уведомления: $e');
    }
  }

  /// Получение списка уведомлений
  Future<List<Notification>> getNotifications() async {
    final token = await _getJwtToken();
    if (token == null) {
      print('JWT token is missing');
      throw Exception('JWT token is missing');
    }
    try {
      return await _notificationApi.getNotifications(token);
    } catch (e) {
      print('Ошибка при получении уведомлений: $e');
      return [];
    }
  }

  Future<void> respond({required RespondToInviteInput input}) async {
    final token = await _getJwtToken();
    if (token == null) {
      print('JWT token is missing');
      throw Exception('JWT token is missing');
    }

    try {
      await _notificationApi.respondToInvite(input: input, token: token);
      print('Ответ на приглашение успешно отправлен');
    } catch (e) {
      print('Ошибка при отправке ответа на приглашение: $e');
      throw Exception('Failed to respond to invite');
    }
  }
}
