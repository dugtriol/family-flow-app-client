import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notification_api/models/input_respond_to_invite.dart'
    show RespondToInviteInput;
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
    on<LoadNotifications>(_onLoadNotifications);
    on<AddNotification>(_onAddNotification);
    on<RespondToInvite>(_onRespondToInvite);
  }

  Future<void> _onSaveFcmToken(
    SaveFcmToken event,
    Emitter<NotificationsState> emit,
  ) async {
    print('Сохранение FCM Token: ${event.fcmToken}');
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

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    try {
      final notifications = await _notificationRepository.getNotifications();
      emit(NotificationsLoadSuccess(notifications));
    } catch (e) {
      print('Ошибка при загрузке уведомлений: $e');
      emit(NotificationsLoadFailure());
    }
  }

  Future<void> _onAddNotification(
    AddNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoadSuccess) {
      final currentState = state as NotificationsLoadSuccess;
      final updatedNotifications = List<Notification>.from(
        currentState.notifications,
      )..add(event.notification);

      emit(NotificationsLoadSuccess(updatedNotifications));
    }
  }

  Future<void> _onRespondToInvite(
    RespondToInvite event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoadSuccess) {
      final currentState = state as NotificationsLoadSuccess;

      try {
        // Отправляем запрос на сервер
        await _notificationRepository.respond(input: event.input);

        // Обновляем состояние уведомлений
        final updatedNotifications =
            currentState.notifications.map((notification) {
              if (notification.id == event.notificationId) {
                return notification.copyWith(hasResponded: true);
              }
              return notification;
            }).toList();

        emit(NotificationsLoadSuccess(updatedNotifications));
      } catch (e) {
        print('Ошибка при обработке ответа на приглашение: $e');
      }
    }
  }
}
