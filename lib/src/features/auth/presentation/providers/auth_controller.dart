import 'package:chato/src/imports/core_imports.dart';
import 'package:chato/src/imports/packages_imports.dart';

import 'package:chato/src/features/auth/domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _repository;

  AuthController({required AuthRepository repository}) : _repository = repository;

  final isLoading = false.obs;

  Future<void> login({required BuildContext context, required String email, required String password}) async {
    isLoading.value = true;
    
    final result = await _repository.login(email: email, password: password);
    
    isLoading.value = false;
    result.fold(
      (failure) {
        if (context.mounted) {
          showToast(context, message: failure.message, status: 'error');
        }
      },
      (user) {
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  Future<void> signUp({required BuildContext context, required String name, required String email, required String password}) async {
    isLoading.value = true;
    
    final result = await _repository.signUp(name: name, email: email, password: password);
    
    isLoading.value = false;
    result.fold(
      (failure) {
        if (context.mounted) {
          showToast(context, message: failure.message, status: 'error');
        }
      },
      (user) {
        Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  Future<void> forgotPassword({required BuildContext context, required String email}) async {
    isLoading.value = true;
    
    final result = await _repository.forgotPassword(email: email);
    
    isLoading.value = false;
    result.fold(
      (failure) {
        if (context.mounted) {
          showToast(context, message: failure.message, status: 'error');
        }
      },
      (success) {
        if (context.mounted) {
          showToast(context, message: 'Password reset link sent successfully', status: 'success');
        }
        Get.offNamed(AppRoutes.login);
      },
    );
  }
}

