import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../utils/utils.dart';

class DeviceInfoService {
  DeviceInfoService._();
  static final DeviceInfoService instance = DeviceInfoService._();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  FutureEither<Map<String, dynamic>> getFullDeviceInfo() async {
    return runTask(() async {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        return {
          'platform': 'web',
          'vendor': webInfo.vendor,
          'vendorSub': webInfo.vendorSub,
          'userAgent': webInfo.userAgent,
          'appName': webInfo.appName,
          'appVersion': webInfo.appVersion,
          'language': webInfo.language,
        };
      }

      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'version': androidInfo.version.release,
          'sdkInt': androidInfo.version.sdkInt,
          'id': androidInfo.id,
          'isPhysicalDevice': androidInfo.isPhysicalDevice,
        };
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'name': iosInfo.name,
          'model': iosInfo.model,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
          'identifierForVendor': iosInfo.identifierForVendor,
          'isPhysicalDevice': iosInfo.isPhysicalDevice,
        };
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        final macInfo = await _deviceInfo.macOsInfo;
        return {
          'computerName': macInfo.computerName,
          'hostName': macInfo.hostName,
          'model': macInfo.model,
          'osRelease': macInfo.osRelease,
        };
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        final winInfo = await _deviceInfo.windowsInfo;
        return {
          'computerName': winInfo.computerName,
          'numberOfCores': winInfo.numberOfCores,
          'systemMemoryInMegabytes': winInfo.systemMemoryInMegabytes,
        };
      }
      return {'platform': 'unknown'};
    });
  }
}
