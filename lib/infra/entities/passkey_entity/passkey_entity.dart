import 'package:equatable/equatable.dart';
import 'package:isar_community/isar.dart';
import 'package:snggle/shared/models/passkeys/passkey_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

part 'passkey_entity.g.dart';

@Collection(accessor: 'passkeys', ignore: <String>{'props', 'stringify', 'hashCode'})
class PasskeyEntity extends Equatable {
  final Id id;
  final bool encryptedBool;
  final bool pinnedBool;

  final String rpId;
  final String rpName;
  final String userName;
  final String userDisplayName;

  final List<int> userId;
  final List<int> credentialId;

  final int algorithm;
  final int signCount;

  @Index()
  final String filesystemPathString;

  final String name;

  const PasskeyEntity({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
    required this.rpId,
    required this.rpName,
    required this.userName,
    required this.userDisplayName,
    required this.userId,
    required this.credentialId,
    required this.algorithm,
    required this.signCount,
    required this.filesystemPathString,
    required this.name,
  });

  factory PasskeyEntity.fromPasskeyModel(PasskeyModel passkeyModel) {
    return PasskeyEntity(
      id: passkeyModel.id,
      encryptedBool: passkeyModel.encryptedBool,
      pinnedBool: passkeyModel.pinnedBool,
      rpId: passkeyModel.rpId,
      rpName: passkeyModel.rpName,
      userName: passkeyModel.userName,
      userDisplayName: passkeyModel.userDisplayName,
      userId: passkeyModel.userId,
      credentialId: passkeyModel.credentialId,
      algorithm: passkeyModel.algorithm,
      signCount: passkeyModel.signCount,
      filesystemPathString: passkeyModel.filesystemPath.fullPath,
      name: passkeyModel.name,
    );
  }

  PasskeyEntity copyWith({
    Id? id,
    bool? encryptedBool,
    bool? pinnedBool,
    String? rpId,
    String? rpName,
    String? userName,
    String? userDisplayName,
    List<int>? userId,
    List<int>? credentialId,
    int? algorithm,
    int? signCount,
    String? filesystemPathString,
    String? name,
  }) {
    return PasskeyEntity(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      rpId: rpId ?? this.rpId,
      rpName: rpName ?? this.rpName,
      userName: userName ?? this.userName,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      userId: userId ?? this.userId,
      credentialId: credentialId ?? this.credentialId,
      algorithm: algorithm ?? this.algorithm,
      signCount: signCount ?? this.signCount,
      filesystemPathString: filesystemPathString ?? this.filesystemPathString,
      name: name ?? this.name,
    );
  }

  @ignore
  FilesystemPath get filesystemPath => FilesystemPath.fromString(filesystemPathString);

  @override
  List<Object?> get props => <Object?>[
    id,
    encryptedBool,
    pinnedBool,
    rpId,
    rpName,
    userName,
    userDisplayName,
    userId,
    credentialId,
    algorithm,
    signCount,
    filesystemPathString,
    name,
  ];
}
