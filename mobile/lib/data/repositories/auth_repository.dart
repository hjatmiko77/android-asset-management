import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:asset_management/data/datasources/remote/api_client.dart';
import 'package:asset_management/data/models/user_model.dart';

class AuthRepository {
  final ApiClient apiClient;
  final FlutterSecureStorage secureStorage;

  AuthRepository({
    required this.apiClient,
    required this.secureStorage,
  });

  Future<UserModel> login(String username, String password) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        await secureStorage.write(
          key: 'auth_token',
          value: response.data['access_token'],
        );
        await secureStorage.write(
          key: 'refresh_token',
          value: response.data['refresh_token'] ?? '',
        );

        // Fetch user data
        final userResponse = await apiClient.get('/users/me');
        return UserModel.fromJson(userResponse.data);
      }
      throw Exception('Login failed');
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required String fullname,
  }) async {
    try {
      final response = await apiClient.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'fullname': fullname,
          'role': 'user',
        },
      );

      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      }
      throw Exception('Registration failed');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await secureStorage.delete(key: 'auth_token');
      await secureStorage.delete(key: 'refresh_token');
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'auth_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
