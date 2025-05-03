import 'package:chats_api/chats_api.dart';

class ChatsRepository {
  late final ChatsApi _chatsApi;

  ChatsRepository({required String apiUrl}) {
    _chatsApi = ChatsApi(apiUrl);
  }

  /// Подписка на входящие сообщения
  Stream<WebSocketResponse> get messages => _chatsApi.messages;

  /// Создание чата
  Future<void> createChat(String name) async {
    final input = CreateChatInput(name: name);
    _chatsApi.createChat(input);
  }

  /// Добавление участника в чат
  Future<void> addParticipant(String chatId, String userId) async {
    final input = AddParticipantInput(chatId: chatId, userId: userId);
    _chatsApi.addParticipant(input);
  }

  /// Отправка сообщения
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
  }) async {
    final input = CreateMessageInput(
      chatId: chatId,
      senderId: senderId,
      content: content,
    );
    _chatsApi.sendMessage(input);
  }

  /// Закрытие WebSocket-соединения
  void close() {
    _chatsApi.close();
  }
}
