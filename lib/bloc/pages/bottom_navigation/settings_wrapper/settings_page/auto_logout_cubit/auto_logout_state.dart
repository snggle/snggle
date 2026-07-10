part of 'auto_logout_cubit.dart';

class AutoLogoutState extends Equatable {
  final bool inactivityLogoutEnabledBool;
  final BackgroundLogoutMode backgroundLogoutMode;
  final InactivityLogoutTimer inactivityLogoutTimer;

  const AutoLogoutState({
    required this.inactivityLogoutEnabledBool,
    required this.backgroundLogoutMode,
    required this.inactivityLogoutTimer,
  });

  AutoLogoutState copyWith({
    bool? inactivityLogoutEnabledBool,
    BackgroundLogoutMode? backgroundLogoutMode,
    InactivityLogoutTimer? inactivityLogoutTimer,
  }) {
    return AutoLogoutState(
      inactivityLogoutEnabledBool: inactivityLogoutEnabledBool ?? this.inactivityLogoutEnabledBool,
      backgroundLogoutMode: backgroundLogoutMode ?? this.backgroundLogoutMode,
      inactivityLogoutTimer: inactivityLogoutTimer ?? this.inactivityLogoutTimer,
    );
  }

  @override
  List<Object> get props => <Object>[inactivityLogoutEnabledBool, backgroundLogoutMode, inactivityLogoutTimer];
}
