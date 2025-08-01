import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthToken extends Equatable {
  final String token;
  final DateTime expiryDate;

  const AuthToken({
    required this.token,
    required this.expiryDate,
  });

  factory AuthToken.fromJWT(String token) {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final int expiryTimestamp = decodedToken['exp'] as int;
    final expiryDate =
        DateTime.fromMillisecondsSinceEpoch(expiryTimestamp * 1000);

    return AuthToken(
      token: token,
      expiryDate: expiryDate,
    );
  }

  bool get isValid {
    final now = DateTime.now();
    return now.isBefore(expiryDate);
  }

  @override
  List<Object?> get props => [token, expiryDate];
}
