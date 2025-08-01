import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  @Implements<User>()
  factory UserModel({
    required int id,
    required String email,
    required String username,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default([]) List<String> roles,
    Map<String, dynamic>? billing,
    Map<String, dynamic>? shipping,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromWPJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      billing: json['billing'] as Map<String, dynamic>?,
      shipping: json['shipping'] as Map<String, dynamic>?,
    );
  }

  @override
  bool get isAdmin => roles.contains('administrator');

  @override
  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props =>
      [id, email, username, firstName, lastName, avatarUrl, roles];

  @override
  bool? get stringify => true;
}
