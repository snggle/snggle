import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/config/locator.dart';
import 'package:snggle/config/theme_config.dart';
import 'package:snggle/infra/managers/isar_database_manager.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/controllers/auto_logout_controller.dart';
import 'package:snggle/shared/router/router.dart';

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
  Widget build(BuildContext buildContext) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
      theme: ThemeConfig().buildTheme(),
      debugShowCheckedModeBanner: false,
      builder: (BuildContext buildContext, Widget? routerWidget) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (PointerDownEvent pointerDownEvent) {
            _autoLogoutController.handleUserInteraction();
          },
          child: routerWidget ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
