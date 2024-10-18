import 'package:equatable/equatable.dart';

class VaultCreatePageState extends Equatable {
  final bool confirmPageEnabledBool;
  final bool loadingBool;
  final bool mnemonicRepeatedBool;
  final int? mnemonicSize;
  final List<String>? mnemonic;

  const VaultCreatePageState({
    this.confirmPageEnabledBool = false,
    this.loadingBool = false,
    this.mnemonicRepeatedBool = false,
    this.mnemonicSize,
    this.mnemonic,
  });

  const VaultCreatePageState.loading() : this(loadingBool: true);

  VaultCreatePageState copyWith({
    bool? confirmPageEnabledBool,
    bool? loadingBool,
    bool? mnemonicRepeatedBool,
    int? lastVaultIndex,
    int? mnemonicSize,
    List<String>? mnemonic,
  }) {
    return VaultCreatePageState(
      confirmPageEnabledBool: confirmPageEnabledBool ?? this.confirmPageEnabledBool,
      loadingBool: loadingBool ?? this.loadingBool,
      mnemonicRepeatedBool: mnemonicRepeatedBool ?? this.mnemonicRepeatedBool,
      mnemonicSize: mnemonicSize ?? this.mnemonicSize,
      mnemonic: mnemonic ?? this.mnemonic,
    );
  }

  @override
  List<Object?> get props => <Object?>[confirmPageEnabledBool, loadingBool, mnemonicRepeatedBool, mnemonicSize, mnemonic];
}
