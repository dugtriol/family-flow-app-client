// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistUpdateInput _$WishlistUpdateInputFromJson(Map<String, dynamic> json) =>
    WishlistUpdateInput(
      name: json['name'] as String,
      description: json['description'] as String,
      link: json['link'] as String,
      status: json['status'] as String,
      isReserved: json['is_reserved'] as bool,
    );

Map<String, dynamic> _$WishlistUpdateInputToJson(
        WishlistUpdateInput instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'link': instance.link,
      'status': instance.status,
      'is_reserved': instance.isReserved,
    };
