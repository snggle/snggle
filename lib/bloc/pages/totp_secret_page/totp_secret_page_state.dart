import 'package:equatable/equatable.dart';

class TotpSecretPageState extends Equatable {
  final bool secretInvalidBool;

  const TotpSecretPageState({this.secretInvalidBool = false});

  @override
  List<Object?> get props => <Object?>[secretInvalidBool];
}
