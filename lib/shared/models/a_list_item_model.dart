import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/groups/group_model.dart';
import 'package:snggle/shared/utils/filesystem_path.dart';

abstract class AListItemModel with EquatableMixin {
  final int id;
  final bool encryptedBool;
  final bool pinnedBool;
  final FilesystemPath filesystemPath;
  final String? _name;

  AListItemModel({
    required this.id,
    required this.encryptedBool,
    required this.pinnedBool,
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
    bool currentIsGroupBool = this is GroupModel;

    bool typesEqualBool = runtimeType == other.runtimeType;
    bool pinnedEqualBool = pinnedBool == other.pinnedBool;

    if (typesEqualBool && pinnedEqualBool) {
      return name?.compareTo(other.name ?? '') ?? 0;
    } else if (pinnedEqualBool) {
      return currentIsGroupBool ? -1 : 1;
    } else {
      return pinnedBool ? -1 : 1;
    }
  }

  @override
  List<Object?> get props => <Object?>[id, encryptedBool, pinnedBool, filesystemPath];
}
