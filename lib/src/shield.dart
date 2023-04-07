import 'package:adbnerve/src/device.dart';
import 'package:format/format.dart';

enum ShieldResolution {
  p1080DolbyHz23('', ['1080', '23.976', true]),
  p1080DolbyHz59('', ['1080', '59.940', true]),
  p2160DolbyHz23('', ['4K', '23.976', true]),
  p2160DolbyHz59('', ['4K', '59.940', true]),
  p1080Hdr10Hz23('', ['1080', '23.976', false]),
  p1080Hdr10Hz59('', ['1080', '59.940', false]),
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
    await runReveal(DeviceSetting.tvMainSettings);
    await runSelect('//*[@text="Device Preferences"]');
    await runSelect('//*[@text="Display & Sound"]');
    await runSelect('//*[@text="Resolution"]');
    final shaping = "//*[contains(@text, '{}') and contains(@text, '{}') and contains(@text, '{}')]";
    final factors = [payload.payload[0], payload.payload[1], payload.payload[2] ? 'Vision' : 'Hz'];
    final pattern = shaping.format(factors) + "/parent::*/parent::*/node[1]";
    final element = await runScrape(pattern);
    if (element != null) {
      if (element.attributes['checked'] == 'true') {
        await runRepeat('keycode_back');
      } else {
        await runSelect(pattern);
        await runRepeat('keycode_dpad_right', repeats: 5);
        await runRepeat('keycode_dpad_up', repeats: 5);
        await runRepeat('keycode_enter');
      }
      await runSelect('//*[@text="Advanced display settings"]');
      final pattern2 = '//*[@text="Match content color space"]/parent::*/following-sibling::*/node';
      final element2 = await runScrape(pattern2);
      if (element2 != null) {
        final checked = element2.attributes['checked'] == 'true';
        final correct = (checked && payload.payload[2]) || (checked == false && payload.payload[2] == false);
        if (correct == false) {
          await runSelect(pattern2);
        }
      }
      await runRepeat('keycode_home');
    }
  }

  Future<void> setUpscaling(ShieldUpscaling payload) async {
    throw UnimplementedError();
  }
}
