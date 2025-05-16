import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:family_flow_app_client/app/view/notification_service.dart'
    show NotificationService;
import 'package:family_flow_app_client/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Обработка уведомлений в фоновом режиме
  print('Handling a background message: ${message.messageId}');
}

final webSocketService = WebSocketService();
final websocketUrl = 'ws://family-flow-app-1-aigul.amvera.io:80/ws';
// final websocketUrl = 'ws://10.0.2.2:8080/ws';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru', null);
  await Firebase.initializeApp();

  // Запрашиваем разрешение на уведомления
  await requestNotificationPermission();

  // Настраиваем обработку APNs-токена
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Получаем APNs-токен
  final apnsToken = await messaging.getAPNSToken();
  print('APNs Token: $apnsToken');

  // Обработка фоновых уведомлений
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  webSocketService.connect(websocketUrl);

  await NotificationService().initialize();

  runApp(App());
}

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      if (result.isGranted) {
        print('Разрешение на уведомления предоставлено');
      } else {
        print('Разрешение на уведомления отклонено');
      }
    }
  }
}
