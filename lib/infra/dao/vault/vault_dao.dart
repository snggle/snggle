import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/dao/vault/a_vault_secrets_dao.dart';
import 'package:snuggle/infra/dao/wallet/wallet_dao.dart';

class VaultDao extends Equatable {
  final String id;
  final String name;
  final AVaultSecretsDao vaultSecretsDao;
  final Map<String, WalletDao> walletDaoMap;

  const VaultDao({
    required this.id,
    required this.name,
    required this.vaultSecretsDao,
    required this.walletDaoMap,
  });
  
  factory VaultDao.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> walletDaoMapJson = json['wallets'] as Map<String, dynamic>;
    Map<String, WalletDao> walletDaoMap = <String, WalletDao>{};

    walletDaoMapJson.forEach((String key, dynamic value) { 
      walletDaoMap[key] = WalletDao.fromJson(value as Map<String, dynamic>);
    });
    
    return VaultDao(
      id: json['id'] as String,
      name: json['name'] as String,
      vaultSecretsDao: AVaultSecretsDao.fromJson(json['secrets'] as Map<String, dynamic>),
      walletDaoMap: walletDaoMap,
    );
  }
  
  Map<String, dynamic> toJson() {
    Map<String, dynamic> walletDaoMapJson = <String, dynamic>{};

    walletDaoMap.forEach((String key, WalletDao value) { 
      walletDaoMapJson[key] = value.toJson();
    });
    
    return <String, dynamic>{
      'id': id,
      'name': name,
      'secrets': vaultSecretsDao.toJson(),
      'wallets': walletDaoMapJson,
    };
  }
  
  @override
  List<Object?> get props => <Object>[id, name, vaultSecretsDao, walletDaoMap];
}
