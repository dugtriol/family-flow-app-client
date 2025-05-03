import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/websocket_request.dart';
import '../models/websocket_response.dart';
import '../models/create_message_input.dart';
import '../models/create_chat_input.dart';
import '../models/add_participant_input.dart';

class ChatsApi {
  final String _baseUrl;
  final WebSocketChannel _channel;

  ChatsApi(String baseUrl)
    : _baseUrl = baseUrl,
      _channel = WebSocketChannel.connect(Uri.parse('$baseUrl/ws'));

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
  Future<String> createChat(CreateChatInput input) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/chats'),
      headers: {'Content-Type': 'application/json'},
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
  Future<void> addParticipant(AddParticipantInput input) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/chats/${input.chatId}/participants'),
      headers: {'Content-Type': 'application/json'},
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
    _channel.sink.add(jsonEncode(request.toJson()));
  }

  /// Закрытие WebSocket-соединения
  void close() {
    _channel.sink.close();
  }
}
