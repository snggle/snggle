import 'package:equatable/equatable.dart';

class WalletCreatePageState extends Equatable {
  final bool walletExistsErrorBool;

  const WalletCreatePageState({
    this.walletExistsErrorBool = false,
  });

  @override
  List<Object?> get props => <Object>[walletExistsErrorBool];
}
