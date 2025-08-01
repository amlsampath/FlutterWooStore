import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../checkout/domain/repositories/checkout_repository.dart';
import '../../../checkout/domain/entities/billing_info.dart';
import '../../../checkout/domain/entities/shipping_info.dart';

part 'profile_event.dart';
part 'profile_state.dart';
part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final CheckoutRepository checkoutRepository;

  ProfileBloc({
    required this.authRepository,
    required this.checkoutRepository,
  }) : super(const ProfileState.initial()) {
    on<ProfileEvent>((event, emit) async {
      await event.map(
        loadProfile: (_) => _onLoadProfile(emit),
        editProfile: (e) => _onEditProfile(e, emit),
        loadProfileById: (e) => _onLoadProfileById(e, emit),
      );
    });
  }

  Future<void> _onLoadProfile(Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    final result = await authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(ProfileState.error(failure.toString())),
      (user) => emit(ProfileState.loaded(user as UserModel)),
    );
  }

  Future<void> _onEditProfile(EditProfile event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.updating());
    final result = await authRepository.updateProfile(
      event.updatedUser as User,
      password: event.password,
      billing: event.billing,
      shipping: event.shipping,
      avatarUrl: event.avatarUrl,
    );

    await result.fold<Future<void>>(
      (failure) async => emit(ProfileState.error(failure.toString())),
      (user) async {
        final repoImpl = authRepository as AuthRepositoryImpl;
        await repoImpl.localDataSource.saveUser(user as UserModel);

        if (event.billing != null) {
          final billingInfo = BillingInfo(
            firstName: event.billing!['first_name'] ?? '',
            lastName: event.billing!['last_name'] ?? '',
            email: event.billing!['email'] ?? '',
            phone: event.billing!['phone'] ?? '',
            address: event.billing!['address_1'] ?? '',
            city: event.billing!['city'] ?? '',
            state: event.billing!['state'] ?? '',
            zip: event.billing!['postcode'] ?? '',
          );
          await checkoutRepository.saveBillingInfo(billingInfo);
        }

        if (event.shipping != null) {
          final shippingInfo = ShippingInfo(
            firstName: event.shipping!['first_name'] ?? '',
            lastName: event.shipping!['last_name'] ?? '',
            phone: event.shipping!['phone'] ?? '',
            address: event.shipping!['address_1'] ?? '',
            city: event.shipping!['city'] ?? '',
            state: event.shipping!['state'] ?? '',
            zip: event.shipping!['postcode'] ?? '',
          );
          await checkoutRepository.saveShippingInfo(shippingInfo);
        }

        emit(ProfileState.updated(user as UserModel));
      },
    );
  }

  Future<void> _onLoadProfileById(LoadProfileById event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    final result = await authRepository.getUserById(event.customerId);
    result.fold(
      (failure) => emit(ProfileState.error(failure.toString())),
      (user) => emit(ProfileState.loaded(user as UserModel)),
    );
  }
}
