// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// User _$UserFromJson(Map<String, dynamic> json) => User(
//   id: json['id'] as String,
//   name: json['name'] as String,
//   email: json['email'] as String,
//   password: json['password'] as String,
//   role: json['role'] as String,
//   familyId: json['family_id'] as String?,
//   latitude: (json['latitude'] as num?)?.toDouble(),
//   longitude: (json['longitude'] as num?)?.toDouble(),
//   gender: json['gender'] as String,
//   point: (json['point'] as num).toInt(),
//   birthDate:
//       json['birth_date'] == null
//           ? null
//           : DateTime.parse(json['birth_date'] as String),
//   avatar: json['avatar'] as String?,
// );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
  'role': instance.role,
  'family_id': instance.familyId,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'gender': instance.gender,
  'point': instance.point,
  'birth_date': instance.birthDate?.toIso8601String(),
  'avatar': instance.avatar,
};
