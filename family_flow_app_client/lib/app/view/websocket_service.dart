import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  void connect(String url) {
    print('Connecting to WebSocket at $url...');
    _channel = WebSocketChannel.connect(Uri.parse(url));

    // Listen to incoming messages
    _channel.stream.listen(
      (data) {
        print('Received data: $data');
        try {
          final response = Map<String, dynamic>.from(jsonDecode(data));
          if (response['status'] == 'success' && response['data'] != null) {
            print('Message added to stream: $response');
            _messageController.add(response);
          } else {
            print('Message ignored: $response');
          }
        } catch (e) {
          print('Error decoding message: $e');
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed.');
      },
    );
  }

  void sendMessage(Map<String, dynamic> message) {
    final encodedMessage = jsonEncode(message);
    print('Sending message: $encodedMessage');
    _channel.sink.add(encodedMessage);
  }

  void dispose() {
    print('Closing WebSocket connection and disposing resources...');
    _channel.sink.close();
    _messageController.close();
  }
}
