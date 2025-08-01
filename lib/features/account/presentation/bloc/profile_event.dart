part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.loadProfile() = LoadProfile;
  
  const factory ProfileEvent.editProfile({
    required UserModel updatedUser,
    String? password,
    Map<String, dynamic>? billing,
    Map<String, dynamic>? shipping,
    String? avatarUrl,
  }) = EditProfile;
  
  const factory ProfileEvent.loadProfileById({
    required int customerId,
  }) = LoadProfileById;
} 