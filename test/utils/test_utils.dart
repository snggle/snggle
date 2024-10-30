import 'package:snggle/config/locator.dart';
import 'package:snggle/shared/controllers/password_controller.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

const String kEmptyString = '';

class TestUtils {
  static void mockPasswords(FilesystemPath filesystemPath, List<PasswordModel> passwords) {
    List<String> parts = filesystemPath.pathSegments;
    for (int i = parts.length - 1; i > 0; i--) {
      String subPath = parts.sublist(0, i).join('/');
      globalLocator<PasswordController>().addPassword(
        passwords[i],
        FilesystemPath.fromString(subPath),
      );
    }
  }

  static void printInfo(String message) {
    // ignore: avoid_print
    print('\x1B[34m$message\x1B[0m');
  }

  static void printError(String message) {
    // ignore: avoid_print
    print('\x1B[31m$message\x1B[0m');
  }
}
