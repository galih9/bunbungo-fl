import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DeviceInfoHelper {
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final Map<String, dynamic> data = {
      'platform': defaultTargetPlatform.name,
      'isWeb': kIsWeb,
    };

    if (kIsWeb) {
      data['operatingSystem'] = 'web';
      data['deviceModel'] = 'Web Browser';
      try {
        final plugin = DeviceInfoPlugin();
        final web = await plugin.webBrowserInfo;
        data['browser'] = web.browserName.name;
        data['userAgent'] = web.userAgent;
        data['vendor'] = web.vendor;
      } catch (_) {}
      return data;
    }

    try {
      data['operatingSystem'] = Platform.operatingSystem;
      data['operatingSystemVersion'] = Platform.operatingSystemVersion;
      data['hostname'] = Platform.localHostname;
    } catch (_) {}

    final isWidgetTest = WidgetsBinding.instance.runtimeType
        .toString()
        .contains('TestWidgetsFlutterBinding');
    if (isWidgetTest) {
      data['deviceModel'] = data['hostname'] ?? defaultTargetPlatform.name;
      return data;
    }

    try {
      final plugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final android = await plugin.androidInfo.timeout(const Duration(milliseconds: 300));
        data['deviceModel'] = '${android.manufacturer} ${android.model}';
        data['brand'] = android.brand;
        data['product'] = android.product;
        data['sdkInt'] = android.version.sdkInt;
        data['release'] = android.version.release;
      } else if (Platform.isIOS) {
        final ios = await plugin.iosInfo.timeout(const Duration(milliseconds: 300));
        data['deviceModel'] = ios.utsname.machine;
        data['name'] = ios.name;
        data['systemName'] = ios.systemName;
        data['systemVersion'] = ios.systemVersion;
        data['localizedModel'] = ios.localizedModel;
      } else if (Platform.isMacOS) {
        final mac = await plugin.macOsInfo.timeout(const Duration(milliseconds: 300));
        data['deviceModel'] = mac.model;
        data['computerName'] = mac.computerName;
        data['osRelease'] = mac.osRelease;
        data['arch'] = mac.arch;
      } else if (Platform.isWindows) {
        final win = await plugin.windowsInfo.timeout(const Duration(milliseconds: 300));
        data['deviceModel'] = win.computerName;
        data['productName'] = win.productName;
        data['buildNumber'] = win.buildNumber;
      } else if (Platform.isLinux) {
        final linux = await plugin.linuxInfo.timeout(const Duration(milliseconds: 300));
        data['deviceModel'] = linux.name;
        data['version'] = linux.version;
        data['prettyName'] = linux.prettyName;
      }
    } catch (_) {
      // In tests or if platform channels throw, fallback gracefully
      data['deviceModel'] = data['hostname'] ?? defaultTargetPlatform.name;
    }

    if (data['deviceModel'] == null || data['deviceModel'].toString().trim().isEmpty) {
      data['deviceModel'] = data['hostname'] ?? defaultTargetPlatform.name;
    }

    return data;
  }

  static String formatDeviceSummary(Map<String, dynamic>? info) {
    if (info == null || info.isEmpty) return 'Unknown Device';
    final model = info['deviceModel'] ??
        info['model'] ??
        info['computerName'] ??
        info['name'] ??
        info['hostname'];
    final os = info['operatingSystem'] ?? info['platform'] ?? '';
    final osVer = info['release'] ??
        info['systemVersion'] ??
        info['operatingSystemVersion'] ??
        '';

    final String osShort = osVer.toString().split(' ').first;

    if (model != null && model.toString().isNotEmpty) {
      if (os.toString().isNotEmpty) {
        return osShort.isNotEmpty ? '$model ($os $osShort)' : '$model ($os)';
      }
      return model.toString();
    }
    return '$os $osShort'.trim();
  }
}
