import 'package:equatable/equatable.dart';

class EntryCreatePageState extends Equatable {
  final bool entryNameEmptyBool;
  final bool loadingBool;
  final bool totpExistsBool;
  final int totpRemainingSeconds;
  final int totpPeriod;

  const EntryCreatePageState({
    this.entryNameEmptyBool = false,
    this.loadingBool = false,
    this.totpExistsBool = false,
    this.totpRemainingSeconds = 0,
    this.totpPeriod = 30,
  });

  EntryCreatePageState copyWith({
    bool? entryNameEmptyBool,
    bool? loadingBool,
    bool? totpExistsBool,
    int? totpRemainingSeconds,
    int? totpPeriod,
  }) {
    return EntryCreatePageState(
      entryNameEmptyBool: entryNameEmptyBool ?? this.entryNameEmptyBool,
      loadingBool: loadingBool ?? this.loadingBool,
      totpExistsBool: totpExistsBool ?? this.totpExistsBool,
      totpRemainingSeconds: totpRemainingSeconds ?? this.totpRemainingSeconds,
      totpPeriod: totpPeriod ?? this.totpPeriod,
    );
  }

  @override
  List<Object?> get props => <Object?>[entryNameEmptyBool, loadingBool, totpExistsBool, totpRemainingSeconds, totpPeriod];
}
