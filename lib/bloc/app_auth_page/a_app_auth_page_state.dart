import 'package:equatable/equatable.dart';

abstract class AAppAuthPageState extends Equatable {
  final List<int> pinNumbers;

  const AAppAuthPageState({required this.pinNumbers});

  @override
  List<Object> get props => <Object>[pinNumbers];
}
