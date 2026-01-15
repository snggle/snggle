import 'package:equatable/equatable.dart';

abstract class AAppEnterPinPageState extends Equatable {
  final List<int> pinNumbers;

  const AAppEnterPinPageState({required this.pinNumbers});

  @override
  List<Object> get props => <Object>[pinNumbers];
}
