import 'package:asset_management/data/repositories/auth_repository.dart';
import 'package:asset_management/data/models/user_model.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<UserModel> call(String username, String password) {
    return repository.login(username, password);
  }
}

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<UserModel> call({
    required String username,
    required String email,
    required String password,
    required String fullname,
  }) {
    return repository.register(
      username: username,
      email: email,
      password: password,
      fullname: fullname,
    );
  }
}

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}

class IsLoggedInUsecase {
  final AuthRepository repository;

  IsLoggedInUsecase(this.repository);

  Future<bool> call() {
    return repository.isLoggedIn();
  }
}
