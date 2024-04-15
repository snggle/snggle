import 'package:equatable/equatable.dart';

abstract class ATimedPinConfirmationPageState extends Equatable {
  final List<int> pinNumbers;

  const ATimedPinConfirmationPageState({required this.pinNumbers});

  @override
  List<Object> get props => <Object>[pinNumbers];
}
