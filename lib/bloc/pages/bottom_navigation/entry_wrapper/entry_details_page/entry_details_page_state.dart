import 'package:equatable/equatable.dart';

class EntryDetailsPageState extends Equatable {
  final bool loadingBool;

  const EntryDetailsPageState({
    this.loadingBool = false,
  });

  const EntryDetailsPageState.loading() : loadingBool = true;

  EntryDetailsPageState copyWith({
    bool? loadingBool,
  }) {
    return EntryDetailsPageState(
      loadingBool: loadingBool ?? this.loadingBool,
    );
  }

  @override
  List<Object> get props => <Object>[loadingBool];
}
