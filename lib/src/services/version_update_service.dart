import 'package:app_version_update/data/models/app_version_result.dart';

import '../imports/imports.dart';

class VersionUpdateService {
  VersionUpdateService._();
  static final VersionUpdateService instance = VersionUpdateService._();

  FutureEither<AppVersionResult?> checkForUpdate({
    String? appleId,
    String? playStoreId,
  }) async {
    return runTask(() async {
      if (kIsWeb) return null;
      return await AppVersionUpdate.checkForUpdates(
        appleId: appleId,
        playStoreId: playStoreId,
      );
    }, requiresNetwork: true);
  }

  FutureEither<void> checkAndShowUpdate({
    String? appleId,
    String? playStoreId,
    bool mandatory = false,
  }) async {
    return runTask(() async {
      if (kIsWeb) return;

      final result = await AppVersionUpdate.checkForUpdates(
        appleId: appleId,
        playStoreId: playStoreId,
      );

      if (result.canUpdate ?? false) {
        final ctx = rootContext;
        if (ctx == null) {
          AppLogger.warning('Cannot show update dialog: rootContext is null');
          return;
        }

        if (ctx.mounted) {
          AppVersionUpdate.showAlertUpdate(
            appVersionResult: result,
            context: ctx,
            mandatory: mandatory,
          );
        }
      }
    }, requiresNetwork: true);
  }

  FutureEither<void> showUpdateAlert({
    required AppVersionResult updateResult,
    bool mandatory = false,
    String? title,
    String? content,
    String? cancelText,
    String? updateText,
  }) async {
    return runTask(() async {
      final ctx = rootContext;
      if (ctx == null) return;

      AppVersionUpdate.showAlertUpdate(
        appVersionResult: updateResult,
        context: ctx,
        mandatory: mandatory,
        title: title ?? 'New version available',
        content: content ?? 'Would you like to update your application?',
        cancelButtonText: cancelText ?? 'UPDATE LATER',
        updateButtonText: updateText ?? 'UPDATE',
      );
    });
  }
}
