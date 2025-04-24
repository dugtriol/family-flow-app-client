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
  reservedBy: json['reserved_by'] as Map<String, dynamic>,
  buyerId: json['buyer_id'] as Map<String, dynamic>,
  isArchived: json['is_archived'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'reserved_by': instance.reservedBy,
      'buyer_id': instance.buyerId,
      'is_archived': instance.isArchived,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
