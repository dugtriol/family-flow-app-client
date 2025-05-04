part of 'chats_bloc.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

/// Начальное состояние
class ChatsInitial extends ChatsState {}

/// Состояние успешной загрузки чатов
class ChatsLoadSuccess extends ChatsState {
  final List<Chat> chats;

  const ChatsLoadSuccess(this.chats);

  @override
  List<Object> get props => [chats];
}

/// Состояние ошибки
class ChatsLoadFailure extends ChatsState {
  final String error;

  const ChatsLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

/// Состояние успешной загрузки сообщений
class ChatsMessagesLoadSuccess extends ChatsState {
  final List<Message> messages;

  const ChatsMessagesLoadSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}
