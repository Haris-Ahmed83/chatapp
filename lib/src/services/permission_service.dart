import 'permission_service_stub.dart'
    if (dart.library.io) 'permission_service_io.dart'
    if (dart.library.html) 'permission_service_web.dart';

enum AppPermission {
  camera._('camera'),
  photos._('photos'),
  storage._('storage'),
  location._('location'),
  microphone._('microphone');

  final String name;
  const AppPermission._(this.name);
}

enum AppPermissionStatus { granted, denied, permanentlyDenied, limited }
