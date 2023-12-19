import 'package:snggle/shared/utils/crypto/bip/bip32/keypair/base/i_bip32_public_key.dart';

abstract interface class IBlockchainAddressEncoder<T extends IBip32PublicKey> {
  String encodePublicKey(T publicKey);
}
