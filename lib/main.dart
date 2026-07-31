import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/config/theme_config.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/controllers/auto_logout_controller.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactive_logout_timeout.dart';
import 'package:snggle/shared/router/router.dart';
import 'package:snggle/shared/router/router.gr.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
  );

  initLocator();
  await globalLocator<IsarDatabaseManager>().initDatabase();

  AutoLogoutCubit autoLogoutCubit = globalLocator<AutoLogoutCubit>();

  await autoLogoutCubit.init();

  runApp(BlocProvider<AutoLogoutCubit>.value(value: autoLogoutCubit, child: const AppCore()));
}

class AppCore extends StatefulWidget {
  const AppCore({super.key});

  @override
  State<AppCore> createState() => _AppCoreState();
}

// class _AppCoreState extends State<AppCore> {
//   final AppRouter appRouter = AppRouter();
//
//   late final AppLifecycleListener appLifecycleListener;
//
//   @override
//   void initState() {
//     super.initState();
//
//     appLifecycleListener = AppLifecycleListener(
//       onHide: _handleAppHidden,
//     );
//   }
//
//   @override
//   void dispose() {
//     appLifecycleListener.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       routeInformationParser: appRouter.defaultRouteParser(),
//       routerDelegate: appRouter.delegate(),
//       theme: ThemeConfig().buildTheme(),
//       debugShowCheckedModeBanner: false,
//       builder: (_, Widget? routerWidget) {
//         return routerWidget as Widget;
//       },
//     );
//   }
//
//   Future<void> _handleAppHidden() async {
//     AppService().logout();
//
//     await appRouter.replaceAll(
//       <PageRouteInfo>[const SplashRoute()],
//     );
//   }

class _AppCoreState extends State<AppCore> {
  final AppRouter _appRouter = AppRouter();
  late final AutoLogoutController _autoLogoutController;

  @override
  void initState() {
    super.initState();
    _autoLogoutController = AutoLogoutController(
      appRouter: _appRouter,
      appService: globalLocator<AppService>(),
      autoLogoutCubit: context.read<AutoLogoutCubit>(),
    );
    _autoLogoutController.init();
  }

  @override
  void dispose() {
    _autoLogoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
      theme: ThemeConfig().buildTheme(),
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? routerWidget) {
        return BlocListener<AutoLogoutCubit, AutoLogoutState>(
          listenWhen: (AutoLogoutState previousState, AutoLogoutState currentState) {
            return previousState.inactivityLogoutEnabledBool != currentState.inactivityLogoutEnabledBool ||
                previousState.inactivityLogoutTimeout != currentState.inactivityLogoutTimeout;
          },
          listener: (BuildContext context, AutoLogoutState state) {
            _restartInactivityLogoutTimer(state);
          },
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              _restartInactivityLogoutTimer(context.read<AutoLogoutCubit>().state);
            },
            child: routerWidget ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  void _handleAppHidden() {
    AutomaticLogoutMode automaticLogoutMode = context.read<AutoLogoutCubit>().state.automaticLogoutMode;

    switch (automaticLogoutMode) {
      case AutomaticLogoutMode.off:
        return;

      case AutomaticLogoutMode.on:
        unawaited(_logout());
        return;
    }
  }

  void _restartInactivityLogoutTimer(AutoLogoutState state) {
    inactivityLogoutTimer?.cancel();
    inactivityLogoutTimer = null;

    if (state.inactivityLogoutEnabledBool == false) {
      return;
    }

    Duration? timeout = switch (state.inactivityLogoutTimeout) {
      InactivityLogoutTimeout.off => null,
      InactivityLogoutTimeout.oneMinute => const Duration(minutes: 1),
      InactivityLogoutTimeout.fiveMinutes => const Duration(minutes: 5),
    };

    if (timeout == null) {
      return;
    }

    inactivityLogoutTimer = Timer(timeout, () => unawaited(_logout()));
  }

  Future<void> _logout() async {
    if (logoutInProgressBool) {
      return;
    }

    logoutInProgressBool = true;
    inactivityLogoutTimer?.cancel();
    inactivityLogoutTimer = null;

    try {
      globalLocator<AppService>().logout();

      await _appRouter.replaceAll(<PageRouteInfo>[const SplashRoute()]);
    } finally {
      logoutInProgressBool = false;
    }
  }
}
