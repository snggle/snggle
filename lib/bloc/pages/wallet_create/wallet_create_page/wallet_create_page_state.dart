import 'package:equatable/equatable.dart';

class WalletCreatePageState extends Equatable {
  final bool walletExistsErrorBool;
  final bool walletNameExistsBool;
  final bool walletNameEmptyBool;
  final bool emptyDerivationPathBool;

  const WalletCreatePageState({
    this.walletExistsErrorBool = false,
    this.walletNameExistsBool = false,
    this.walletNameEmptyBool = false,
    this.emptyDerivationPathBool = false,
  });

  WalletCreatePageState copyWith({
    bool? walletExistsErrorBool,
    bool? walletNameExistsBool,
    bool? walletNameEmptyBool,
    bool? emptyDerivationPathBool,
  }) {
    return WalletCreatePageState(
      walletExistsErrorBool: walletExistsErrorBool ?? this.walletExistsErrorBool,
      walletNameExistsBool: walletNameExistsBool ?? this.walletNameExistsBool,
      walletNameEmptyBool: walletNameEmptyBool ?? this.walletNameEmptyBool,
      emptyDerivationPathBool: emptyDerivationPathBool ?? this.emptyDerivationPathBool,
    );
  }

  @override
  List<Object?> get props => <Object>[walletExistsErrorBool, walletNameExistsBool, walletNameEmptyBool, emptyDerivationPathBool];
}
