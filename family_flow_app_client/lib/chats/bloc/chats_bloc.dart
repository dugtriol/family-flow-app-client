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
    on<ChatsLoad>(_onLoadChats);
    on<ChatsCreateChat>(_onCreateChat);
    on<ChatsAddParticipant>(_onAddParticipant);
    // on<ChatsSendMessage>(_onSendMessage);
    on<ChatsCreateChatWithParticipants>(_onCreateChatWithParticipants);
    on<ChatsLoadMessages>(_onLoadMessages);
  }

  /// Загрузка чатов
  Future<void> _onLoadChats(ChatsLoad event, Emitter<ChatsState> emit) async {
    try {
      final chats = await _chatsRepository.getChatsByUserID();
      emit(ChatsLoadSuccess(chats));
    } catch (e) {
      emit(ChatsLoadFailure(e.toString()));
    }
  }

  /// Создание чата
  Future<void> _onCreateChat(
    ChatsCreateChat event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      await _chatsRepository.createChat(event.name);
      add(const ChatsLoad()); // Перезагрузка чатов после создания
    } catch (e) {
      emit(ChatsLoadFailure(e.toString()));
    }
  }

  /// Добавление участника в чат
  Future<void> _onAddParticipant(
    ChatsAddParticipant event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      await _chatsRepository.addParticipant(event.chatId, event.userId);
      add(const ChatsLoad()); // Перезагрузка чатов после добавления участника
    } catch (e) {
      emit(ChatsLoadFailure(e.toString()));
    }
  }

  /// Отправка сообщения
  // Future<void> _onSendMessage(
  //   ChatsSendMessage event,
  //   Emitter<ChatsState> emit,
  // ) async {
  //   try {
  //     await _chatsRepository.sendMessage(
  //       chatId: event.chatId,
  //       senderId: event.senderId,
  //       content: event.content,
  //     );
  //   } catch (e) {
  //     emit(ChatsLoadFailure(e.toString()));
  //   }
  // }

  /// Создание чата с участниками
  Future<void> _onCreateChatWithParticipants(
    ChatsCreateChatWithParticipants event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      print('Создание чата с участниками: ${event.participantIds}');
      await _chatsRepository.createChatWithParticipants(
        name: event.name,
        participantIds: event.participantIds,
      );
      add(const ChatsLoad()); // Перезагрузка чатов после создания
    } catch (e) {
      emit(ChatsLoadFailure(e.toString()));
    }
  }

  /// Обработка события загрузки сообщений
  Future<void> _onLoadMessages(
    ChatsLoadMessages event,
    Emitter<ChatsState> emit,
  ) async {
    try {
      final messages = await _chatsRepository.getMessagesByChatID(event.chatId);
      emit(ChatsMessagesLoadSuccess(messages));

      // После загрузки сообщений возвращаемся к списку чатов
      // final chats = await _chatsRepository.getChatsByUserID();
      // emit(ChatsLoadSuccess(chats));
    } catch (e) {
      emit(ChatsLoadFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _chatsRepository.close();
    return super.close();
  }
}
