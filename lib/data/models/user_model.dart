import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

Object? _readIdOrSub(Map json, String key) => json[key] ?? json['sub'];
String _stringOrEmpty(Object? v) => v?.toString() ?? '';
String? _stringOrNull(Object? v) => v?.toString();

@JsonSerializable()
class UserModel {
  @JsonKey(readValue: _readIdOrSub, fromJson: _stringOrEmpty)
  final String id;
  @JsonKey(fromJson: _stringOrEmpty)
  final String email;
  @JsonKey(fromJson: _stringOrNull)
  final String? firstName;
  @JsonKey(fromJson: _stringOrNull)
  final String? lastName;
  @JsonKey(fromJson: _stringOrNull)
  final String? role;
  @JsonKey(fromJson: _stringOrNull)
  final String? avatar;

  const UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.avatar,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() => User(
    id: id,
    email: email,
    firstName: firstName ?? '',
    lastName: lastName ?? '',
    role: role ?? 'USER',
    avatar: avatar,
  );
}
