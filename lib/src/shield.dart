import 'package:adbnerve/src/device.dart';

enum ShieldResolution {
  p1080DolbyHz23('', ['1080', '23.976', true]),
  p1080DolbyHz59('', ['1080', '59.940', true]),
  p1080Hdr10Hz23('', ['1080', '23.976', false]),
  p1080Hdr10Hz59('', ['1080', '59.940', false]),
  p2160DolbyHz23('', ['4K', '23.976', true]),
  p2160DolbyHz59('', ['4K', '59.940', true]),
  p2160Hdr10Hz23('', ['4K', '23.976', false]),
  p2160Hdr10Hz59('', ['4K', '59.940', false]),
  ;

  const ShieldResolution(this.content, this.payload);

  final String content;
  final List payload;
}

enum ShieldUpscaling {
  none('Default', []),
  basic('Basic', ['Basic', '']),
  enhanced('Enhanced', ['Enhanced', '']),
  aiLow('AI Low', ['AI-Enhanced', 'Low']),
  aiMedium('AI Medium', ['AI-Enhanced', 'Medium (default)']),
  aiHigh('AI High', ['AI-Enhanced', 'High']),
  ;

  const ShieldUpscaling(this.content, this.payload);

  final String content;
  final List<String> payload;
}

class Shield extends Device {
  const Shield(super.name, {super.port, super.code});

  Future<void> setLanguage(DeviceLanguage payload) async {
    if (await getLocale() != payload.payload) {
      await runReveal(DeviceSetting.tvLanguageActivity);
      await runSelect('//*[@text="${payload.content}"]');
      await runRepeat('keycode_back');
    }
  }

  Future<void> setResolution(ShieldResolution payload) async {
    await setLanguage(DeviceLanguage.enUs);
  }

  Future<void> setUpscaling(ShieldUpscaling payload) async {
    throw UnimplementedError();
  }
}
