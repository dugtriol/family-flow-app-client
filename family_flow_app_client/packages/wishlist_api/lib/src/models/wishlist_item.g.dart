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
      isReserved: json['is_reserved'] as bool,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$WishlistItemToJson(WishlistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'link': instance.link,
      'status': instance.status,
      'is_reserved': instance.isReserved,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
    };
