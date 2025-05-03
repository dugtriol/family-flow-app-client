// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'websocket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebSocketResponse _$WebSocketResponseFromJson(Map<String, dynamic> json) =>
    WebSocketResponse(
      status: json['status'] as String,
      message: json['message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$WebSocketResponseToJson(WebSocketResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };
