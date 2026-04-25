import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._dio);

  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login/', data: {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        final accessToken = data['access'];
        final refreshToken = data['refresh'];
        final userData = data['user'];

        await _storage.write(key: 'access_token', value: accessToken);
        await _storage.write(key: 'refresh_token', value: refreshToken);

        return UserModel.fromJson(userData);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<UserModel?> register({
    required String username,
    required String password,
    required String email,
    required UserRole role,
  }) async {
    try {
      final response = await _dio.post('/auth/register/', data: {
        'username': username,
        'password': password,
        'email': email,
        'role': role.name,
      });

      if (response.statusCode == 201) {
        // After registration, login to get tokens
        return await login(username, password);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<UserModel?> checkAuth() async {
    try {
      final token = await _storage.read(key: 'access_token');
      if (token == null) return null;

      final response = await _dio.get('/auth/check-auth/');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
    } catch (e) {
      // If token is invalid/expired
      await logout();
    }
    return null;
  }
}
