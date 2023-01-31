import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/settings_repository.dart';

class SettingsService {
  final SettingsRepository _settingsRepository = globalLocator<SettingsRepository>();

  Future<bool> isSetupPinVisible() async {
    bool setupPinExistBool = await _settingsRepository.isSetupPinExist();

    if (setupPinExistBool == true) {
      bool setupPinVisibleBool = await _settingsRepository.isSetupPinVisible();
      return setupPinVisibleBool;
    } else {
      await setSetupPinVisible(value: true);
      return true;
    }
  }

  Future<void> setSetupPinVisible({required bool value}) async {
    await _settingsRepository.setSetupPinVisible(value: value);
  }
}
