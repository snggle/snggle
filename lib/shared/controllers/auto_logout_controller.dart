import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
import 'package:snggle/shared/router/router.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/shared/utils/logger/log_level.dart';

class AutoLogoutController {
  final AppRouter _appRouter;
  final AppService _appService;
  final AutoLogoutCubit _autoLogoutCubit;
  final Stopwatch _stopwatch = Stopwatch();

  bool _appUnlockedBool = false;
  bool _logoutInProgressBool = false;
  late final AppLifecycleListener _appLifecycleListener;
  late final StreamSubscription<AutoLogoutState> _autoLogoutStateStreamSubscription;
  late AutoLogoutState _autoLogoutState;
  Timer? _inactivityLogoutTimer;
  Timer? _debugTimer;

  AutoLogoutController({
    required this._appRouter,
    required this._appService,
    required this._autoLogoutCubit,
  });

  void dispose() {
    _appLifecycleListener.dispose();
    _autoLogoutStateStreamSubscription.cancel();
    _appRouter.removeListener(_handleRouteChanged);
    _cancelInactivityLogoutTimer();
  }

  void init() {
    _autoLogoutState = _autoLogoutCubit.state;
    _appLifecycleListener = AppLifecycleListener(onHide: _handleAppHidden);
    _autoLogoutStateStreamSubscription = _autoLogoutCubit.stream.listen(_handleAutoLogoutChanged);
    _appRouter.addListener(_handleRouteChanged);

    _handleRouteChanged();
  }

  void handleUserInteraction() {
    _cancelInactivityLogoutTimer();

    bool inactivityLogoutBlockedBool = _autoLogoutState.inactivityLogoutEnabledBool == false || _appUnlockedBool == false || _logoutInProgressBool;
    if (inactivityLogoutBlockedBool) {
      return;
    }

    Duration inactivityLogoutDuration = switch (_autoLogoutState.inactivityLogoutTimer) {
      InactivityLogoutTimer.oneMinute => const Duration(minutes: 1),
      InactivityLogoutTimer.fiveMinutes => const Duration(minutes: 5),
    };

    _startDebugTimer(inactivityLogoutDuration);
    _inactivityLogoutTimer = Timer(inactivityLogoutDuration, _handleLogout);
  }

  void _handleAppHidden() {
    bool backgroundLogoutEnabledBool = _autoLogoutState.backgroundLogoutMode == BackgroundLogoutMode.on;
    if (backgroundLogoutEnabledBool) {
      unawaited(_handleLogout());
    }
  }

  void _handleAutoLogoutChanged(AutoLogoutState autoLogoutState) {
    bool inactivitySettingsChangedBool =
        autoLogoutState.inactivityLogoutEnabledBool != _autoLogoutState.inactivityLogoutEnabledBool ||
        autoLogoutState.inactivityLogoutTimer != _autoLogoutState.inactivityLogoutTimer;
    _autoLogoutState = autoLogoutState;

    if (inactivitySettingsChangedBool) {
      handleUserInteraction();
    }
  }

  void _handleRouteChanged() {
    List<AutoRoutePage<dynamic>> routeStackList = _appRouter.stack;

    bool lockedRouteBool = routeStackList.isEmpty || routeStackList.any(_isLockedRoute);
    bool authenticatedRouteBool = routeStackList.any((AutoRoutePage<dynamic> autoRoutePage) => autoRoutePage.name == BottomNavigationRoute.name);
    bool unlockedBool = authenticatedRouteBool && !lockedRouteBool && !_logoutInProgressBool;
    bool unlockedChangedBool = _appUnlockedBool != unlockedBool;
    _appUnlockedBool = unlockedBool;

    if (unlockedChangedBool) {
      handleUserInteraction();
    }
  }

  bool _isLockedRoute(AutoRoutePage<dynamic> autoRoutePage) {
    return autoRoutePage.name == SplashRoute.name ||
        autoRoutePage.name == AppMasterKeyRemovedRoute.name ||
        autoRoutePage.name == AppMasterKeyCreateRoute.name ||
        autoRoutePage.name == AppMasterKeyRecoverRoute.name;
  }

  Future<void> _handleLogout() async {
    bool logoutBlockedBool = _logoutInProgressBool || _appUnlockedBool == false;
    if (logoutBlockedBool) {
      return;
    }

    _logoutInProgressBool = true;
    _appUnlockedBool = false;

    try {
      _cancelInactivityLogoutTimer();
      _appService.logout();
      AppLogger().log(message: 'App automatically logged out', logLevel: LogLevel.info);
      await _appRouter.replaceAll(<PageRouteInfo>[const SplashRoute()]);
    } finally {
      _logoutInProgressBool = false;
    }
  }

  void _cancelInactivityLogoutTimer() {
    _inactivityLogoutTimer?.cancel();
    _inactivityLogoutTimer = null;

    _debugTimer?.cancel();
    _debugTimer = null;
    _stopwatch.stop();
  }

  void _startDebugTimer(Duration inactivityLogoutDuration) {
    if (kDebugMode == false) {
      return;
    }

    _stopwatch
      ..reset()
      ..start();

    _debugTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        Duration remainingDuration = inactivityLogoutDuration - _stopwatch.elapsed;
        int remainingSeconds = remainingDuration.isNegative ? 0 : (remainingDuration.inMilliseconds / 1000).ceil();
        debugPrint('[AutoLogout] Remaining: ${remainingSeconds}s');
      },
    );
  }
}
