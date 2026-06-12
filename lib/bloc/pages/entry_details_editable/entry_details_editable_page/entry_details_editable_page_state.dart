import 'package:equatable/equatable.dart';

class EntryDetailsEditablePageState extends Equatable {
  final bool entryNameEmptyBool;
  final bool totpInvalidBool;
  final bool loadingBool;
  final bool totpExistsBool;

  const EntryDetailsEditablePageState({
    this.entryNameEmptyBool = false,
    this.totpInvalidBool = false,
    this.loadingBool = false,
    this.totpExistsBool = false,
  });

  const EntryDetailsEditablePageState.loading()
      : entryNameEmptyBool = false,
        totpInvalidBool = false,
        loadingBool = true,
        totpExistsBool = false;

  EntryDetailsEditablePageState copyWith({
    bool? entryNameEmptyBool,
    bool? totpInvalidBool,
    bool? loadingBool,
    bool? totpExistsBool,
  }) {
    return EntryDetailsEditablePageState(
      entryNameEmptyBool: entryNameEmptyBool ?? this.entryNameEmptyBool,
      totpInvalidBool: totpInvalidBool ?? this.totpInvalidBool,
      loadingBool: loadingBool ?? this.loadingBool,
      totpExistsBool: totpExistsBool ?? this.totpExistsBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[entryNameEmptyBool, totpInvalidBool, loadingBool, totpExistsBool];
}
