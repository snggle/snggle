import 'package:snuggle/config/locator.dart';
import 'package:snuggle/infra/repositories/initial_repository.dart';

class InitialService {
  final InitialRepository _initialRepository = globalLocator<InitialRepository>();

  Future<bool> checkSetup() async {
    return _initialRepository.checkSetup();
  }
}
