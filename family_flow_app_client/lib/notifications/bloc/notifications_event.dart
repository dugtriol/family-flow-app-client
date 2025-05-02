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
