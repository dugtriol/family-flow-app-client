part of 'chats_bloc.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

class ChatsInitial extends ChatsState {}

class ChatsLoadSuccess extends ChatsState {
  final List<Message> messages;

  const ChatsLoadSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatsLoadFailure extends ChatsState {
  final String error;

  const ChatsLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
