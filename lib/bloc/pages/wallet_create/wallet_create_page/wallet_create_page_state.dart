import 'package:equatable/equatable.dart';

class WalletCreatePageState extends Equatable {
  final bool walletExistsErrorBool;
  final bool walletNameEmptyBool;
  final bool emptyDerivationPathBool;

  const WalletCreatePageState({
    this.walletExistsErrorBool = false,
    this.walletNameEmptyBool = false,
    this.emptyDerivationPathBool = false,
  });

  WalletCreatePageState copyWith({
    bool? walletExistsErrorBool,
    bool? walletNameEmptyBool,
    bool? emptyDerivationPathBool,
  }) {
    return WalletCreatePageState(
      walletExistsErrorBool: walletExistsErrorBool ?? this.walletExistsErrorBool,
      walletNameEmptyBool: walletNameEmptyBool ?? this.walletNameEmptyBool,
      emptyDerivationPathBool: emptyDerivationPathBool ?? this.emptyDerivationPathBool,
    );
  }

  @override
  List<Object?> get props => <Object>[walletExistsErrorBool, emptyDerivationPathBool, walletNameEmptyBool];
}
