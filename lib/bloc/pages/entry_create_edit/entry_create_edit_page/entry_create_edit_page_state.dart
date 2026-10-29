import 'package:equatable/equatable.dart';

class EntryCreateEditPageState extends Equatable {
  final bool entryNameEmptyBool;
  final bool emailInvalidBool;
  final bool loadingBool;

  const EntryCreateEditPageState({
    this.entryNameEmptyBool = false,
    this.emailInvalidBool = false,
    this.loadingBool = false,
  });

  const EntryCreateEditPageState.loading() : entryNameEmptyBool = false, emailInvalidBool = false, loadingBool = true;

  EntryCreateEditPageState copyWith({
    bool? entryNameEmptyBool,
    bool? emailInvalidBool,
    bool? loadingBool,
  }) {
    return EntryCreateEditPageState(
      entryNameEmptyBool: entryNameEmptyBool ?? this.entryNameEmptyBool,
      emailInvalidBool: emailInvalidBool ?? this.emailInvalidBool,
      loadingBool: loadingBool ?? this.loadingBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[entryNameEmptyBool, emailInvalidBool, loadingBool];
}
