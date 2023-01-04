import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/settings_repository.dart';

class SettingsService {
  final SettingsRepository _settingsRepository = globalLocator<SettingsRepository>();

  Future<bool> checkInitialSetupVisible() async {
    bool isInitialSetupExist = await _settingsRepository.isInitialSetupVisibleExist();
    if (isInitialSetupExist == true) {
      bool getSetupValue = await _settingsRepository.getInitialSetupVisible();
      return getSetupValue;
    } else {
      await _settingsRepository.setInitialSetupVisible(value: true);
      return true;
    }
  }
}
