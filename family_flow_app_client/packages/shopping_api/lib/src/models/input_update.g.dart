// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingUpdateInput _$ShoppingUpdateInputFromJson(Map<String, dynamic> json) =>
    ShoppingUpdateInput(
      title: json['title'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      visibility: json['visibility'] as String,
      isArchived: json['is_archived'] as bool,
    );

Map<String, dynamic> _$ShoppingUpdateInputToJson(
  ShoppingUpdateInput instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'status': instance.status,
  'visibility': instance.visibility,
  'is_archived': instance.isArchived,
};
