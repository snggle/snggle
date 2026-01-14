import 'package:equatable/equatable.dart';

class EntryDetailsPageState extends Equatable {
  final bool loadingBool;
  final bool totpExistsBool;
  final int totpRemainingSeconds;
  final int totpPeriod;

  const EntryDetailsPageState({
    this.loadingBool = false,
    this.totpExistsBool = false,
    this.totpRemainingSeconds = 0,
    this.totpPeriod = 30,
  });

  const EntryDetailsPageState.loading()
      : loadingBool = true,
        totpExistsBool = false,
        totpRemainingSeconds = 0,
        totpPeriod = 30;

  EntryDetailsPageState copyWith({
    bool? loadingBool,
    bool? totpExistsBool,
    int? totpRemainingSeconds,
    int? totpPeriod,
  }) {
    return EntryDetailsPageState(
      loadingBool: loadingBool ?? this.loadingBool,
      totpExistsBool: totpExistsBool ?? this.totpExistsBool,
      totpRemainingSeconds: totpRemainingSeconds ?? this.totpRemainingSeconds,
      totpPeriod: totpPeriod ?? this.totpPeriod,
    );
  }

  @override
  List<Object> get props => <Object>[loadingBool, totpExistsBool, totpRemainingSeconds, totpPeriod];
}
