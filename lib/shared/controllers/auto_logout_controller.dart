import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:snggle/bloc/pages/bottom_navigation/settings_wrapper/settings_page/auto_logout_cubit/auto_logout_cubit.dart';
import 'package:snggle/infra/services/app_service.dart';
import 'package:snggle/shared/models/auto_logout_settings/background_logout_mode.dart';
import 'package:snggle/shared/models/auto_logout_settings/inactivity_logout_timer.dart';
import 'package:snggle/shared/router/router.dart';
import 'package:snggle/shared/router/router.gr.dart';

class AutoLogoutController {
  bool _logoutInProgressBool = false;

  final AppRouter _appRouter;
  final AppService _appService;
  final AutoLogoutCubit _autoLogoutCubit;

  late final AppLifecycleListener _appLifecycleListener;
  late final StreamSubscription<AutoLogoutState> _autoLogoutStateStreamSubscription;
  late AutoLogoutState _autoLogoutState;
  Timer? _inactivityLogoutTimer;

  AutoLogoutController({
    required this._appRouter,
    required this._appService,
    required this._autoLogoutCubit,
  });

  void init() {
    _autoLogoutState = _autoLogoutCubit.state;
    _appLifecycleListener = AppLifecycleListener(onHide: _handleAppHidden);
    _autoLogoutStateStreamSubscription = _autoLogoutCubit.stream.listen(_handleAutoLogoutChanged);

    _restartInactivityLogoutTimer(_autoLogoutCubit.state);
  }

  void dispose() {
    _appLifecycleListener.dispose();
    _autoLogoutStateStreamSubscription.cancel();
    _cancelInactivityLogoutTimer();
  }

  void handleUserInteraction() {
    _restartInactivityLogoutTimer(_autoLogoutCubit.state);
  }

  void _handleAppHidden() {
    BackgroundLogoutMode automaticLogoutMode = _autoLogoutCubit.state.backgroundLogoutMode;

    switch (automaticLogoutMode) {
      case BackgroundLogoutMode.off:
        return;

      case BackgroundLogoutMode.on:
        unawaited(_handleLogout());
        return;
    }
  }

  void _handleAutoLogoutChanged(AutoLogoutState autoLogoutState) {
    bool enabledChangedBool = autoLogoutState.inactivityLogoutEnabledBool != _autoLogoutState.inactivityLogoutEnabledBool;
    bool timeoutChangedBool = autoLogoutState.inactivityLogoutTimeout != _autoLogoutState.inactivityLogoutTimeout;
    _autoLogoutState = autoLogoutState;

    if (enabledChangedBool || timeoutChangedBool) {
      _restartInactivityLogoutTimer(autoLogoutState);
    }
  }

  void _restartInactivityLogoutTimer(AutoLogoutState autoLogoutState) {
    _cancelInactivityLogoutTimer();

    if (!autoLogoutState.inactivityLogoutEnabledBool) {
      return;
    }

    Duration? inactivityLogoutDuration = _getInactivityLogoutDuration(
      autoLogoutState.inactivityLogoutTimeout,
    );
    bool inactivityLogoutDurationMissingBool = inactivityLogoutDuration == null;

    if (inactivityLogoutDurationMissingBool) {
      return;
    }

    _startInactivityLogoutTimer(inactivityLogoutDuration);
  }

  Duration? _getInactivityLogoutDuration(InactivityLogoutTimer inactivityLogoutTimeout) {
    return switch (inactivityLogoutTimeout) {
      InactivityLogoutTimer.off => null,
      InactivityLogoutTimer.oneMinute => const Duration(minutes: 1),
      InactivityLogoutTimer.fiveMinutes => const Duration(minutes: 5),
    };
  }

  Future<void> _handleLogout() async {
    if (_logoutInProgressBool) {
      return;
    }
    _logoutInProgressBool = true;

    try {
      _cancelInactivityLogoutTimer();
      _appService.logout();
      await _appRouter.replaceAll(<PageRouteInfo>[const SplashRoute()]);
    } finally {
      _logoutInProgressBool = false;
    }
  }

  void _cancelInactivityLogoutTimer() {
    _inactivityLogoutTimer?.cancel();
    _inactivityLogoutTimer = null;
  }

  void _startInactivityLogoutTimer(Duration inactivityLogoutDuration) {
    _inactivityLogoutTimer = Timer(inactivityLogoutDuration, () => unawaited(_handleLogout()));
  }
}
