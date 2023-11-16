import 'package:auto_route/auto_route.dart';
import 'package:snggle/views/pages/app_auth_page.dart';
import 'package:snggle/views/pages/app_setup_pin_page.dart';
import 'package:snggle/views/pages/bottom_navigation/apps_page.dart';
import 'package:snggle/views/pages/bottom_navigation/bottom_navigation_wrapper.dart';
import 'package:snggle/views/pages/bottom_navigation/secrets_page.dart';
import 'package:snggle/views/pages/bottom_navigation/settings_page.dart';
import 'package:snggle/views/pages/bottom_navigation/vault_list_page.dart';
import 'package:snggle/views/pages/complete_scan_page.dart';
import 'package:snggle/views/pages/qr_code_scan_page.dart';
import 'package:snggle/views/pages/splash_page.dart';

@MaterialAutoRouter(replaceInRouteName: 'Page,Route', routes: <AutoRoute>[
  AutoRoute<void>(
    page: SplashPage,
    initial: true,
  ),
  AutoRoute<void>(
    page: AppSetupPinPage,
  ),
  AutoRoute<void>(
    page: AppAuthPage,
  ),
  AutoRoute<void>(
    page: BottomNavigationWrapper,
    name: 'BottomNavigationRoute',
    maintainState: true,
    children: <AutoRoute>[
      AutoRoute<void>(page: VaultListPage),
      AutoRoute<void>(page: SecretsPage),
      AutoRoute<void>(page: AppsPage),
      AutoRoute<void>(page: SettingsPage),
    ],
  ),
  AutoRoute<void>(
    page: QrCodeScanPage,
  ),
  AutoRoute<void>(
    page: CompleteScanPage,
  ),
])
class $AppRouter {}
