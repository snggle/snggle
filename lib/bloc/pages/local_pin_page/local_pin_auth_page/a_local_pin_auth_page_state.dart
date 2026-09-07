import 'package:equatable/equatable.dart';

abstract class ALocalPinAuthPageState extends Equatable {
  final List<int> pinNumbers;

  const ALocalPinAuthPageState({required this.pinNumbers});

  @override
  List<Object> get props => <Object>[pinNumbers];
}
