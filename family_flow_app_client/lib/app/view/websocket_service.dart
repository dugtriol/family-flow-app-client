import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    // Слушаем входящие сообщения
    _channel.stream.listen((data) {
      final response = Map<String, dynamic>.from(jsonDecode(data));
      if (response['status'] == 'success' && response['data'] != null) {
        _messageController.add(response);
      }
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    _channel.sink.add(jsonEncode(message));
  }

  void dispose() {
    _channel.sink.close();
    _messageController.close();
  }
}
