import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_session.dart';
import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  final String accessToken;
  final UserModel user;

  const AuthResponseModel({required this.accessToken, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  AuthSession toEntity() =>
      AuthSession(accessToken: accessToken, user: user.toEntity());
}
