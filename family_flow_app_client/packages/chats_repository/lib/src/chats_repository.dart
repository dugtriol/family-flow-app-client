import 'package:chats_api/chats_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsRepository {
  late final ChatsApi _chatsApi;

  ChatsRepository() {
    _chatsApi = ChatsApi();
    print('ChatsRepository initialized');
  }

  /// Подписка на входящие сообщения
  Stream<WebSocketResponse> get messages {
    print('Subscribed to messages stream');
    return _chatsApi.messages;
  }

  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Создание чата
  Future<void> createChat(String name) async {
    final token = await _getJwtToken();
    if (token == null) {
      throw Exception('JWT token is missing');
    }
    print('Creating chat with name: $name');
    final input = CreateChatInput(name: name);
    await _chatsApi.createChat(input, token);
    print('Chat created with name: $name');
  }

  /// Добавление участника в чат
  Future<void> addParticipant(String chatId, String userId) async {
    final token = await _getJwtToken();
    if (token == null) {
      throw Exception('JWT token is missing');
    }
    print('Adding participant with userId: $userId to chatId: $chatId');
    final input = AddParticipantInput(chatId: chatId, userId: userId);
    await _chatsApi.addParticipant(input, token);
    print('Participant added with userId: $userId to chatId: $chatId');
  }

  /// Отправка сообщения
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
  }) async {
    print(
      'Sending message to chatId: $chatId from senderId: $senderId with content: $content',
    );
    final input = CreateMessageInput(
      chatId: chatId,
      senderId: senderId,
      content: content,
    );
    _chatsApi.sendMessage(input);
    print('Message sent to chatId: $chatId');
  }

  Future<String> createChatWithParticipants({
    required String name,
    required List<String> participantIds,
  }) async {
    final token = await _getJwtToken();
    if (token == null) {
      throw Exception('JWT token is missing');
    }

    print('Creating chat with name: $name and participants: $participantIds');
    final input = CreateChatWithParticipantsInput(
      name: name,
      participantIds: participantIds,
    );
    final chatId = await _chatsApi.createChatWithParticipants(input, token);
    print('Chat created with ID: $chatId');
    return chatId;
  }

  /// Получение чатов по ID пользователя
  Future<List<Chat>> getChatsByUserID() async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        return []; // Возвращаем пустой список, если токен отсутствует
      }

      print('Fetching chats by user ID');
      final chats = await _chatsApi.getChatsByUserID(token);
      if (chats.isEmpty) {
        print('Нет доступных чатов.');
      }
      return chats;
    } catch (e) {
      print('Ошибка при получении чатов: $e');
      return []; // Возвращаем пустой список в случае ошибки
    }
  }

  /// Закрытие WebSocket-соединения
  void close() {
    print('Closing WebSocket connection');
    _chatsApi.close();
    print('WebSocket connection closed');
  }
}
