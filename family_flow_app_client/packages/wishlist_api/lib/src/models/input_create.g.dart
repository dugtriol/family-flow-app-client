// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistCreateInput _$WishlistCreateInputFromJson(Map<String, dynamic> json) =>
    WishlistCreateInput(
      name: json['name'] as String,
      description: json['description'] as String,
      link: json['link'] as String,
    );

Map<String, dynamic> _$WishlistCreateInputToJson(
  WishlistCreateInput instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'link': instance.link,
};
