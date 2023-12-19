import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/big_int_utils.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/derivation_path/derivation_path_element.dart';
import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_key_pair.dart';
import 'package:snggle/shared/utils/crypto/ecdsa/points/ec_point.dart';
import 'package:snggle/shared/utils/crypto/hash/hmac.dart';

class ExtendedPrivateKey extends Equatable {
  static const List<int> _extendedPrivateKeyPrefix = <int>[0x00];

  final Uint8List privateKeyBytes;
  final Uint8List chainCodeBytes;

  const ExtendedPrivateKey({
    required this.privateKeyBytes,
    required this.chainCodeBytes,
  });

  factory ExtendedPrivateKey.fromSeed(List<int> seedBytes, List<int> hmacKeyBytes) {
    Uint8List hmac = Hmac().process(Uint8List.fromList(hmacKeyBytes), Uint8List.fromList(seedBytes));

    return ExtendedPrivateKey(
      privateKeyBytes: hmac.sublist(0, 32),
      chainCodeBytes: hmac.sublist(32),
    );
  }

  factory ExtendedPrivateKey.deriveChildKey(IBip32KeyPair keyPair, DerivationPathElement derivationPathElement, ECPoint G) {
    Uint8List privateKeyBytes = keyPair.privateKey.bytes;
    Uint8List dataBytes;
    if (derivationPathElement.isHardened) {
      dataBytes = Uint8List.fromList(<int>[..._extendedPrivateKeyPrefix, ...privateKeyBytes, ...derivationPathElement.toBytes()]);
    } else {
      dataBytes = Uint8List.fromList(<int>[...keyPair.publicKey.compressed, ...derivationPathElement.toBytes()]);
    }
    Uint8List hmacValue = Hmac().process(keyPair.privateKey.chainCodeBytes, dataBytes);

    Uint8List ilBytes = hmacValue.sublist(0, 32);
    Uint8List irBytes = hmacValue.sublist(32);

    BigInt ilInt = BigIntUtils.buildFromBytes(ilBytes);
    BigInt privKeyInt = BigIntUtils.buildFromBytes(privateKeyBytes);
    BigInt scalar = (ilInt + privKeyInt) % G.n;
    Uint8List newPrivKeyBytes = BigIntUtils.changeToBytes(scalar, length: keyPair.privateKey.length);

    return ExtendedPrivateKey(
      privateKeyBytes: newPrivKeyBytes,
      chainCodeBytes: irBytes,
    );
  }

  @override
  List<Object?> get props => <Object>[privateKeyBytes, chainCodeBytes];
}
