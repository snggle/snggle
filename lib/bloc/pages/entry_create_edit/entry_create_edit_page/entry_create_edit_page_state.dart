import 'package:equatable/equatable.dart';

class EntryCreateEditPageState extends Equatable {
  final bool emailInvalidBool;
  final bool entryNameEmptyBool;
  final bool loadingBool;
  final bool totpExistsBool;
  final bool totpInvalidBool;

  const EntryCreateEditPageState({
    this.entryNameEmptyBool = false,
    this.emailInvalidBool = false,
    this.loadingBool = false,
    this.totpExistsBool = false,
    this.totpInvalidBool = false,
  });

  const EntryCreateEditPageState.loading()
    : entryNameEmptyBool = false,
      emailInvalidBool = false,
      loadingBool = true,
      totpExistsBool = false,
      totpInvalidBool = false;

  EntryCreateEditPageState copyWith({
    bool? entryNameEmptyBool,
    bool? emailInvalidBool,
    bool? loadingBool,
    bool? totpExistsBool,
    bool? totpInvalidBool,
  }) {
    return EntryCreateEditPageState(
      entryNameEmptyBool: entryNameEmptyBool ?? this.entryNameEmptyBool,
      emailInvalidBool: emailInvalidBool ?? this.emailInvalidBool,
      loadingBool: loadingBool ?? this.loadingBool,
      totpExistsBool: totpExistsBool ?? this.totpExistsBool,
      totpInvalidBool: totpInvalidBool ?? this.totpInvalidBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[entryNameEmptyBool, emailInvalidBool, loadingBool, totpExistsBool, totpInvalidBool];
}
