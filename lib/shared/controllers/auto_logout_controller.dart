import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:snggle/bloc/pages/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/automatic_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactive_logout_timeout.dart';
import 'package:snggle/shared/router/router.dart';
import 'package:snggle/shared/router/router.gr.dart';

class AutoLogoutController {
  AutoLogoutController({
    required this._appRouter,
    required this._appService,
    required this._autoLogoutCubit,
  });

  final AppRouter _appRouter;
  final AppService _appService;
  final AutoLogoutCubit _autoLogoutCubit;

  bool _logoutInProgressBool = false;
  late final AppLifecycleListener _appLifecycleListener;
  late final StreamSubscription<AutoLogoutState> _autoLogoutStateStreamSubscription;
  Timer? _inactivityLogoutTimer;

  void dispose() {
    _appLifecycleListener.dispose();
    unawaited(_autoLogoutStateStreamSubscription.cancel());
    _cancelInactivityLogoutTimer();
  }

  void handleUserInteraction() {
    _restartInactivityLogoutTimer(_autoLogoutCubit.state);
  }

  void init() {
    _appLifecycleListener = AppLifecycleListener(onHide: _handleAppHidden);
    _autoLogoutStateStreamSubscription = _autoLogoutCubit.stream.listen(_handleAutoLogoutChanged);

    _restartInactivityLogoutTimer(_autoLogoutCubit.state);
  }

  void _cancelInactivityLogoutTimer() {
    _inactivityLogoutTimer?.cancel();
    _inactivityLogoutTimer = null;
  }

  Duration? _getInactivityLogoutDuration(InactivityLogoutTimeout inactivityLogoutTimeout) {
    return switch (inactivityLogoutTimeout) {
      InactivityLogoutTimeout.off => null,
      InactivityLogoutTimeout.oneMinute => const Duration(minutes: 1),
      InactivityLogoutTimeout.fiveMinutes => const Duration(minutes: 5),
    };
  }

  void _handleAppHidden() {
    final AutomaticLogoutMode automaticLogoutMode = _autoLogoutCubit.state.automaticLogoutMode;

    switch (automaticLogoutMode) {
      case AutomaticLogoutMode.off:
        return;

      case AutomaticLogoutMode.on:
        unawaited(_handleLogout());
        return;
    }
  }

  void _handleAutoLogoutChanged(AutoLogoutState autoLogoutState) {
    _restartInactivityLogoutTimer(autoLogoutState);
  }

  Future<void> _handleLogout() async {
    if (_logoutInProgressBool) {
      return;
    }

    _logoutInProgressBool = true;
    _cancelInactivityLogoutTimer();

    try {
      _appService.logout();

      await _appRouter.replaceAll(<PageRouteInfo>[const SplashRoute()]);
    } finally {
      _logoutInProgressBool = false;
    }
  }

  void _restartInactivityLogoutTimer(AutoLogoutState autoLogoutState) {
    _cancelInactivityLogoutTimer();

    final bool inactivityLogoutDisabledBool = autoLogoutState.inactivityLogoutEnabledBool == false;

    if (inactivityLogoutDisabledBool) {
      return;
    }

    final Duration? inactivityLogoutDuration = _getInactivityLogoutDuration(autoLogoutState.inactivityLogoutTimeout);

    switch (inactivityLogoutDuration) {
      case null:
        return;

      case final Duration resolvedInactivityLogoutDuration:
        _startInactivityLogoutTimer(resolvedInactivityLogoutDuration);
    }
  }

  void _startInactivityLogoutTimer(Duration inactivityLogoutDuration) {
    _inactivityLogoutTimer = Timer(inactivityLogoutDuration, () => unawaited(_handleLogout()));
  }
}
