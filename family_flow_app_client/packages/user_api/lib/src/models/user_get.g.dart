// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_get.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserGet _$UserGetFromJson(Map<String, dynamic> json) => UserGet(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  familyId: json['family_id'] as String,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
);

Map<String, dynamic> _$UserGetToJson(UserGet instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'family_id': instance.familyId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
