// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/notification_api/lib/models/notification.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification extends Equatable {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String title;
  final String body;
  final String data;
  @JsonKey(name: 'is_read')
  final bool isRead;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final bool hasResponded;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.data,
    required this.isRead,
    required this.createdAt,
    this.hasResponded = false,
  });

  Notification copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    String? data,
    bool? isRead,
    DateTime? createdAt,
    bool? hasResponded,
  }) {
    return Notification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      hasResponded: hasResponded ?? this.hasResponded,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    body,
    data,
    isRead,
    createdAt,
    hasResponded,
  ];
}
