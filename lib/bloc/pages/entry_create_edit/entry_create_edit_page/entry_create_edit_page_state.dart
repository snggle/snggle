import 'package:equatable/equatable.dart';

class EntryCreateEditPageState extends Equatable {
  final bool entryNameEmptyBool;
  final bool loadingBool;

  const EntryCreateEditPageState({
    this.entryNameEmptyBool = false,
    this.loadingBool = false,
  });

  const EntryCreateEditPageState.loading() : entryNameEmptyBool = false, loadingBool = true;

  EntryCreateEditPageState copyWith({
    bool? entryNameEmptyBool,
    bool? loadingBool,
  }) {
    return EntryCreateEditPageState(
      entryNameEmptyBool: entryNameEmptyBool ?? this.entryNameEmptyBool,
      loadingBool: loadingBool ?? this.loadingBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[entryNameEmptyBool, loadingBool];
}
