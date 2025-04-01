// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'output_get_members.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutputGetMembers _$OutputGetMembersFromJson(Map<String, dynamic> json) =>
    OutputGetMembers(
      users: (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OutputGetMembersToJson(OutputGetMembers instance) =>
    <String, dynamic>{
      'users': instance.users,
    };
