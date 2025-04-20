// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingUpdateInput _$ShoppingUpdateInputFromJson(Map<String, dynamic> json) =>
    ShoppingUpdateInput(
      // id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      visibility: json['visibility'] as String,
    );

Map<String, dynamic> _$ShoppingUpdateInputToJson(
  ShoppingUpdateInput instance,
) => <String, dynamic>{
  // 'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'status': instance.status,
  'visibility': instance.visibility,
};
