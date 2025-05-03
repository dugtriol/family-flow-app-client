import 'package:json_annotation/json_annotation.dart';

part 'websocket_request.g.dart';

@JsonSerializable()
class WebSocketRequest {
  final String action;
  final Map<String, dynamic> data;

  WebSocketRequest({required this.action, required this.data});

  factory WebSocketRequest.fromJson(Map<String, dynamic> json) =>
      _$WebSocketRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WebSocketRequestToJson(this);
}
