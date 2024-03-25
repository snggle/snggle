import 'package:equatable/equatable.dart';

abstract class ASecretsAuthPageState extends Equatable {
  final List<int> pinNumbers;

  const ASecretsAuthPageState({required this.pinNumbers});

  @override
  List<Object> get props => <Object>[pinNumbers];
}
