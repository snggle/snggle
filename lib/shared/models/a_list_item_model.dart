import 'package:equatable/equatable.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

abstract class AListItemModel with EquatableMixin {
  final bool encryptedBool;
  final bool pinnedBool;
  final String uuid;
  final FilesystemPath filesystemPath;
  final String? _name;

  AListItemModel({
    required this.encryptedBool,
    required this.pinnedBool,
    required this.uuid,
    required this.filesystemPath,
    String? name,
  }) : _name = name;

  AListItemModel copyWith({bool? encryptedBool, bool? pinnedBool});

  AListItemModel setEncrypted({required bool encryptedBool}) {
    return copyWith(encryptedBool: encryptedBool);
  }

  AListItemModel setPinned({required bool pinnedBool}) {
    return copyWith(pinnedBool: pinnedBool);
  }

  String? get name => _name;

  int compareTo(AListItemModel other) {
    if (pinnedBool != other.pinnedBool) {
      return pinnedBool ? -1 : 1;
    } else {
      return name?.compareTo(other.name ?? '') ?? 0;
    }
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, pinnedBool, uuid, filesystemPath];
}
