import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:snggle/shared/models/groups/network_group_model.dart';
import 'package:snggle/shared/models/networks/network_type.dart';
import 'package:snggle/shared/utils/enum_storage_codec.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

@Entity()
// ignore_for_file: must_be_immutable
/*
All fields of a class which extends Equatable should be immutable, but ObjectBox
requires the `id` field to be mutable because its value is set after an instance of
the class has been created.  Because of this, we ignore the linter rule
"must_be_immutable" on all ObjectBox entities.
*/
class NetworkGroupEntity extends Equatable {
  // ObjectBox persists `networkType` via the `dbNetworkType` string column,
  // so this codec maps stable storage IDs to `NetworkType` enum values.
  static final EnumStorageCodec<NetworkType> _networkTypeCodec = EnumStorageCodec<NetworkType>(<NetworkType, String>{
    NetworkType.ethereum: 'ethereum',
    NetworkType.solana: 'solana',
  });

  @Id()
  int id;
  final bool encryptedBool;
  final bool pinnedBool;
  @Index()
  final String filesystemPathString;
  final String name;
  String? dbNetworkType;

  NetworkGroupEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.filesystemPathString,
    required this.name,
    required this.dbNetworkType,
    NetworkType? networkType,
  }) {
    if (networkType != null) {
      this.networkType = networkType;
    }
  }

  @Transient()
  NetworkType get networkType => _networkTypeCodec.fromStorageValue(dbNetworkType)!;

  set networkType(NetworkType? networkType) {
    dbNetworkType = _networkTypeCodec.toStorageValue(networkType);
  }

  factory NetworkGroupEntity.fromNetworkGroupModel(NetworkGroupModel networkGroupModel) {
    return NetworkGroupEntity(
      id: networkGroupModel.id,
      encryptedBool: networkGroupModel.encryptedBool,
      pinnedBool: networkGroupModel.pinnedBool,
      filesystemPathString: networkGroupModel.filesystemPath.fullPath,
      name: networkGroupModel.name,
      networkType: networkGroupModel.networkTemplateModel.networkType,
      dbNetworkType: _networkTypeCodec.toStorageValue(networkGroupModel.networkTemplateModel.networkType),
    );
  }

  NetworkGroupEntity copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    String? filesystemPathString,
    String? name,
    NetworkType? networkType,
    String? dbNetworkType,
  }) {
    return NetworkGroupEntity(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
      name: name ?? this.name,
      networkType: networkType,
      dbNetworkType: dbNetworkType ?? this.dbNetworkType,
    );
  }

  @Transient()
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, filesystemPathString, name, dbNetworkType];
}
