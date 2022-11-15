import 'package:equatable/equatable.dart';
import 'package:snuggle/infra/dao/wallet/a_wallet_secrets_dao.dart';

class WalletDao extends Equatable {
  final String id;
  final String name;
  final String address;
  final AWalletSecretsDao walletSecretsDao;

  const WalletDao({
    required this.id,
    required this.name,
    required this.address,
    required this.walletSecretsDao,
  });

  factory WalletDao.fromJson(Map<String, dynamic> json) {
    return WalletDao(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      walletSecretsDao: AWalletSecretsDao.fromJson(json['secrets'] as Map<String, dynamic>),
    );
  }
  
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'secrets': walletSecretsDao.toJson(),
    };
  }
  
  @override
  List<Object?> get props => <Object>[id, name, address, walletSecretsDao];
}