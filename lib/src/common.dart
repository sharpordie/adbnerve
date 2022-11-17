import 'dart:io';

import 'package:adbnerve/adbnerve.dart';
import 'package:adbready/adbready.dart';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:xpath_selector/xpath_selector.dart';
import 'package:xpath_selector_xml_parser/xpath_selector_xml_parser.dart';

abstract class Common {
  const Common(this.address, {this.port, this.code});

  final String address;

  final String? code;

  final String? port;

  Future<void> accord(String package, String consent) async {
    await invoke(['shell', 'pm grant \'$package\' android.permission.${consent.toUpperCase()}']);
  }

  Future<void> attach() async {
    var content = (await invoke(['connect', address])).stdout;
    if (content.contains('cann')) {
      throw Exception('Specified address is invalid');
    } else if (content.contains('down')) {
      throw Exception('Connected machine has not started yet');
    } else if (content.contains('empt')) {
      throw Exception('Specified address is empty');
    } else if (content.contains('esol')) {
      throw Exception('Specified address is not reachable');
    } else if (content.contains('fuse')) {
      throw Exception('Connected machine is not android-based');
    } else if (content.contains('rout')) {
      throw Exception('Specified address is not reachable');
    } else if (content.contains('fail')) {
      throw const AuthorizationRequiredException();
    } else {
      content = (await invoke(['shell', 'uname'])).stderr;
      if (content.contains('unau')) {
        final android = p.join((await getApplicationSupportDirectory()).path, ".android");
        await invoke(['kill-server']);
        if (await Directory(android).exists()) await Directory(android).delete(recursive: true);
        await attach();
      }
    }
  }

  Future<void> bridge() async {
    final content = (await invoke(['pair', '$address:$port', code ?? ''])).stdout;
    if (content.contains('rong')) throw Exception('Specified pairing code is invalid');
  }

  Future<void> create(String distant) async {
    final command = ['shell', 'mkdir -p "\$(dirname "$distant")" ; touch "$distant"'];
    await invoke(command);
  }

  Future<String> deploy() async {
    if (Platform.isAndroid) {
      return await Adbready().deploy();
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final command = Platform.isWindows ? 'where' : 'which';
      final content = (await Process.run(command, ['adb'])).stdout.trim();
      if (content.isNotEmpty) return content;
      final deposit = (await getTemporaryDirectory()).path;
      const usagent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/500.0 (KHTML, like Gecko) Chrome/100.0.0.0 Safari/500.0';
      final fetcher = Dio()
        ..options.followRedirects = true
        ..options.headers = {'user-agent': usagent};
      final program = File(p.join(deposit, 'platform-tools', 'adb'));
      if (await program.exists() == false) {
        const baseurl = 'https://dl.google.com/android/repository';
        final payload = Platform.isLinux ? 'linux' : (Platform.isMacOS ? 'darwin' : 'windows');
        final address = '$baseurl/platform-tools-latest-$payload.zip';
        final archive = p.join(deposit, p.basename(address));
        await fetcher.download(address, archive);
        await extractFileToDisk(archive, deposit);
      }
      if (Platform.isLinux || Platform.isMacOS) {
        await Process.run('chmod', ['-R', '+x', program.parent.path]);
      }
      return program.path;
    } else {
      throw const UnsupportedPlatformException();
    }
  }

  Future<void> detach() async {
    await invoke(['disconnect', address]);
    await invoke(['kill-server']);
  }

  Future<void> enable(String package, {bool enabled = true}) async {
    final payload = enabled ? 'enable' : 'disable-user --user 0';
    await invoke(['shell', 'pm $payload "$package"']);
  }

  Future<void> escape() async {
    for (int i = 0; i < 2; i++) {
      await repeat('keycode_back', repeats: 8);
    }
    await repeat('keycode_wakeup');
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> export(String storage, String distant) async {
    await invoke(['push', storage, distant]);
  }

  Future<void> finish(String package) async {
    final results = (await invoke(['shell', 'pm path "$package"'])).stdout;
    final present = results.isNotEmpty;
    if (present) {
      await invoke(['shell', 'sleep 2 ; am force-stop "$package" ; sleep 2']);
    }
  }

  Future<String?> import(String distant) async {
    final deposit = (await getTemporaryDirectory()).path;
    final created = p.join(deposit, p.basename(distant));
    await invoke(['pull', distant, created]);
    return (await File(created).exists() || await Directory(created).exists()) ? created : null;
  }

  Future<void> insert(String content, {bool cleared = false}) async {
    if (cleared) {
      await repeat('keycode_move_end');
      await repeat('keycode_del', repeats: 100);
    }
    // TODO: Make it much more robust.
    await invoke(['shell', 'input text \'$content\'']);
  }

  Future<ProcessResult> invoke(List<String> command) async {
    if (Platform.isAndroid) return await Adbready().invoke(command);
    return await Process.run(await deploy(), ['-s', address, ...command]);
  }

  Future<void> launch(String package) async {
    final results = await invoke(['shell', 'pm path "$package"']);
    final present = results.stdout.isNotEmpty;
    if (present) {
      await invoke(['shell', 'sleep 2 ; monkey -p "$package" 1 ; sleep 2']);
    }
  }

  Future<List<String>?> locate(String pattern) async {
    final element = await scrape(pattern);
    final content = element?.attributes['bounds'];
    if (content == null) return null;
    final matches = RegExp('\\d+').allMatches(content);
    return [
      matches.elementAt(0).group(0).toString(),
      matches.elementAt(1).group(0).toString(),
      matches.elementAt(2).group(0).toString(),
      matches.elementAt(3).group(0).toString(),
    ];
  }

  Future<void> reboot() async {
    await invoke(['shell', 'reboot']);
    await Future.delayed(const Duration(seconds: 4));
    while (true) {
      try {
        await attach();
        break;
      } on Exception {
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    await Future.delayed(const Duration(seconds: 8));
  }

  Future<void> remove(String distant) async {
    await invoke(['shell', 'rm -r $distant']);
  }

  Future<String> render() async {
    const command = ['shell', 'uiautomator dump'];
    const fetched = '/sdcard/window_dump.xml';
    const package = 'com.android.vending';
    while ((await invoke(command)).stderr.trim().isNotEmpty) {
      await remove(fetched);
      await launch(package);
      await invoke(command);
      await finish(package);
    }
    return (await import(fetched))!;
  }

  Future<void> repeat(String keycode, {int repeats = 1}) async {
    await invoke(['shell', "input keyevent \$(printf '${keycode.toUpperCase()} %.0s' \$(seq 1 $repeats))"]);
  }

  Future<XPathNode?> scrape(String pattern) async {
    await repeat('keycode_dpad_up', repeats: 100);
    var fetched = await render();
    XPathNode? element;
    while (element == null) {
      var scraped = XmlXPath.xml(await File(fetched).readAsString());
      element = scraped.query(pattern).node;
      if (element != null) continue;
      await repeat('keycode_dpad_down', repeats: 8);
      var stream1 = await File(fetched).readAsString();
      var stream2 = await File(fetched = await render()).readAsString();
      if (stream1 == stream2) break;
    }
    return element;
  }

  Future<List<String>?> search(String pattern, {int maximum = 1}) async {
    final results = await invoke(['shell', 'find $pattern -maxdepth 0 2>/dev/null | head -$maximum']);
    final content = results.stdout.trim();
    return content.isNotEmpty ? content.split("\n") : null;
  }

  Future<bool> select(String pattern) async {
    final results = await locate(pattern);
    if (results == null) return false;
    final x = (int.parse(results[0]) + int.parse(results[2])) / 2;
    final y = (int.parse(results[1]) + int.parse(results[3])) / 2;
    await invoke(['shell', 'input tap $x $y']);
    return true;
  }

  Future<void> unpack(String archive, String deposit) async {
    if (await File(archive).exists()) {
      final distant = p.join(deposit, p.basename(archive));
      await invoke(['shell', 'mkdir -p \'$deposit\'']);
      await export(archive, distant);
      await invoke(['shell', 'cd \'$deposit\' ; unzip -o \'$distant\'']);
      await remove(distant);
    }
  }

  Future<void> update(String package) async {
    if (await File(package).exists()) await invoke(['install', '-r', package]);
  }

  Future<void> vanish(String package) async {
    final results = (await invoke(['shell', 'pm path \'$package\''])).stdout;
    final present = results.isNotEmpty;
    if (present) {
      await finish(package);
      await invoke(['shell', 'pm uninstall \'$package\'']);
    }
  }
}
