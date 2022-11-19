import 'package:adbnerve/adbnerve.dart';
import 'package:adbnerve/src/shared.dart';

class Shield extends Shared {
  const Shield(super.address, {super.port, super.code});

  Future<void> changeDialect(Dialect payload) async {
    final current = (await invoke(['shell', 'getprop persist.sys.locale'])).stdout.trim();
    if (current != payload.compact) {
      await invoke(['shell', 'am start -n com.android.tv.settings/.system.LanguageActivity']);
      await select('//*[@text="${payload.content}"]');
      await repeat('keycode_back');
    }
  }
}
