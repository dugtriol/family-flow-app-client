import 'package:json_annotation/json_annotation.dart';

part 'websocket_response.g.dart';

@JsonSerializable()
class WebSocketResponse {
  final String status;
  final String? message;
  final Map<String, dynamic>? data;

  WebSocketResponse({required this.status, this.message, this.data});

  factory WebSocketResponse.fromJson(Map<String, dynamic> json) =>
      _$WebSocketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WebSocketResponseToJson(this);
}
