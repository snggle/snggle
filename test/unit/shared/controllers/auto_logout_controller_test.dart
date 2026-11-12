import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/controllers/auto_logout_controller.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/router/router.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';

import '../../../utils/database_mock.dart';
import '../../../utils/test_database.dart';

void main() {
  TestWidgetsFlutterBinding testWidgetsFlutterBinding = TestWidgetsFlutterBinding.ensureInitialized();

  late TestDatabase testDatabase;
  late AppRouter appRouter;
  late AutoLogoutCubit autoLogoutCubit;
  late AutoLogoutController autoLogoutController;
  late ActiveWalletController activeWalletController;
  late WalletModel walletModel;

  bool controllerInitializedBool = false;

  setUp(() async {
    testWidgetsFlutterBinding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

    testDatabase = TestDatabase();
    await testDatabase.init(
      databaseMock: DatabaseMock.emptyDatabaseMock,
      appPasswordModel: PasswordModel.fromPlaintext('1111'),
    );

    appRouter = AppRouter();
    autoLogoutCubit = AutoLogoutCubit();
    await autoLogoutCubit.init();

    activeWalletController = globalLocator<ActiveWalletController>();
    walletModel = WalletModel(
      id: 1,
      encryptedBool: false,
      pinnedBool: false,
      address: '0x4BD51C77E08Ac696789464A079cEBeE203963Dce',
      derivationPath: "m/44'/60'/0'/0/0",
      filesystemPath: FilesystemPath.fromString('vaults/vault1/network1/wallet1'),
      name: 'WALLET 0',
    );
    activeWalletController.setActiveWallet(walletModel: walletModel);

    controllerInitializedBool = false;
    autoLogoutController = AutoLogoutController(
      appRouter: appRouter,
      appService: globalLocator<AppService>(),
      autoLogoutCubit: autoLogoutCubit,
    );
  });

  tearDown(() async {
    if (controllerInitializedBool) {
      autoLogoutController.dispose();
    }

    appRouter.dispose();
    await autoLogoutCubit.close();
    await testDatabase.close();
    await globalLocator.reset();

    testWidgetsFlutterBinding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  });

  void controllerTest(String description, Future<void> Function() testBody) {
    test(description, () {
      addTearDown(testWidgetsFlutterBinding.postTest);

      return testWidgetsFlutterBinding.runTest(
        () async {
          testWidgetsFlutterBinding.reset();
          try {
            await testBody();
          } finally {
            if (controllerInitializedBool) {
              autoLogoutController.dispose();
              controllerInitializedBool = false;
            }
          }
        },
        () {},
        description: description,
      );
    });
  }

  void initController() {
    autoLogoutController.init();
    controllerInitializedBool = true;
  }

  void disposeController() {
    if (controllerInitializedBool) {
      autoLogoutController.dispose();
      controllerInitializedBool = false;
    }
  }

  Future<void> enableInactivityLogout() async {
    await testWidgetsFlutterBinding.runAsync(
      () => autoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: true),
    );
    await testWidgetsFlutterBinding.pump();
  }

  Future<void> navigateToAuthenticatedRoute() async {
    await appRouter.replaceAll(<PageRouteInfo>[BottomNavigationRoute()]);
    expect(appRouter.stack, hasLength(1));
    expect(appRouter.stack.single.name, BottomNavigationRoute.name);
  }

  Future<void> pumpElapsed(Duration duration) async {
    await testWidgetsFlutterBinding.pump(duration);
    await testWidgetsFlutterBinding.pump();
  }

  void expectSessionPreserved() {
    expect(activeWalletController.hasActiveWallet, true);
    expect(activeWalletController.walletModel, walletModel);
  }

  void expectAppLoggedOut() {
    expect(activeWalletController.hasActiveWallet, false);
    expect(activeWalletController.walletModel, null);
    expect(appRouter.stack, hasLength(1));
    expect(appRouter.stack.single.name, SplashRoute.name);
  }

  group('Tests of AutoLogoutController.init()', () {
    controllerTest('Should [not start the timer] before the first authenticated route', () async {
      // Arrange
      await enableInactivityLogout();
      initController();

      // Act
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack, isEmpty);
    });

    controllerTest('Should [start the timer] after navigating from PIN authentication to the app', () async {
      // Arrange
      await enableInactivityLogout();
      await appRouter.replaceAll(<PageRouteInfo>[AppPinAuthRoute()]);
      initController();
      await pumpElapsed(const Duration(minutes: 6));
      expectSessionPreserved();

      // Act
      await navigateToAuthenticatedRoute();
      await pumpElapsed(const Duration(seconds: 59));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [logout after oneMinute] on an authenticated route', () async {
      // Arrange
      await enableInactivityLogout();
      await testWidgetsFlutterBinding.runAsync(() async {
        await autoLogoutCubit.setInactivityLogoutTimer(inactivityLogoutTimer: InactivityLogoutTimer.oneMinute);
      });
      await navigateToAuthenticatedRoute();

      // Act
      initController();
      await pumpElapsed(const Duration(minutes: 1) - const Duration(seconds: 1));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [logout after fiveMinutes] on an authenticated route', () async {
      // Arrange
      await enableInactivityLogout();
      await testWidgetsFlutterBinding.runAsync(() async {
        await autoLogoutCubit.setInactivityLogoutTimer(inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes);
      });
      await navigateToAuthenticatedRoute();

      // Act
      initController();
      await pumpElapsed(const Duration(minutes: 5) - const Duration(seconds: 1));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [keep inactivity logout disabled] by default', () async {
      // Arrange
      expect(autoLogoutCubit.state.inactivityLogoutEnabledBool, false);
      await navigateToAuthenticatedRoute();

      // Act
      initController();
      autoLogoutController.handleUserInteraction();
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.single.name, BottomNavigationRoute.name);
    });

    controllerTest('Should [not start the timer] while reading privacy policy on first launch', () async {
      // Arrange
      await enableInactivityLogout();
      await appRouter.replaceAll(<PageRouteInfo>[const SplashRoute(), const PrivacyPolicyRoute()]);
      initController();

      // Act
      autoLogoutController.handleUserInteraction();
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.last.name, PrivacyPolicyRoute.name);
    });

    controllerTest('Should [not start the timer] during removed MasterKey', () async {
      // Arrange
      await enableInactivityLogout();
      await appRouter.replaceAll(<PageRouteInfo>[const AppMasterKeyRemovedRoute()]);
      initController();

      // Act
      autoLogoutController.handleUserInteraction();
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.single.name, AppMasterKeyRemovedRoute.name);
    });

    controllerTest('Should [not start the timer] during MasterKey creation', () async {
      // Arrange
      await enableInactivityLogout();
      await appRouter.replaceAll(<PageRouteInfo>[const AppMasterKeyCreateRoute()]);
      initController();

      // Act
      autoLogoutController.handleUserInteraction();
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.single.name, AppMasterKeyCreateRoute.name);
    });

    controllerTest('Should [not start the timer] during MasterKey recovery', () async {
      // Arrange
      await enableInactivityLogout();
      await appRouter.replaceAll(<PageRouteInfo>[const AppMasterKeyRecoverRoute()]);
      initController();

      // Act
      autoLogoutController.handleUserInteraction();
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.single.name, AppMasterKeyRecoverRoute.name);
    });
  });

  group('Tests of AutoLogoutController.handleUserInteraction()', () {
    controllerTest('Should [restart the full timeout] after user interaction', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      autoLogoutController.handleUserInteraction();
      await pumpElapsed(const Duration(seconds: 59));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [not restart the timer] after manual logout to the PIN screen', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      globalLocator<AppService>().logout();
      await appRouter.replaceAll(<PageRouteInfo>[AppPinAuthRoute()]);
      autoLogoutController.handleUserInteraction();
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expect(activeWalletController.walletModel, null);
      expect(appRouter.stack.single.name, AppPinAuthRoute.name);
    });

    controllerTest('Should [restart the timer] after logging in again following automatic logout', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(minutes: 1));
      expectAppLoggedOut();

      // Act
      activeWalletController.setActiveWallet(walletModel: walletModel);
      await navigateToAuthenticatedRoute();
      await pumpElapsed(const Duration(seconds: 59));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });
  });

  group('Tests of AutoLogoutController route changes', () {
    controllerTest('Should [keep the timer running] during Change Application PIN', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      await appRouter.pushAll(<PageRouteInfo>[
        AppPinChangeRoute(children: <PageRouteInfo>[AppPinAuthRoute(appPinType: AppPinType.change)]),
      ]);
      await testWidgetsFlutterBinding.pump();
      expect(appRouter.stack.last.name, AppPinChangeRoute.name);
      await pumpElapsed(const Duration(seconds: 29));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [keep the timer running] while privacy policy is opened from Settings', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      await appRouter.pushAll(<PageRouteInfo>[const PrivacyPolicyRoute()]);
      await testWidgetsFlutterBinding.pump();
      expect(appRouter.stack.last.name, PrivacyPolicyRoute.name);
      await pumpElapsed(const Duration(seconds: 29));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [pause the timer] when a locked route is pushed over the authenticated stack', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      await appRouter.pushAll(<PageRouteInfo>[const AppMasterKeyRemovedRoute()]);
      await testWidgetsFlutterBinding.pump();
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.last.name, AppMasterKeyRemovedRoute.name);

      // Act
      await navigateToAuthenticatedRoute();
      await pumpElapsed(const Duration(seconds: 59));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [cancel the timer] after navigating away from the authenticated stack', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      await appRouter.replaceAll(<PageRouteInfo>[const SplashRoute()]);
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.single.name, SplashRoute.name);
    });
  });

  group('Tests of AutoLogoutController settings updates', () {
    controllerTest('Should [cancel logout when disabled] and [restart it when enabled]', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      await testWidgetsFlutterBinding.runAsync(() async {
        await autoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: false);
      });
      await testWidgetsFlutterBinding.pump();
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();

      // Act
      await testWidgetsFlutterBinding.runAsync(() async {
        await autoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: true);
      });
      await testWidgetsFlutterBinding.pump();
      await pumpElapsed(const Duration(seconds: 59));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [replace the pending timeout] when its duration changes', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      await testWidgetsFlutterBinding.runAsync(() async {
        await autoLogoutCubit.setInactivityLogoutTimer(inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes);
      });
      await testWidgetsFlutterBinding.pump();
      await pumpElapsed(const Duration(minutes: 4, seconds: 59));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [preserve the pending timeout] when only background logout changes', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      await testWidgetsFlutterBinding.runAsync(() async {
        await autoLogoutCubit.setBackgroundLogoutMode(backgroundLogoutMode: BackgroundLogoutMode.off);
      });
      await testWidgetsFlutterBinding.pump();
      await pumpElapsed(const Duration(seconds: 29));

      // Assert
      expectSessionPreserved();

      // Act
      await pumpElapsed(const Duration(seconds: 1));

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [not start the timer] when settings change on the locked PIN screen', () async {
      // Arrange
      await appRouter.replaceAll(<PageRouteInfo>[AppPinAuthRoute()]);
      initController();

      // Act
      await testWidgetsFlutterBinding.runAsync(() async {
        await autoLogoutCubit.setInactivityLogoutTimer(inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes);
        await autoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: false);
        await autoLogoutCubit.setInactivityEnabled(inactivityLogoutEnabledBool: true);
      });
      await testWidgetsFlutterBinding.pump();
      autoLogoutController.handleUserInteraction();
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.single.name, AppPinAuthRoute.name);
    });
  });

  group('Tests of AutoLogoutController background logout', () {
    controllerTest('Should [logout when hidden] but [not when only inactive]', () async {
      // Arrange
      expect(autoLogoutCubit.state.inactivityLogoutEnabledBool, false);
      await navigateToAuthenticatedRoute();
      initController();

      // Act
      testWidgetsFlutterBinding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await testWidgetsFlutterBinding.pump();

      // Assert
      expectSessionPreserved();

      // Act
      testWidgetsFlutterBinding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await testWidgetsFlutterBinding.pump();

      // Assert
      expectAppLoggedOut();
    });

    controllerTest('Should [not logout when hidden] after background logout is disabled', () async {
      // Arrange
      expect(autoLogoutCubit.state.inactivityLogoutEnabledBool, false);
      await navigateToAuthenticatedRoute();
      initController();

      // Act
      await testWidgetsFlutterBinding.runAsync(() async {
        await autoLogoutCubit.setBackgroundLogoutMode(backgroundLogoutMode: BackgroundLogoutMode.off);
      });
      await testWidgetsFlutterBinding.pump();
      testWidgetsFlutterBinding
        ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
        ..handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await testWidgetsFlutterBinding.pump();

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.single.name, BottomNavigationRoute.name);
    });

    controllerTest('Should [not logout when hidden] before authentication', () async {
      // Arrange
      await appRouter.replaceAll(<PageRouteInfo>[AppPinAuthRoute()]);
      initController();

      // Act
      testWidgetsFlutterBinding
        ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
        ..handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await testWidgetsFlutterBinding.pump();

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.single.name, AppPinAuthRoute.name);
    });
  });

  group('Tests of AutoLogoutController.dispose()', () {
    controllerTest('Should [cancel the timer] and [remove route, settings and lifecycle listeners]', () async {
      // Arrange
      await enableInactivityLogout();
      await navigateToAuthenticatedRoute();
      initController();
      await pumpElapsed(const Duration(seconds: 30));

      // Act
      disposeController();
      await testWidgetsFlutterBinding.runAsync(() async {
        await autoLogoutCubit.setInactivityLogoutTimer(inactivityLogoutTimer: InactivityLogoutTimer.fiveMinutes);
      });
      await appRouter.replaceAll(<PageRouteInfo>[const SplashRoute()]);
      await navigateToAuthenticatedRoute();
      testWidgetsFlutterBinding
        ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
        ..handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await pumpElapsed(const Duration(minutes: 6));

      // Assert
      expectSessionPreserved();
      expect(appRouter.stack.single.name, BottomNavigationRoute.name);
    });
  });
}
