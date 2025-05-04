part of 'chats_bloc.dart';

abstract class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

/// Загрузка чатов
class ChatsLoad extends ChatsEvent {
  const ChatsLoad();
}

/// Создание чата
class ChatsCreateChat extends ChatsEvent {
  final String name;

  const ChatsCreateChat({required this.name});

  @override
  List<Object> get props => [name];
}

/// Добавление участника в чат
class ChatsAddParticipant extends ChatsEvent {
  final String chatId;
  final String userId;

  const ChatsAddParticipant({required this.chatId, required this.userId});

  @override
  List<Object> get props => [chatId, userId];
}

/// Отправка сообщения
class ChatsSendMessage extends ChatsEvent {
  final String chatId;
  final String senderId;
  final String content;

  const ChatsSendMessage({
    required this.chatId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object> get props => [chatId, senderId, content];
}

/// Событие для создания чата с участниками
class ChatsCreateChatWithParticipants extends ChatsEvent {
  final String name;
  final List<String> participantIds;

  const ChatsCreateChatWithParticipants({
    required this.name,
    required this.participantIds,
  });

  @override
  List<Object> get props => [name, participantIds];
}

/// Загрузка сообщений для чата
class ChatsLoadMessages extends ChatsEvent {
  final String chatId;

  const ChatsLoadMessages({required this.chatId});

  @override
  List<Object> get props => [chatId];
}
