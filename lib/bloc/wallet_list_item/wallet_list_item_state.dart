import 'package:equatable/equatable.dart';

class WalletListItemState extends Equatable {
  final bool encryptedBool;
  final bool lockedBool;

  const WalletListItemState({
    required this.encryptedBool,
    required this.lockedBool,
  });

  const WalletListItemState.decrypted()
      : encryptedBool = false,
        lockedBool = false;

  const WalletListItemState.encrypted({
    this.lockedBool = true,
  }) : encryptedBool = true;

  @override
  List<Object?> get props => <Object?>[encryptedBool, lockedBool];
}
