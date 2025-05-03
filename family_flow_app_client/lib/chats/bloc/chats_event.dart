part of 'chats_bloc.dart';

abstract class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

class ChatsCreateChat extends ChatsEvent {
  final String name;

  const ChatsCreateChat({required this.name});

  @override
  List<Object> get props => [name];
}

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

class ChatsMessageReceived extends ChatsEvent {
  final Message message;

  const ChatsMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class ChatsErrorOccurred extends ChatsEvent {
  final String error;

  const ChatsErrorOccurred(this.error);

  @override
  List<Object> get props => [error];
}
