part of 'auto_logout_cubit.dart';

class AutoLogoutState extends Equatable {
  const AutoLogoutState({
    required this.automaticLogoutMode,
    required this.inactivityLogoutEnabledBool,
    required this.inactivityLogoutTimeout,
  });

  final AutomaticLogoutMode automaticLogoutMode;
  final bool inactivityLogoutEnabledBool;
  final InactivityLogoutTimeout inactivityLogoutTimeout;

  AutoLogoutState copyWith({
    AutomaticLogoutMode? automaticLogoutMode,
    bool? inactivityLogoutEnabledBool,
    InactivityLogoutTimeout? inactivityLogoutTimeout,
  }) {
    return AutoLogoutState(
      automaticLogoutMode: automaticLogoutMode ?? this.automaticLogoutMode,
      inactivityLogoutEnabledBool: inactivityLogoutEnabledBool ?? this.inactivityLogoutEnabledBool,
      inactivityLogoutTimeout: inactivityLogoutTimeout ?? this.inactivityLogoutTimeout,
    );
  }

  @override
  List<Object> get props => <Object>[
    automaticLogoutMode,
    inactivityLogoutEnabledBool,
    inactivityLogoutTimeout,
  ];
}
