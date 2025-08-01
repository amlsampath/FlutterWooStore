import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/auth_token.dart';

part 'auth_token_model.freezed.dart';
part 'auth_token_model.g.dart';

@freezed
class AuthTokenModel extends AuthToken with _$AuthTokenModel {
  @Implements<AuthToken>()
  factory AuthTokenModel({
    required String token,
    required DateTime expiryDate,
  }) = _AuthTokenModel;

  AuthTokenModel._() : super(token: '', expiryDate: DateTime.now());

  @override
  bool get isValid => DateTime.now().isBefore(expiryDate);

  @override
  List<Object?> get props => [token, expiryDate];

  @override
  bool? get stringify => true;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  factory AuthTokenModel.fromWPJson(Map<String, dynamic> json) {
    final String token = json['token'] as String;
    return AuthTokenModel.fromJWT(token);
  }

  factory AuthTokenModel.fromJWT(String token) {
    final authToken = AuthToken.fromJWT(token);
    return AuthTokenModel(
      token: authToken.token,
      expiryDate: authToken.expiryDate,
    );
  }
}
