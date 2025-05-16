// import 'dart:async';
// import 'dart:convert';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class WebSocketService {
//   late WebSocketChannel _channel;
//   final StreamController<Map<String, dynamic>> _messageController =
//       StreamController.broadcast();

//   Stream<Map<String, dynamic>> get messages => _messageController.stream;

//   void connect(String url) {
//     _channel = WebSocketChannel.connect(Uri.parse(url));

//     // Слушаем входящие сообщения
//     _channel.stream.listen((data) {
//       final response = Map<String, dynamic>.from(jsonDecode(data));
//       if (response['status'] == 'success' && response['data'] != null) {
//         _messageController.add(response);
//       }
//     });
//   }

//   void sendMessage(Map<String, dynamic> message) {
//     _channel.sink.add(jsonEncode(message));
//   }

//   void dispose() {
//     _channel.sink.close();
//     _messageController.close();
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();
  Timer? _pingTimer;
  final websocketUrl = 'ws://family-flow-app-1-aigul.amvera.io:80/ws';

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _handleWebSocket(_channel);
    _startPing(_channel);
  }

  void _handleWebSocket(WebSocketChannel channel) {
    channel.stream.listen(
      (data) {
        final response = Map<String, dynamic>.from(jsonDecode(data));
        if (response['status'] == 'success' && response['data'] != null) {
          _messageController.add(response);
        }
        print('Message received: $data');
      },
      onDone: () {
        print('WebSocket closed. Reconnecting...');
        _reconnect();
      },
      onError: (error) {
        print('WebSocket error: $error');
        _reconnect();
      },
    );
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      print('Attempting to reconnect...');
      connect(websocketUrl);
    });
  }

  void _startPing(WebSocketChannel channel) {
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      channel.sink.add(jsonEncode({'type': 'ping'}));
      print('Ping sent');
    });
  }

  void _stopPing() {
    _pingTimer?.cancel();
  }

  void sendMessage(Map<String, dynamic> message) {
    _channel.sink.add(jsonEncode(message));
  }

  void dispose() {
    _stopPing();
    _channel.sink.close();
    _messageController.close();
  }
}
