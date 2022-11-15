class TestUtils {
  static void printTitle(String title, String message) {
    // ignore: avoid_print
    print('\x1B[33m$title\x1B[0m$message');
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
