// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) => WishlistItem(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  link: json['link'] as String,
  status: json['status'] as String,
  createdBy: json['created_by'] as String,
  reservedBy: json['reserved_by'] as Map<String, dynamic>,
  isArchived: json['is_archived'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  photo: json['photo'] as String?,
);

Map<String, dynamic> _$WishlistItemToJson(WishlistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'link': instance.link,
      'status': instance.status,
      'created_by': instance.createdBy,
      'reserved_by': instance.reservedBy,
      'is_archived': instance.isArchived,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'photo': instance.photo,
    };
