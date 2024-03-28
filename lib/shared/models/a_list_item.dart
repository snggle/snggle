import 'package:equatable/equatable.dart';

class AListItem with EquatableMixin {
  late bool encryptedBool;
  late bool pinnedBool;

  AListItem({
    required this.encryptedBool,
    required this.pinnedBool,
  });
  
  void setEncrypted({required bool encryptedBool}) {
    this.encryptedBool = encryptedBool;
  }
  
  void setPinned({required bool pinnedBool}) {
    this.pinnedBool = pinnedBool;
  }

  @override
  List<Object?> get props => <Object?>[encryptedBool, pinnedBool];
}
