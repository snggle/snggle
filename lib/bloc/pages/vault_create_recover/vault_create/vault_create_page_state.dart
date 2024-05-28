import 'package:equatable/equatable.dart';

class VaultCreatePageState extends Equatable {
  final bool confirmPageEnabledBool;
  final bool loadingBool;
  final int? lastVaultIndex;
  final int? mnemonicSize;
  final List<String>? mnemonic;

  const VaultCreatePageState({
    this.confirmPageEnabledBool = false,
    this.loadingBool = false,
    this.lastVaultIndex,
    this.mnemonicSize,
    this.mnemonic,
  });

  const VaultCreatePageState.loading() : this(loadingBool: true);

  VaultCreatePageState copyWith({
    bool? confirmPageEnabledBool,
    bool? loadingBool,
    int? lastVaultIndex,
    int? mnemonicSize,
    List<String>? mnemonic,
  }) {
    return VaultCreatePageState(
      confirmPageEnabledBool: confirmPageEnabledBool ?? this.confirmPageEnabledBool,
      loadingBool: loadingBool ?? this.loadingBool,
      lastVaultIndex: lastVaultIndex ?? this.lastVaultIndex,
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  @override
  List<Object?> get props => <Object?>[confirmPageEnabledBool, loadingBool, lastVaultIndex, mnemonicSize, mnemonic];
}
