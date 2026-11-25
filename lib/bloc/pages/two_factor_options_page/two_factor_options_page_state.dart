import 'package:equatable/equatable.dart';

class TwoFactorOptionsPageState extends Equatable {
  final bool totpExportAvailableBool;

  const TwoFactorOptionsPageState({required this.totpExportAvailableBool});

  @override
  List<Object?> get props => <Object?>[totpExportAvailableBool];
}
