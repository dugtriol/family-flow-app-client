part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class SaveFcmToken extends NotificationsEvent {
  final String fcmToken;

  const SaveFcmToken(this.fcmToken);

  @override
  List<Object> get props => [fcmToken];
}

class SendLoginNotification extends NotificationsEvent {}

class LoadNotifications extends NotificationsEvent {}

class AddNotification extends NotificationsEvent {
  final Notification notification;

  const AddNotification(this.notification);

  @override
  List<Object> get props => [notification];
}

class RespondToInvite extends NotificationsEvent {
  final String notificationId;
  final RespondToInviteInput input;

  const RespondToInvite({required this.notificationId, required this.input});

  @override
  List<Object> get props => [notificationId, input];
}
