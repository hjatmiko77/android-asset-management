import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:asset_management/data/datasources/remote/api_client.dart';
import 'package:asset_management/data/repositories/auth_repository.dart';
import 'package:asset_management/data/models/user_model.dart';
import 'package:asset_management/domain/usecases/auth_usecases.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider((ref) => Dio());

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final apiClientProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return ApiClient(dio: dio, storage: storage);
});

final authRepositoryProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(secureStorageProvider);
  return AuthRepository(apiClient: apiClient, secureStorage: storage);
});

final loginUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUsecase(repository);
});

final registerUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(repository);
});

final logoutUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUsecase(repository);
});

final isLoggedInUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return IsLoggedInUsecase(repository);
});

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AsyncValue<UserModel?>>((ref) {
  return CurrentUserNotifier(ref);
});

class CurrentUserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;

  CurrentUserNotifier(this.ref) : super(const AsyncValue.loading()) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      state = const AsyncValue.loading();
      final isLoggedIn = ref.read(isLoggedInUsecaseProvider);
      final loggedIn = await isLoggedIn();
      if (loggedIn) {
        final apiClient = ref.read(apiClientProvider);
        final response = await apiClient.get('/users/me');
        final user = UserModel.fromJson(response.data);
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e) {
      state = AsyncValue.data(null);
    }
  }

  Future<void> login(String username, String password) async {
    try {
      state = const AsyncValue.loading();
      final usecase = ref.read(loginUsecaseProvider);
      final user = await usecase(username, password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    try {
      final usecase = ref.read(logoutUsecaseProvider);
      await usecase();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
