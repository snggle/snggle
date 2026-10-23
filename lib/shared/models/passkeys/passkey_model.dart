import 'dart:typed_data';

import 'package:snggle/shared/models/a_list_item_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class PasskeyModel extends AListItemModel {
  final String rpId;
  final String rpName;
  final String userName;
  final String userDisplayName;
  final Uint8List userId;
  final Uint8List credentialId;
  final int algorithm;
  final int signCount;

  PasskeyModel({
    required super.id,
    required super.encryptedBool,
    required super.pinnedBool,
    required super.filesystemPath,
    required super.name,
    required this.rpId,
    required this.rpName,
    required this.userName,
    required this.userDisplayName,
    required this.userId,
    required this.credentialId,
    required this.algorithm,
    required this.signCount,
  });

  @override
  PasskeyModel copyWith({
    int? id,
    bool? encryptedBool,
    bool? pinnedBool,
    FilesystemPath? filesystemPath,
    String? name,
    String? rpId,
    String? rpName,
    String? userName,
    String? userDisplayName,
    Uint8List? userId,
    Uint8List? credentialId,
    int? algorithm,
    int? signCount,
  }) {
    return PasskeyModel(
      id: id ?? this.id,
      encryptedBool: encryptedBool ?? this.encryptedBool,
      pinnedBool: pinnedBool ?? this.pinnedBool,
      filesystemPath: filesystemPath ?? this.filesystemPath,
      name: name ?? this.name,
      rpId: rpId ?? this.rpId,
      rpName: rpName ?? this.rpName,
      userName: userName ?? this.userName,
      userDisplayName: userDisplayName ?? this.userDisplayName,
      userId: userId ?? this.userId,
      credentialId: credentialId ?? this.credentialId,
      algorithm: algorithm ?? this.algorithm,
      signCount: signCount ?? this.signCount,
    );
  }

  @override
  String get name => super.name!;

  @override
  String get defaultItemName => 'Passkey';

  @override
  List<Object?> get props => <Object?>[
    id,
    encryptedBool,
    pinnedBool,
    filesystemPath,
    name,
    rpId,
    rpName,
    userName,
    userDisplayName,
    userId,
    credentialId,
    algorithm,
    signCount,
  ];
}