import 'package:permission_handler/permission_handler.dart';
import 'permission_service.dart';

class PermissionService {
  PermissionService._();
  static final PermissionService instance = PermissionService._();

  Future<AppPermissionStatus> checkStatus(AppPermission permission) async {
    final status = await _mapPermission(permission).status;
    return _mapStatus(status);
  }

  Future<AppPermissionStatus> request(AppPermission permission) async {
    final status = await _mapPermission(permission).request();
    return _mapStatus(status);
  }

  Future<Map<AppPermission, AppPermissionStatus>> requestMultiple(
      List<AppPermission> permissions) async {
    final phPermissions = permissions.map(_mapPermission).toList();
    final results = await phPermissions.request();
    return {
      for (final entry in results.entries)
        _reverseMapPermission(entry.key): _mapStatus(entry.value),
    };
  }

  Future<bool> openSettings() async {
    return openAppSettings();
  }

  AppPermission _reverseMapPermission(Permission permission) {
    if (permission == Permission.camera) return AppPermission.camera;
    if (permission == Permission.photos) return AppPermission.photos;
    if (permission == Permission.storage) return AppPermission.storage;
    if (permission == Permission.location) return AppPermission.location;
    if (permission == Permission.microphone) return AppPermission.microphone;
    return AppPermission.camera;
  }

  AppPermissionStatus _mapStatus(PermissionStatus status) {
    if (status == PermissionStatus.granted) return AppPermissionStatus.granted;
    if (status == PermissionStatus.denied) return AppPermissionStatus.denied;
    if (status == PermissionStatus.permanentlyDenied) return AppPermissionStatus.permanentlyDenied;
    if (status == PermissionStatus.limited) return AppPermissionStatus.limited;
    return AppPermissionStatus.denied;
  }

  Permission _mapPermission(AppPermission permission) {
    if (permission == AppPermission.camera) return Permission.camera;
    if (permission == AppPermission.photos) return Permission.photos;
    if (permission == AppPermission.storage) return Permission.storage;
    if (permission == AppPermission.location) return Permission.location;
    if (permission == AppPermission.microphone) return Permission.microphone;
    return Permission.camera;
  }
}
