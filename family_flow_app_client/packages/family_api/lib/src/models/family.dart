// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/family_api/lib/src/models/family.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'family.g.dart';

@JsonSerializable()
class Family extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Family({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Family.fromJson(Map<String, dynamic> json) => _$FamilyFromJson(json);

  Map<String, dynamic> toJson() => _$FamilyToJson(this);

  @override
  List<Object?> get props => [id, name, createdAt];
}
