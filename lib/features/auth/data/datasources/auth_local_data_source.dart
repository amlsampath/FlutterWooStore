import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import '../../../../core/error/failures.dart';
import '../../../checkout/data/models/billing_info_model.dart';
import '../../../checkout/data/models/shipping_info_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(AuthTokenModel token);
  Future<AuthTokenModel?> getToken();
  Future<void> deleteToken();

  // Add user data methods
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();

  // Add shipping and billing methods
  Future<void> saveShippingInfo(Map<String, dynamic> shipping);
  Future<void> saveBillingInfo(Map<String, dynamic> billing);
  Future<Map<String, dynamic>?> getShippingInfo();
  Future<Map<String, dynamic>?> getBillingInfo();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  final Box<BillingInfoModel> billingBox;
  final Box<ShippingInfoModel> shippingBox;
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  AuthLocalDataSourceImpl({
    required this.storage,
    required this.billingBox,
    required this.shippingBox,
  });

  @override
  Future<void> saveToken(AuthTokenModel token) async {
    try {
      await storage.write(
        key: _tokenKey,
        value: json.encode(token.toJson()),
      );
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to save token',
        code: 'token_save_failed',
      );
    }
  }

  @override
  Future<AuthTokenModel?> getToken() async {
    try {
      final tokenJson = await storage.read(key: _tokenKey);
      if (tokenJson == null) return null;

      final token = AuthTokenModel.fromJson(
        json.decode(tokenJson) as Map<String, dynamic>,
      );

      if (!token.isValid) {
        await deleteToken();
        return null;
      }

      return token;
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to read token',
        code: 'token_read_failed',
      );
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await storage.delete(key: _tokenKey);
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to delete token',
        code: 'token_delete_failed',
      );
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await storage.write(
        key: _userKey,
        value: json.encode(user.toJson()),
      );

      // Save shipping and billing info if available
      if (user.shipping != null) {
        await saveShippingInfo(user.shipping!);
      }
      if (user.billing != null) {
        await saveBillingInfo(user.billing!);
      }
    } catch (e) {
      print('Failed to save user data: $e');
      throw const CacheFailure(
        message: 'Failed to save user data',
        code: 'user_save_failed',
      );
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final userJson = await storage.read(key: _userKey);
      if (userJson == null) return null;

      return UserModel.fromJson(
        json.decode(userJson) as Map<String, dynamic>,
      );
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to read user data',
        code: 'user_read_failed',
      );
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await storage.delete(key: _userKey);
      // Also clear shipping and billing info
      await billingBox.clear();
      await shippingBox.clear();
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to delete user data',
        code: 'user_delete_failed',
      );
    }
  }

  @override
  Future<void> saveShippingInfo(Map<String, dynamic> shipping) async {
    try {
      final model = ShippingInfoModel(
        firstName: shipping['first_name'] ?? '',
        lastName: shipping['last_name'] ?? '',
        phone: shipping['phone'] ?? '',
        address: shipping['address_1'] ?? '',
        city: shipping['city'] ?? '',
        state: shipping['state'] ?? '',
        zip: shipping['postcode'] ?? '',
      );
      await shippingBox.put('shipping_info', model);
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to save shipping info',
        code: 'shipping_save_failed',
      );
    }
  }

  @override
  Future<void> saveBillingInfo(Map<String, dynamic> billing) async {
    try {
      final model = BillingInfoModel(
        firstName: billing['first_name'] ?? '',
        lastName: billing['last_name'] ?? '',
        email: billing['email'] ?? '',
        phone: billing['phone'] ?? '',
        address: billing['address_1'] ?? '',
        city: billing['city'] ?? '',
        state: billing['state'] ?? '',
        zip: billing['postcode'] ?? '',
      );
      await billingBox.put('billing_info', model);
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to save billing info',
        code: 'billing_save_failed',
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getShippingInfo() async {
    try {
      final model = shippingBox.get('shipping_info');
      if (model == null) return null;

      return {
        'first_name': model.firstName,
        'last_name': model.lastName,
        'phone': model.phone,
        'address_1': model.address,
        'city': model.city,
        'state': model.state,
        'postcode': model.zip,
      };
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to read shipping info',
        code: 'shipping_read_failed',
      );
    }
  }

  @override
  Future<Map<String, dynamic>?> getBillingInfo() async {
    try {
      final model = billingBox.get('billing_info');
      if (model == null) return null;

      return {
        'first_name': model.firstName,
        'last_name': model.lastName,
        'email': model.email,
        'phone': model.phone,
        'address_1': model.address,
        'city': model.city,
        'state': model.state,
        'postcode': model.zip,
      };
    } catch (e) {
      throw const CacheFailure(
        message: 'Failed to read billing info',
        code: 'billing_read_failed',
      );
    }
  }
}
