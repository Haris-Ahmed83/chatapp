import 'permission_service.dart';

class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();

  Future<AppPermissionStatus> checkStatus(AppPermission permission) async {
    return AppPermissionStatus.granted;
  }

  Future<AppPermissionStatus> request(AppPermission permission) async {
    return AppPermissionStatus.granted;
  }

  Future<Map<AppPermission, AppPermissionStatus>> requestMultiple(
      List<AppPermission> permissions) async {
    return {for (final p in permissions) p: AppPermissionStatus.granted};
  }

  Future<bool> openSettings() async {
    return false;
  }
}
