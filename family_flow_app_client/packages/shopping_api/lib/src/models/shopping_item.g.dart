// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) => ShoppingItem(
      id: json['id'] as String,
      familyId: json['family_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      visibility: json['visibility'] as String,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ShoppingItemToJson(ShoppingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'family_id': instance.familyId,
      'title': instance.title,
      'description': instance.description,
      'status': instance.status,
      'visibility': instance.visibility,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
    };
