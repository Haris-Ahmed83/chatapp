import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utils.dart';

class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  SharedPreferences? _webFallback;

  Future<void> init() async {
    if (kIsWeb) {
      _webFallback = await SharedPreferences.getInstance();
    }
  }

  FutureEither<void> write(String key, String value) async {
    return runTask(() async {
      if (kIsWeb) {
        await _webFallback!.setString(key, value);
      } else {
        await const FlutterSecureStorage().write(key: key, value: value);
      }
    });
  }

  FutureEither<String?> read(String key) async {
    return runTask(() async {
      if (kIsWeb) {
        return _webFallback!.getString(key);
      }
      return await const FlutterSecureStorage().read(key: key);
    });
  }

  FutureEither<void> delete(String key) async {
    return runTask(() async {
      if (kIsWeb) {
        await _webFallback!.remove(key);
      } else {
        await const FlutterSecureStorage().delete(key: key);
      }
    });
  }

  FutureEither<void> deleteAll() async {
    return runTask(() async {
      if (kIsWeb) {
        await _webFallback!.clear();
      } else {
        await const FlutterSecureStorage().deleteAll();
      }
    });
  }

  FutureEither<bool> containsKey(String key) async {
    return runTask(() async {
      if (kIsWeb) {
        return _webFallback!.containsKey(key);
      }
      return await const FlutterSecureStorage().containsKey(key: key);
    });
  }
}
