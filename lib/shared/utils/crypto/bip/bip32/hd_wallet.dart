import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_key_pair.dart';
import 'package:snggle/shared/utils/crypto/bip/coins_config/coin_config.dart';

/// Hierarchical Deterministic Wallet
class HDWallet extends Equatable {
  final CoinConfig coinConfig;
  final IBip32KeyPair keyPair;
  final DerivationPath derivationPath;
  final String address;

  const HDWallet({
    required this.coinConfig,
    required this.keyPair,
    required this.derivationPath,
    required this.address,
  });

  static Future<HDWallet> fromMnemonic({
    required MnemonicModel mnemonicModel,
    required CoinConfig coinConfig,
    required int addressIndex,
    int accountIndex = 0,
    int changeIndex = 0,
  }) async {
    Uint8List seedBytes = await mnemonicModel.calculateSeed();

    String derivationPathString = "${coinConfig.baseDerivationPath}/$accountIndex'/$changeIndex/$addressIndex";
    DerivationPath derivationPath = DerivationPath.parse(derivationPathString);

    IBip32KeyPair bip32keyPair = IBip32KeyPair.derive(
      derivationPath: derivationPath,
      seedBytes: seedBytes,
      ecCurveType: coinConfig.ecCurveType,
    );

    String address = coinConfig.addressEncoder.encodePublicKey(bip32keyPair.publicKey);


    return HDWallet(
      coinConfig: coinConfig,
      keyPair: bip32keyPair,
      derivationPath: derivationPath,
      address: address,
    );
  }

  @override
  List<Object?> get props => <Object>[coinConfig, keyPair, derivationPath, address];
}
