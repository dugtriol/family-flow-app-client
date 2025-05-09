// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_update_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputUpdatePhoto _$InputUpdatePhotoFromJson(Map<String, dynamic> json) =>
    InputUpdatePhoto(
      familyId: json['familyId'] as String,
      photo: InputUpdatePhoto._fileFromJson(json['photo'] as String?),
    );

Map<String, dynamic> _$InputUpdatePhotoToJson(InputUpdatePhoto instance) =>
    <String, dynamic>{
      'familyId': instance.familyId,
      'photo': InputUpdatePhoto._fileToJson(instance.photo),
    };
