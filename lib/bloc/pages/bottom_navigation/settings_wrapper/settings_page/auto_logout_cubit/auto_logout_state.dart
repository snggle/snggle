part of 'auto_logout_cubit.dart';

class AutoLogoutState extends Equatable {
  const AutoLogoutState({
    required this.inactivityLogoutEnabledBool,
    required this.backgroundLogoutMode,
    required this.inactivityLogoutTimeout,
  });

  final bool inactivityLogoutEnabledBool;
  final BackgroundLogoutMode backgroundLogoutMode;
  final InactivityLogoutTimer inactivityLogoutTimeout;

  AutoLogoutState copyWith({
    bool? inactivityLogoutEnabledBool,
    BackgroundLogoutMode? backgroundLogoutMode,
    InactivityLogoutTimer? inactivityLogoutTimeout,
  }) {
    return AutoLogoutState(
      inactivityLogoutEnabledBool: inactivityLogoutEnabledBool ?? this.inactivityLogoutEnabledBool,
      backgroundLogoutMode: backgroundLogoutMode ?? this.backgroundLogoutMode,
      inactivityLogoutTimeout: inactivityLogoutTimeout ?? this.inactivityLogoutTimeout,
    );
  }

  @override
  List<Object> get props => <Object>[inactivityLogoutEnabledBool, backgroundLogoutMode, inactivityLogoutTimeout];
}
