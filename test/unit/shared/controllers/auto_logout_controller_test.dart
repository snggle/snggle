import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/controllers/active_wallet_controller.dart';
import 'package:snggle/shared/controllers/auto_logout_controller.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timeout.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/shared/models/wallets/wallet_model.dart';
import 'package:snggle/shared/router/router.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

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
    testWidgetsFlutterBinding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );

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
      filesystemPath: FilesystemPath.fromString(
        'vaults/vault1/network1/wallet1',
      ),
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

    testWidgetsFlutterBinding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
  });

  void initController() {
    testWidgetsFlutterBinding.handleAppLifecycleStateChanged(
      AppLifecycleState.resumed,
    );
    autoLogoutController.init();
    controllerInitializedBool = true;
  }

  void disposeController() {
    if (controllerInitializedBool) {
      autoLogoutController.dispose();
      controllerInitializedBool = false;
    }
  }

  group('Tests of AutoLogoutController.init()', () {
    for (MapEntry<InactivityLogoutTimeout, Duration> timeoutMapEntry in const <InactivityLogoutTimeout, Duration>{
      InactivityLogoutTimeout.oneMinute: Duration(minutes: 1),
      InactivityLogoutTimeout.fiveMinutes: Duration(minutes: 5),
    }.entries) {
      testWidgets(
        'Should [logout after ${timeoutMapEntry.key.name}] without user interaction',
        (WidgetTester tester) async {
          try {
            // Arrange
            await tester.runAsync(() async {
              await autoLogoutCubit.setInactivityLogoutTimeout(
                inactivityLogoutTimeout: timeoutMapEntry.key,
              );
            });

            // Act
            initController();
            await tester.pump(
              timeoutMapEntry.value - const Duration(seconds: 1),
            );

            // Assert
            expect(activeWalletController.walletModel, walletModel);
            expect(appRouter.stack, isEmpty);

            // Act
            await tester.pump(const Duration(seconds: 1));

            // Assert
            expect(activeWalletController.hasActiveWallet, false);
            expect(activeWalletController.walletModel, null);
            expect(appRouter.stack, hasLength(1));
            expect(appRouter.stack.single.name, SplashRoute.name);
          } finally {
            disposeController();
          }
        },
      );
    }

    testWidgets(
      'Should [not logout] if [inactivity logout DISABLED]',
      (WidgetTester tester) async {
        try {
          // Arrange
          await tester.runAsync(() async {
            await autoLogoutCubit.setInactivityEnabled(
              inactivityLogoutEnabledBool: false,
            );
          });

          // Act
          initController();
          await tester.pump(const Duration(minutes: 6));

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);
        } finally {
          disposeController();
        }
      },
    );

    testWidgets(
      'Should [not logout] if [inactivity timeout OFF]',
      (WidgetTester tester) async {
        try {
          // Arrange
          await tester.runAsync(() async {
            await autoLogoutCubit.setInactivityLogoutTimeout(
              inactivityLogoutTimeout: InactivityLogoutTimeout.off,
            );
          });

          // Act
          initController();
          await tester.pump(const Duration(minutes: 6));

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);
        } finally {
          disposeController();
        }
      },
    );
  });

  group('Tests of AutoLogoutController.handleUserInteraction()', () {
    testWidgets(
      'Should [restart the full timeout] after user interaction',
      (WidgetTester tester) async {
        try {
          // Arrange
          initController();
          await tester.pump(const Duration(seconds: 30));

          // Act
          autoLogoutController.handleUserInteraction();
          await tester.pump(const Duration(seconds: 59));

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);

          // Act
          await tester.pump(const Duration(seconds: 1));

          // Assert
          expect(activeWalletController.walletModel, null);
          expect(appRouter.stack, hasLength(1));
          expect(appRouter.stack.single.name, SplashRoute.name);
        } finally {
          disposeController();
        }
      },
    );

    testWidgets(
      'Should [allow another inactivity logout] after the previous logout completes',
      (WidgetTester tester) async {
        try {
          // Arrange
          initController();
          await tester.pump(const Duration(minutes: 1));
          expect(activeWalletController.walletModel, null);
          activeWalletController.setActiveWallet(walletModel: walletModel);

          // Act
          autoLogoutController.handleUserInteraction();
          await tester.pump(const Duration(seconds: 59));

          // Assert
          expect(activeWalletController.walletModel, walletModel);

          // Act
          await tester.pump(const Duration(seconds: 1));

          // Assert
          expect(activeWalletController.walletModel, null);
          expect(appRouter.stack, hasLength(1));
          expect(appRouter.stack.single.name, SplashRoute.name);
        } finally {
          disposeController();
        }
      },
    );
  });

  group('Tests of AutoLogoutController settings updates', () {
    testWidgets(
      'Should [cancel logout when disabled] and [restart it when enabled]',
      (WidgetTester tester) async {
        try {
          // Arrange
          initController();
          await tester.pump(const Duration(seconds: 30));

          // Act
          await tester.runAsync(() async {
            await autoLogoutCubit.setInactivityEnabled(
              inactivityLogoutEnabledBool: false,
            );
          });
          await tester.pump();
          await tester.pump(const Duration(minutes: 6));

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);

          // Act
          await tester.runAsync(() async {
            await autoLogoutCubit.setInactivityEnabled(
              inactivityLogoutEnabledBool: true,
            );
          });
          await tester.pump();
          await tester.pump(const Duration(seconds: 59));

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);

          // Act
          await tester.pump(const Duration(seconds: 1));

          // Assert
          expect(activeWalletController.walletModel, null);
          expect(appRouter.stack, hasLength(1));
          expect(appRouter.stack.single.name, SplashRoute.name);
        } finally {
          disposeController();
        }
      },
    );

    testWidgets(
      'Should [replace the pending timeout] when its duration changes',
      (WidgetTester tester) async {
        try {
          // Arrange
          initController();
          await tester.pump(const Duration(seconds: 30));

          // Act
          await tester.runAsync(() async {
            await autoLogoutCubit.setInactivityLogoutTimeout(
              inactivityLogoutTimeout: InactivityLogoutTimeout.fiveMinutes,
            );
          });
          await tester.pump();
          await tester.pump(const Duration(minutes: 4, seconds: 59));

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);

          // Act
          await tester.pump(const Duration(seconds: 1));

          // Assert
          expect(activeWalletController.walletModel, null);
          expect(appRouter.stack, hasLength(1));
          expect(appRouter.stack.single.name, SplashRoute.name);
        } finally {
          disposeController();
        }
      },
    );

    testWidgets(
      'Should [preserve the pending timeout] when only background logout changes',
      (WidgetTester tester) async {
        try {
          // Arrange
          initController();
          await tester.pump(const Duration(seconds: 30));

          // Act
          await tester.runAsync(() async {
            await autoLogoutCubit.setBackgroundLogoutMode(
              backgroundLogoutMode: BackgroundLogoutMode.off,
            );
          });
          await tester.pump();
          await tester.pump(const Duration(seconds: 29));

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);

          // Act
          await tester.pump(const Duration(seconds: 1));

          // Assert
          expect(activeWalletController.walletModel, null);
          expect(appRouter.stack, hasLength(1));
          expect(appRouter.stack.single.name, SplashRoute.name);
        } finally {
          disposeController();
        }
      },
    );

    testWidgets(
      'Should [cancel the pending timeout] when timeout changes to off',
      (WidgetTester tester) async {
        try {
          // Arrange
          initController();
          await tester.pump(const Duration(seconds: 30));

          // Act
          await tester.runAsync(() async {
            await autoLogoutCubit.setInactivityLogoutTimeout(
              inactivityLogoutTimeout: InactivityLogoutTimeout.off,
            );
          });
          await tester.pump();
          await tester.pump(const Duration(minutes: 6));

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);
        } finally {
          disposeController();
        }
      },
    );
  });

  group('Tests of AutoLogoutController background logout', () {
    testWidgets(
      'Should [logout when hidden] but [not when only inactive]',
      (WidgetTester tester) async {
        try {
          // Arrange
          await tester.runAsync(() async {
            await autoLogoutCubit.setInactivityEnabled(
              inactivityLogoutEnabledBool: false,
            );
          });
          initController();

          // Act
          testWidgetsFlutterBinding.handleAppLifecycleStateChanged(
            AppLifecycleState.inactive,
          );
          await tester.pump();

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);

          // Act
          testWidgetsFlutterBinding.handleAppLifecycleStateChanged(
            AppLifecycleState.hidden,
          );
          await tester.pump();

          // Assert
          expect(activeWalletController.walletModel, null);
          expect(appRouter.stack, hasLength(1));
          expect(appRouter.stack.single.name, SplashRoute.name);
        } finally {
          disposeController();
        }
      },
    );

    testWidgets(
      'Should [not logout when hidden] after background logout is disabled',
      (WidgetTester tester) async {
        try {
          // Arrange
          await tester.runAsync(() async {
            await autoLogoutCubit.setInactivityEnabled(
              inactivityLogoutEnabledBool: false,
            );
          });
          initController();

          // Act
          await tester.runAsync(() async {
            await autoLogoutCubit.setBackgroundLogoutMode(
              backgroundLogoutMode: BackgroundLogoutMode.off,
            );
          });
          await tester.pump();

          testWidgetsFlutterBinding
            ..handleAppLifecycleStateChanged(
              AppLifecycleState.inactive,
            )
            ..handleAppLifecycleStateChanged(
              AppLifecycleState.hidden,
            );
          await tester.pump();

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);
        } finally {
          disposeController();
        }
      },
    );
  });

  group('Tests of AutoLogoutController.dispose()', () {
    testWidgets(
      'Should [cancel the timer] and [remove settings and lifecycle listeners]',
      (WidgetTester tester) async {
        try {
          // Arrange
          initController();
          await tester.pump(const Duration(seconds: 30));

          // Act
          autoLogoutController.dispose();
          controllerInitializedBool = false;

          await tester.runAsync(() async {
            await autoLogoutCubit.setInactivityLogoutTimeout(
              inactivityLogoutTimeout: InactivityLogoutTimeout.fiveMinutes,
            );
          });
          await tester.pump();

          testWidgetsFlutterBinding
            ..handleAppLifecycleStateChanged(
              AppLifecycleState.inactive,
            )
            ..handleAppLifecycleStateChanged(
              AppLifecycleState.hidden,
            );
          await tester.pump(const Duration(minutes: 6));

          // Assert
          expect(activeWalletController.walletModel, walletModel);
          expect(appRouter.stack, isEmpty);
        } finally {
          disposeController();
        }
      },
    );
  });
}
