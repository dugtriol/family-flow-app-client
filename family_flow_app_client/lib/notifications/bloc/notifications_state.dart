part of 'notifications_bloc.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<Notification> notifications;

  const NotificationsLoaded({required this.notifications});

  @override
  List<Object> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError({required this.message});

  @override
  List<Object> get props => [message];
}

class NotificationsLoadSuccess extends NotificationsState {
  final List<Notification> notifications;

  const NotificationsLoadSuccess(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationsLoadFailure extends NotificationsState {}
