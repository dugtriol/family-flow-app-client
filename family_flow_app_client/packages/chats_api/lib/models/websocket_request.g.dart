// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketRequest _$WebSocketRequestFromJson(Map<String, dynamic> json) =>
    WebSocketRequest(
      action: json['action'] as String,
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$WebSocketRequestToJson(WebSocketRequest instance) =>
    <String, dynamic>{'action': instance.action, 'data': instance.data};
