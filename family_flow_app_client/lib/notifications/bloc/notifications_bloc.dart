import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_api/models/notification.dart';
import 'package:notification_repository/notification_repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _notificationRepository;

  NotificationsBloc({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository,
      super(NotificationsInitial()) {
    on<SaveFcmToken>(_onSaveFcmToken);
    on<SendLoginNotification>(_onSendLoginNotification);
  }

  Future<void> _onSaveFcmToken(
    SaveFcmToken event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _notificationRepository.sendFcmToken(event.fcmToken);
      print('FCM Token успешно сохранён на сервере');
    } catch (e) {
      print('Ошибка при сохранении FCM Token: $e');
    }
  }

  Future<void> _onSendLoginNotification(
    SendLoginNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _notificationRepository.sendNotification(
        'Пользователь вошел',
        'Пользователь успешно вошел в приложение.',
      );
      print('Уведомление о входе успешно отправлено');
    } catch (e) {
      print('Ошибка при отправке уведомления о входе: $e');
    }
  }
}
