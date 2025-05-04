import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/models.dart';
import '../models/websocket_request.dart';
import '../models/websocket_response.dart';
import '../models/create_message_input.dart';
import '../models/create_chat_input.dart';
import '../models/add_participant_input.dart';

class ChatsApi {
  static const _baseUrl = 'http://10.0.2.2:8080/api';
  final WebSocketChannel _channel;
  final http.Client _httpClient;

  ChatsApi({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client(),
      _channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080/ws'));

  /// Подписка на входящие сообщения через WebSocket
  Stream<WebSocketResponse> get messages => _channel.stream.map((message) {
    try {
      final json = jsonDecode(message);
      return WebSocketResponse.fromJson(json);
    } catch (e) {
      return WebSocketResponse(status: 'error', message: 'Invalid JSON format');
    }
  });

  /// Создание чата через HTTP API
  Future<String> createChat(CreateChatInput input, String token) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/chats'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['chat_id'];
    } else {
      throw Exception('Failed to create chat: ${response.body}');
    }
  }

  /// Добавление участника в чат через HTTP API
  Future<void> addParticipant(AddParticipantInput input, String token) async {
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/chats/${input.chatId}/participants'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add participant: ${response.body}');
    }
  }

  /// Отправка сообщения через WebSocket
  void sendMessage(CreateMessageInput input) {
    final request = WebSocketRequest(
      action: 'send_message',
      data: input.toJson(),
    );
    _channel.sink.add(jsonEncode(request.toJson()));
  }

  /// Получение сообщений через WebSocket
  void getMessages(String chatId) {
    final request = WebSocketRequest(
      action: 'get_messages',
      data: {'chat_id': chatId},
    );
    print('Requesting messages for chat ID: $chatId');
    _channel.sink.add(jsonEncode(request.toJson()));
  }

  Future<String> createChatWithParticipants(
    CreateChatWithParticipantsInput input,
    String token,
  ) async {
    print('Creating chat with participants: ${input.participantIds}');
    print('Creating chat with participants: ${input.toJson()}');
    final response = await _httpClient.post(
      Uri.parse('$_baseUrl/chats/with-participants'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(input.toJson()),
    );

    print(
      'Create chat with participants response: ${response.statusCode} ${response.body}',
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['chat_id'];
    } else {
      throw Exception(
        'Failed to create chat with participants: ${response.body}',
      );
    }
  }

  /// Получение чатов по ID пользователя через HTTP API
  Future<List<Chat>> getChatsByUserID(String token) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/chats/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response status code is not 200. Throwing Exception.');
      print('Response body: ${response.body}');
      throw Exception('Failed to get chats');
    }

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (responseBody == null || responseBody is! List) {
      print(
        'API вернул null или некорректный формат. Возвращаем пустой список.',
      );
      return []; // Возвращаем пустой список, если данные некорректны
    }

    print('getChatsByUserID - Chats fetched successfully: $responseBody');
    return responseBody.map((json) => Chat.fromJson(json)).toList();
  }

  /// Получение сообщений по ID чата через HTTP API
  Future<List<Message>> getMessagesByChatID(String chatId, String token) async {
    final response = await _httpClient.get(
      Uri.parse('$_baseUrl/chats/$chatId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response status code is not 200. Throwing Exception.');
      print('Response body: ${response.body}');
      throw Exception('Failed to get messages');
    }

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    if (responseBody == null || responseBody is! List) {
      print(
        'API вернул null или некорректный формат. Возвращаем пустой список.',
      );
      return []; // Возвращаем пустой список, если данные некорректны
    }

    print('getMessagesByChatID - Messages fetched successfully: $responseBody');
    return responseBody.map((json) => Message.fromJson(json)).toList();
  }

  /// Закрытие WebSocket-соединения
  void close() {
    _channel.sink.close();
  }
}
