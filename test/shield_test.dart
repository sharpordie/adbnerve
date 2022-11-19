import 'dart:io';

import 'package:adbnerve/adbnerve.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

late final String address;
late final Shield android;

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    android = Shield(address = '192.168.1.50');
    await android.attach();
  });

  tearDownAll(() async {
    await android.detach();
  });

  test('changeDialect()', () async {
    // ...
  }, skip: 'not implemented yet');
}

class FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }
}
