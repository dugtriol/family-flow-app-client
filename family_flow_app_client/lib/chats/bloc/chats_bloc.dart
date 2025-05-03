import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chats_repository/chats_repository.dart';
import 'package:chats_api/chats_api.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatsRepository _chatsRepository;

  ChatsBloc({required ChatsRepository chatsRepository})
    : _chatsRepository = chatsRepository,
      super(ChatsInitial()) {
    _chatsRepository.messages.listen((response) {
      if (response.status == 'success' && response.data != null) {
        final message = Message.fromJson(response.data!);
        add(ChatsMessageReceived(message));
      } else {
        add(ChatsErrorOccurred(response.message ?? 'Unknown error'));
      }
    });

    on<ChatsCreateChat>(_onCreateChat);
    on<ChatsSendMessage>(_onSendMessage);
    on<ChatsMessageReceived>(_onMessageReceived);
    on<ChatsErrorOccurred>(_onErrorOccurred);
  }

  void _onSendMessage(ChatsSendMessage event, Emitter<ChatsState> emit) {
    _chatsRepository.sendMessage(
      chatId: event.chatId,
      senderId: event.senderId,
      content: event.content,
    );
  }

  void _onMessageReceived(
    ChatsMessageReceived event,
    Emitter<ChatsState> emit,
  ) {
    if (state is ChatsLoadSuccess) {
      final currentState = state as ChatsLoadSuccess;
      emit(ChatsLoadSuccess([...currentState.messages, event.message]));
    } else {
      emit(ChatsLoadSuccess([event.message]));
    }
  }

  void _onErrorOccurred(ChatsErrorOccurred event, Emitter<ChatsState> emit) {
    emit(ChatsLoadFailure(event.error));
  }

  void _onCreateChat(ChatsCreateChat event, Emitter<ChatsState> emit) async {
    try {
      await _chatsRepository.createChat(event.name);
      // Можно обновить состояние или оставить как есть
    } catch (e) {
      add(ChatsErrorOccurred(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _chatsRepository.close();
    return super.close();
  }
}
