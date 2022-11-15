import 'dart:typed_data';

import 'package:snuggle/infra/dao/secrets_dao_type.dart';
import 'package:snuggle/infra/dao/wallet/a_wallet_secrets_dao.dart';
import 'package:snuggle/shared/enum_utils.dart';

class WalletDecryptedSecretsDao extends AWalletSecretsDao {
  final Uint8List privateKey;

  const WalletDecryptedSecretsDao({
    required this.privateKey,
  }) : super(type: SecretsDaoType.decrypted);
  
  factory WalletDecryptedSecretsDao.fromJson(Map<String, dynamic> json) {
    List<dynamic> unparsedSeed = json['private_key'] as List<dynamic>;
    return WalletDecryptedSecretsDao(
      privateKey: Uint8List.fromList(unparsedSeed.map((dynamic e) => e as int).toList()),
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': EnumUtils.parseToString(type.toString()),
      'private_key': privateKey,
    };
  }

  @override
  List<Object?> get props => <Object>[privateKey];
}