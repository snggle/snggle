import 'package:snuggle/infra/dao/secrets_dao_type.dart';
import 'package:snuggle/infra/dao/wallet/a_wallet_secrets_dao.dart';
import 'package:snuggle/shared/enum_utils.dart';

class WalletEncryptedSecretsDao extends AWalletSecretsDao {
  final String hash;

  const WalletEncryptedSecretsDao({
    required this.hash,
  }) : super(type: SecretsDaoType.encrypted);
  
  factory WalletEncryptedSecretsDao.fromJson(Map<String, dynamic> json) {
    return WalletEncryptedSecretsDao(
      hash: json['hash'] as String,
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': EnumUtils.parseToString(type.toString()),
      'hash': hash,
    };
  }
  
  @override
  List<Object?> get props => <Object>[hash];
}
