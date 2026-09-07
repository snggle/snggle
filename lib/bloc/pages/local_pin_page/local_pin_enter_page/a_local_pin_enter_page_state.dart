import 'package:equatable/equatable.dart';

abstract class ALocalPinEnterPageState extends Equatable {
  final List<int> pinNumbers;

  const ALocalPinEnterPageState({required this.pinNumbers});

  @override
  List<Object> get props => <Object>[pinNumbers];
}
