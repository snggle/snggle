import 'package:equatable/equatable.dart';

class EntryCreatePageState extends Equatable {
  final bool entryNameEmptyBool;
  final bool loadingBool;

  const EntryCreatePageState({
    this.entryNameEmptyBool = false,
    this.loadingBool = false,
  });

  EntryCreatePageState copyWith({
    bool? entryNameEmptyBool,
    bool? loadingBool,
  }) {
    return EntryCreatePageState(
      entryNameEmptyBool: entryNameEmptyBool ?? this.entryNameEmptyBool,
      loadingBool: loadingBool ?? this.loadingBool,
    );
  }

  @override
  List<Object?> get props => <Object?>[entryNameEmptyBool, loadingBool];
}
