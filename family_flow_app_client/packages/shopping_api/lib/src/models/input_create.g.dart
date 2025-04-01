// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingCreateInput _$ShoppingCreateInputFromJson(Map<String, dynamic> json) =>
    ShoppingCreateInput(
      familyId: json['family_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      visibility: json['visibility'] as String,
    );

Map<String, dynamic> _$ShoppingCreateInputToJson(
        ShoppingCreateInput instance) =>
    <String, dynamic>{
      'family_id': instance.familyId,
      'title': instance.title,
      'description': instance.description,
      'visibility': instance.visibility,
    };
