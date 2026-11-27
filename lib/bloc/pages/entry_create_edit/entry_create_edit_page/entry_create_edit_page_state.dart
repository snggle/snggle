import 'package:equatable/equatable.dart';

class EntryCreateEditPageState extends Equatable {
  final bool emailInvalidBool;
  final bool entryNameEmptyBool;
  final bool loadingBool;
  final bool totpExistsBool;

  const EntryCreateEditPageState({
    this.entryNameEmptyBool = false,
    this.emailInvalidBool = false,
    this.loadingBool = false,
    this.totpExistsBool = false,
  });

  const EntryCreateEditPageState.loading()
    : entryNameEmptyBool = false,
      emailInvalidBool = false,
      loadingBool = true,
      totpExistsBool = false;

  EntryCreateEditPageState copyWith({
    bool? entryNameEmptyBool,
    bool? emailInvalidBool,
    bool? loadingBool,
    bool? totpExistsBool,
  }) {
    return EntryCreateEditPageState(
      entryNameEmptyBool: entryNameEmptyBool ?? this.entryNameEmptyBool,
      emailInvalidBool: emailInvalidBool ?? this.emailInvalidBool,
      loadingBool: loadingBool ?? this.loadingBool,
      totpExistsBool: totpExistsBool ?? this.totpExistsBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[entryNameEmptyBool, emailInvalidBool, loadingBool, totpExistsBool];
}
