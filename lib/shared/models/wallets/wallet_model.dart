import 'package:equatable/equatable.dart';

class WalletModel extends Equatable {
  final int index;
  final String uuid;
  final String vaultUuid;
  final String address;
  final String derivationPath;
  final String? name;

  const WalletModel({
    required this.index,
    required this.uuid,
    required this.vaultUuid,
    required this.address,
    required this.derivationPath,
    this.name,
  });

  @override
  List<Object?> get props => <Object?>[index, uuid, vaultUuid, address, derivationPath, name];
}
