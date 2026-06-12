import 'package:equatable/equatable.dart';

class EntryDetailsPageState extends Equatable {
  final bool loadingBool;
  final bool totpExistsBool;
  final int totpRemainingSeconds;

  const EntryDetailsPageState({
    this.loadingBool = false,
    this.totpExistsBool = false,
    this.totpRemainingSeconds = 30,
  });

  const EntryDetailsPageState.loading()
      : loadingBool = true,
        totpExistsBool = false,
        totpRemainingSeconds = 30;

  EntryDetailsPageState copyWith({
    bool? loadingBool,
    bool? totpExistsBool,
    int? totpRemainingSeconds,
  }) {
    return EntryDetailsPageState(
      loadingBool: loadingBool ?? this.loadingBool,
      totpExistsBool: totpExistsBool ?? this.totpExistsBool,
      totpRemainingSeconds: totpRemainingSeconds ?? this.totpRemainingSeconds,
    );
  }

  @override
  List<Object> get props => <Object>[loadingBool, totpExistsBool, totpRemainingSeconds];
}
