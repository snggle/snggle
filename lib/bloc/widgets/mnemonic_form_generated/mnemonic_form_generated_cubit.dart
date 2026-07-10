import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/widgets/mnemonic_form_generated/mnemonic_form_generated_state.dart';

class MnemonicFormGeneratedCubit extends Cubit<MnemonicFormGeneratedState> {
  MnemonicFormGeneratedCubit() : super(const MnemonicFormGeneratedState());

  void toggleObscureText() {
    emit(
      state.copyWith(obscureTextBool: state.obscureTextBool == false),
    );
  }

  void updateStatementAccepted({required bool statementAcceptedBool}) {
    emit(
      state.copyWith(statementAcceptedBool: statementAcceptedBool),
    );
  }

  void updateScrolledBottom({required bool scrolledBottomBool}) {
    if (state.scrolledBottomBool == scrolledBottomBool) {
      return;
    }

    emit(
      state.copyWith(scrolledBottomBool: scrolledBottomBool),
    );
  }
}
