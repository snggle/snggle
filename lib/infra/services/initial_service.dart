import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/commons_repository.dart';

class InitialService {
  final CommonRepository _commonsRepository = globalLocator<CommonRepository>();

  Future<bool> checkInitialVisibleSetup() async {
    bool isInitialSetupExist = await _commonsRepository.isInitialSetupVisibleExist();
    if (isInitialSetupExist == true) {
      bool getSetupValue = await _commonsRepository.getInitialSetupVisible();
      return getSetupValue;
    } else {
      await _commonsRepository.setInitialSetupVisible(value: true);
      return true;
    }
  }
}
