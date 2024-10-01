import 'package:equatable/equatable.dart';

class AppWipeDialogState extends Equatable {
  static const int requiredConfirmationsCount = 3;

  final int confirmationsCount;
  final bool wipeInProgressBool;

  const AppWipeDialogState({
    required this.confirmationsCount,
    this.wipeInProgressBool = false,
  });

  AppWipeDialogState copyWith({
    int? confirmationsCount,
    bool? wipeInProgressBool,
  }) {
    return AppWipeDialogState(
      confirmationsCount: confirmationsCount ?? this.confirmationsCount,
      wipeInProgressBool: wipeInProgressBool ?? this.wipeInProgressBool,
    );
  }

  int get confirmationsLeft => requiredConfirmationsCount - confirmationsCount;

  @override
  List<Object?> get props => <Object>[confirmationsCount];
}
