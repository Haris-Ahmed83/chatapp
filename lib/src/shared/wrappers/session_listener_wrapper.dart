import 'package:chato/src/imports/core_imports.dart';
import 'package:chato/src/imports/packages_imports.dart';

import 'package:chato/src/features/auth/presentation/providers/session_controller.dart';

class SessionListenerWrapper extends StatefulWidget {
  final Widget child;
  const SessionListenerWrapper({super.key, required this.child});

  @override
  State<SessionListenerWrapper> createState() => _SessionListenerWrapperState();
}

class _SessionListenerWrapperState extends State<SessionListenerWrapper> {
  Worker? _worker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = Get.find<SessionController>();
      _worker = ever(session.status, (status) {
        if (status != SessionStatus.unknown) {
          if (!kIsWeb) {
            FlutterNativeSplash.remove();
          }
          if (status == SessionStatus.authenticated) {
            Get.offAllNamed(AppRoutes.home);
          } else if (status == SessionStatus.unauthenticated) {
            Get.offAllNamed(AppRoutes.onboarding);
          }
        }
      }, condition: () => session.status.value != SessionStatus.unknown);
    });
  }

  @override
  void dispose() {
    _worker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
