import 'package:equatable/equatable.dart';

class EntryDetailsEditablePageState extends Equatable {
  final bool entryNameEmptyBool;
  final bool loadingBool;

  const EntryDetailsEditablePageState({
    this.entryNameEmptyBool = false,
    this.loadingBool = false,
  });

  const EntryDetailsEditablePageState.loading()
      : entryNameEmptyBool = false,
        loadingBool = true;

  EntryDetailsEditablePageState copyWith({
    bool? entryNameEmptyBool,
    bool? loadingBool,
  }) {
    return EntryDetailsEditablePageState(
      entryNameEmptyBool: entryNameEmptyBool ?? this.entryNameEmptyBool,
      loadingBool: loadingBool ?? this.loadingBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[entryNameEmptyBool, loadingBool];
}
