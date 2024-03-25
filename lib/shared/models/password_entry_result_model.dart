import 'package:equatable/equatable.dart';
import 'package:snggle/shared/models/password_model.dart';

class PasswordEntryResultModel extends Equatable {
  final bool validBool;
  final PasswordModel? passwordModel;

  const PasswordEntryResultModel({
    required this.validBool,
    required this.passwordModel,
  });

  bool get isValid => validBool && passwordModel != null;

  @override
  List<Object?> get props => <Object?>[validBool, passwordModel];
}
