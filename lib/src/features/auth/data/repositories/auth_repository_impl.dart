import 'package:chato/src/imports/core_imports.dart';
import 'package:chato/src/imports/packages_imports.dart';

import 'package:chato/src/features/auth/domain/entities/user.dart';
import 'package:chato/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService = AuthService.instance;

  AppUser _mapToUser(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'] as String? ?? '',
      email: data['email'] as String? ?? '',
      name: data['name'] as String?,
      photoUrl: data['photoUrl'] as String?,
    );
  }

  @override
  Stream<AppUser?> get onAuthStateChanged {
    return _authService.authStateChanges.map((userData) {
      if (userData == null) return null;
      return _mapToUser(userData);
    });
  }

  @override
  FutureEither<AppUser> login({
    required String email,
    required String password,
  }) async {
    final result = await _authService.login(email: email, password: password);

    return result.flatMap((userData) {
      if (userData == null) {
        return left(const ServerFailure('Login failed: User record not found'));
      }
      return right(_mapToUser(userData));
    });
  }

  @override
  FutureEither<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await _authService.signUp(
      name: name,
      email: email,
      password: password,
    );

    return result.flatMap((userData) {
      if (userData == null) {
        return left(const ServerFailure('Sign up failed: User record corrupted'));
      }
      return right(_mapToUser(userData));
    });
  }

  @override
  FutureEither<void> forgotPassword({required String email}) {
    return _authService.forgotPassword(email: email);
  }

  @override
  FutureEither<void> logout() {
    return _authService.logout();
  }

  @override
  FutureEither<AppUser?> checkAuthState() async {
    final result = await _authService.getCurrentUser();

    return result.map((userData) {
      if (userData == null) return null;
      return _mapToUser(userData);
    });
  }
}
