part of 'profile_bloc.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded(UserModel user) = _Loaded;
  const factory ProfileState.updating() = _Updating;
  const factory ProfileState.updated(UserModel user) = _Updated;
  const factory ProfileState.error(String message) = _Error;
} 