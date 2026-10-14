part of 'auto_logout_cubit.dart';

class AutoLogoutState extends Equatable {
  const AutoLogoutState({
    required this.inactivityLogoutEnabledBool,
    required this.automaticLogoutMode,
    required this.inactivityLogoutTimeout,
  });

  final bool inactivityLogoutEnabledBool;
  final AutomaticLogoutMode automaticLogoutMode;
  final InactivityLogoutTimeout inactivityLogoutTimeout;

  AutoLogoutState copyWith({
    bool? inactivityLogoutEnabledBool,
    AutomaticLogoutMode? automaticLogoutMode,
    InactivityLogoutTimeout? inactivityLogoutTimeout,
  }) {
    return AutoLogoutState(
      inactivityLogoutEnabledBool: inactivityLogoutEnabledBool ?? this.inactivityLogoutEnabledBool,
      automaticLogoutMode: automaticLogoutMode ?? this.automaticLogoutMode,
      inactivityLogoutTimeout: inactivityLogoutTimeout ?? this.inactivityLogoutTimeout,
    );
  }

  @override
  List<Object> get props => <Object>[inactivityLogoutEnabledBool, automaticLogoutMode, inactivityLogoutTimeout];
}
