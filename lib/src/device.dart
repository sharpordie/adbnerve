import 'package:adbnerve/adbnerve.dart';
import 'package:adbnerve/src/shared.dart';

class Device extends Shared {
  const Device(super.address, {super.port, super.code});

  Future<void> changeDialect(Dialect payload) async {
    final current = (await invoke(['shell', 'getprop persist.sys.locale'])).stdout.trim();
    if (current != payload.compact) {
      await invoke(['shell', 'am start -a android.settings.LOCALE_SETTINGS']);
      await select('//*[@text="${payload.content}"]');
      await repeat('keycode_back');
    }
  }
}
