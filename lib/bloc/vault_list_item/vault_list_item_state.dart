import 'package:equatable/equatable.dart';

class VaultListItemState extends Equatable {
  final bool encryptedBool;
  final bool lockedBool;

  const VaultListItemState.decrypted()
      : encryptedBool = false,
        lockedBool = false;

  const VaultListItemState.encrypted({
    this.lockedBool = true,
  }) : encryptedBool = true;

  @override
  List<Object?> get props => <Object?>[encryptedBool, lockedBool];
}
