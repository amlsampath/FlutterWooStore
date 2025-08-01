import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';
import '../../../checkout/domain/repositories/checkout_repository.dart';
import '../../../checkout/domain/entities/billing_info.dart';
import '../../../checkout/domain/entities/shipping_info.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final CheckoutRepository checkoutRepository;

  AuthBloc({
    required this.repository,
    required this.checkoutRepository,
  }) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<Login>(_onLogin);
    on<Register>(_onRegister);
    on<ResetPassword>(_onResetPassword);
    on<Logout>(_onLogout);
    on<SetGuestUser>(_onSetGuestUser);
    on<DeleteAccount>(_onDeleteAccount);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isLoggedIn = await repository.isLoggedIn();
      if (isLoggedIn) {
        final userResult = await repository.getCurrentUser();
        userResult.fold(
          (failure) => emit(Unauthenticated()),
          (user) {
            // Fetch and cache billing info for the user
            _loadUserBillingInfo(user);
            emit(Authenticated(user));
          },
        );
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogin(
    Login event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await repository.login(
        username: event.username,
        password: event.password,
      );

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) {
          // Fetch and cache billing info for the user
          _loadUserBillingInfo(user);
          emit(Authenticated(user));
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegister(
    Register event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await repository.register(
        username: event.username,
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
      );

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) {
          // Fetch and cache billing info for the user
          _loadUserBillingInfo(user);
          emit(Authenticated(user));
        },
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await repository.resetPassword(email: event.email);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(PasswordResetSent()),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(
    Logout event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await repository.logout();
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(Unauthenticated()),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSetGuestUser(
    SetGuestUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Create a guest user
      final guestUser = UserModel(
        id: 0, // Guest users have ID 0
        email: '',
        username: 'guest',
        firstName: 'Guest',
        lastName: 'User',
        avatarUrl: null,
        roles: ['guest'],
      );

      // Create default billing info for guest
      const defaultBillingInfo = BillingInfo(
        firstName: 'Guest',
        lastName: 'User',
        email: '',
        phone: '',
        address: '',
        city: '',
        state: '',
        zip: '',
      );

      // Save the billing info
      await checkoutRepository.saveBillingInfo(defaultBillingInfo);

      // Emit guest user state
      emit(GuestUser(guestUser as User));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await repository.deleteAccount(event.customerId);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(Unauthenticated()),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Helper method to load user billing and shipping info
  Future<void> _loadUserBillingInfo(User user) async {
    try {
      if (user is UserModel) {
        // If user has billing info in their profile, use it
        if (user.billing != null) {
          final billingInfo = BillingInfo(
            firstName: user.billing!['first_name'] ?? '',
            lastName: user.billing!['last_name'] ?? '',
            email: user.billing!['email'] ?? '',
            phone: user.billing!['phone'] ?? '',
            address: user.billing!['address_1'] ?? '',
            city: user.billing!['city'] ?? '',
            state: user.billing!['state'] ?? '',
            zip: user.billing!['postcode'] ?? '',
          );
          await checkoutRepository.saveBillingInfo(billingInfo);
          print('Cached billing info from user profile');
        }

        // If user has shipping info in their profile, use it
        if (user.shipping != null) {
          final shippingInfo = ShippingInfo(
            firstName: user.shipping!['first_name'] ?? '',
            lastName: user.shipping!['last_name'] ?? '',
            phone: user.shipping!['phone'] ?? '',
            address: user.shipping!['address_1'] ?? '',
            city: user.shipping!['city'] ?? '',
            state: user.shipping!['state'] ?? '',
            zip: user.shipping!['postcode'] ?? '',
          );
          await checkoutRepository.saveShippingInfo(shippingInfo);
          print('Cached shipping info from user profile');
        }

        // If no shipping info in profile but has billing, create default shipping from billing
        if (user.shipping == null && user.billing != null) {
          final defaultShipping = ShippingInfo(
            firstName: user.billing!['first_name'] ?? '',
            lastName: user.billing!['last_name'] ?? '',
            phone: user.billing!['phone'] ?? '',
            address: user.billing!['address_1'] ?? '',
            city: user.billing!['city'] ?? '',
            state: user.billing!['state'] ?? '',
            zip: user.billing!['postcode'] ?? '',
          );
          await checkoutRepository.saveShippingInfo(defaultShipping);
          print('Created default shipping info from billing');
        }
      }
    } catch (e) {
      print('Error loading user billing/shipping info: $e');
    }
  }
}
