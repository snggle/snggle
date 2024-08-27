import 'package:equatable/equatable.dart';

class WalletCreatePageState extends Equatable {
  final bool walletExistsErrorBool;
  final bool emptyDerivationPathBool;

  const WalletCreatePageState({
    this.walletExistsErrorBool = false,
    this.emptyDerivationPathBool = false,
  });

  @override
  List<Object?> get props => <Object>[walletExistsErrorBool, emptyDerivationPathBool];
}
