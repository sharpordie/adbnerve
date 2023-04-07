import 'dart:io';

import 'package:adbnerve/adbnerve.dart';
import 'package:adbnerve/src/device.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

late final String address;
late final Mobile android;

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    android = Mobile(address = '192.168.1.50');
    await android.runAttach();
  });

  tearDownAll(() async {
    // await android.runDetach();
  });

  test('setLanguage()', () async {
    final payload = DeviceLanguage.frFr;
    await android.setLanguage(payload);
    final results = (await android.runInvoke(['shell', 'getprop persist.sys.locale'])).stdout.trim();
    expect(results, payload.payload);
  });
}

class FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }
}
