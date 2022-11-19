import 'dart:io';

import 'package:adbnerve/adbnerve.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

late final String address;
late final Device android;

void main() {
  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
    android = Device(address = '192.168.1.50');
    await android.attach();
  });

  tearDownAll(() async {
    await android.detach();
  });

  test('accord()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('attach()', () async {
    await android.attach();
  });

  test('bridge()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('create()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('deploy()', () async {
    final program = await android.deploy();
    final content = (await Process.run(program, ['--version'])).stdout;
    expect(content.isEmpty, false);
  });

  test('detach()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('enable()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('escape()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('export()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('finish()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('import()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('insert()', () async {
    // await android.insert("anonymous@example.org");
  }, skip: 'not fully implemented yet');

  test('invoke()', () async {
    expect((await android.invoke(['shell', 'echo dummy'])).stdout.trim(), 'dummy');
  });

  test('launch()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('locate()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('reboot()', () async {
    await android.reboot();
    expect((await android.invoke(['shell', 'echo dummy'])).stdout.trim(), 'dummy');
  });

  test('remove()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('render()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('repeat()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('scrape()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('search()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('select()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('unpack()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('update()', () async {
    // ...
  }, skip: 'not implemented yet');

  test('vanish()', () async {
    // ...
  }, skip: 'not implemented yet');
}

class FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }
}
