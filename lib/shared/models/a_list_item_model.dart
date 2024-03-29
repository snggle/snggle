import 'package:equatable/equatable.dart';

abstract class AListItemModel with EquatableMixin {
  late bool encryptedBool;
  late bool pinnedBool;

  AListItemModel({
    required this.encryptedBool,
    required this.pinnedBool,
  });

  AListItemModel copyWith({bool? encryptedBool, bool? pinnedBool});

  AListItemModel setEncrypted({required bool encryptedBool}) {
    return copyWith(encryptedBool: encryptedBool);
  }

  AListItemModel setPinned({required bool pinnedBool}) {
    return copyWith(pinnedBool: pinnedBool);
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, pinnedBool];
}
