import 'package:path_provider/path_provider.dart';
import '../utils/utils.dart';

class PathService {
  PathService._();
  static final PathService instance = PathService._();

  FutureEither<String> getDocumentsPath() async =>
      runTask(() async => (await getApplicationDocumentsDirectory()).path);

  FutureEither<String> getTempPath() async =>
      runTask(() async => (await getTemporaryDirectory()).path);

  FutureEither<String> getAppSupportPath() async =>
      runTask(() async => (await getApplicationSupportDirectory()).path);

  FutureEither<String> getAppLibraryPath() async =>
      runTask(() async => (await getLibraryDirectory()).path);

  FutureEither<String?> getExternalStoragePath() async =>
      runTask(() async => (await getExternalStorageDirectory())?.path);
}
