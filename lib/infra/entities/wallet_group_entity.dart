import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/groups/wallet_group_model.dart';

class WalletGroupEntity extends Equatable {
  final bool pinnedBool;
  final String id;
  final String name;
  final String parentPath;

  const WalletGroupEntity({
    required this.pinnedBool,
    required this.id,
    required this.name,
    required this.parentPath,
  });

  factory WalletGroupEntity.fromJson(Map<String, dynamic> json) {
    return WalletGroupEntity(
      pinnedBool: json['pinned'] as bool,
      id: json['id'] as String,
      name: json['name'] as String,
      parentPath: json['parent_path'] as String,
    );
  }

  factory WalletGroupEntity.fromGroupModel(WalletGroupModel walletGroupModel) {
    return WalletGroupEntity(
      pinnedBool: walletGroupModel.pinnedBool,
      id: walletGroupModel.id,
      name: walletGroupModel.name,
      parentPath: walletGroupModel.containerPathModel.parentPath,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pinned': pinnedBool,
      'id': id,
      'name': name,
      'parent_path': parentPath,
    };
  }

  @override
  List<Object?> get props => <Object?>[pinnedBool, id, name, parentPath];
}
