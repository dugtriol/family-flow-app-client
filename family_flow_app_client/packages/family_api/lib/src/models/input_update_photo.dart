import 'dart:io' show File;

import 'package:json_annotation/json_annotation.dart';

part 'input_update_photo.g.dart';

@JsonSerializable()
class InputUpdatePhoto {
  const InputUpdatePhoto({required this.familyId, required this.photo});

  final String familyId;

  @JsonKey(fromJson: _fileFromJson, toJson: _fileToJson)
  final File? photo;

  factory InputUpdatePhoto.fromJson(Map<String, dynamic> json) =>
      _$InputUpdatePhotoFromJson(json);

  Map<String, dynamic> toJson() => _$InputUpdatePhotoToJson(this);

  // Кастомная функция для десериализации File
  static File? _fileFromJson(String? path) {
    if (path == null) return null;
    return File(path);
  }

  // Кастомная функция для сериализации File
  static String? _fileToJson(File? file) {
    return file?.path;
  }
}
