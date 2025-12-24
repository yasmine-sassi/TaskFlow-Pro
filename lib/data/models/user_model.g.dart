// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: _stringOrEmpty(_readIdOrSub(json, 'id')),
  email: _stringOrEmpty(json['email']),
  firstName: _stringOrNull(json['firstName']),
  lastName: _stringOrNull(json['lastName']),
  role: _stringOrNull(json['role']),
  avatar: _stringOrNull(json['avatar']),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'role': instance.role,
  'avatar': instance.avatar,
};
