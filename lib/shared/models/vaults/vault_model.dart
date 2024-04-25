import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

class VaultModel extends Equatable {
  final int index;
  final String uuid;
  final String? name;
  final FilesystemPath filesystemPath;

  VaultModel({
    required this.index,
    required this.uuid,
    this.name,
  }) : filesystemPath = FilesystemPath(<String>[uuid]);

  VaultModel copyWith({
    int? index,
    bool? encryptedBool,
    String? uuid,
    String? name,
  }) {
    return VaultModel(
      index: index ?? this.index,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => <Object?>[index, uuid, name, filesystemPath];
}
