import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';

@pragma('vm:entry-point')
Future<void> passkeyProviderMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  initLocator();
  await globalLocator<IsarDatabaseManager>().initDatabase();

  final MethodChannel channel = const MethodChannel('snggle/passkey_provider')

  ..setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'getPasskeys':
        return const <Map<String, dynamic>>[];

      default:
        throw MissingPluginException(
          'Method ${call.method} is not implemented',
        );
    }
  });
}