import 'package:equatable/equatable.dart';

class WalletCreatePageState extends Equatable {
  final bool walletExistsErrorBool;
  final bool walletNameExistsBool;
  final bool emptyDerivationPathBool;

  const WalletCreatePageState({
    this.walletExistsErrorBool = false,
    this.walletNameExistsBool = false,
    this.emptyDerivationPathBool = false,
  });

  WalletCreatePageState copyWith({
    bool? walletExistsErrorBool,
    bool? walletNameExistsBool,
    bool? emptyDerivationPathBool,
  }) {
    return WalletCreatePageState(
      walletExistsErrorBool: walletExistsErrorBool ?? this.walletExistsErrorBool,
      walletNameExistsBool: walletNameExistsBool ?? this.walletNameExistsBool,
      emptyDerivationPathBool: emptyDerivationPathBool ?? this.emptyDerivationPathBool,
    );
  }

  @override
  List<Object?> get props => <Object>[walletExistsErrorBool, walletNameExistsBool, emptyDerivationPathBool];
}
