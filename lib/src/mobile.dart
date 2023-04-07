import 'package:adbnerve/src/device.dart';

class Mobile extends Device {
  const Mobile(super.name, {super.port, super.code});

  Future<void> setLanguage(DeviceLanguage payload) async {
    final current = (await runInvoke(['shell', 'getprop persist.sys.locale'])).stdout.trim();
    if (current != payload.payload) {
      await runInvoke(['shell', 'am start -a android.settings.LOCALE_SETTINGS']);
      await runSelect('//*[@text="${payload.content}"]');
      await runRepeat('keycode_back');
    }
  }
}
