import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/a_local_pin_set_up_page_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/local_pin_set_up_page_cubit.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_confirm_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_enter_state.dart';
import 'package:snggle/bloc/pages/local_pin_page/local_pin_set_up_page/states/local_pin_set_up_page_invalid_state.dart';
import 'package:snggle/infra/exceptions/invalid_master_key_exception.dart';
import 'package:snggle/shared/models/password_model.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/custom/dialog/master_key_dialog.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class LocalPinSetUpPage extends StatefulWidget {
  final Future<void> Function(PasswordModel passwordModel) passwordValidCallback;

  const LocalPinSetUpPage({
    required this.passwordValidCallback,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _LocalPinSetUpPageState();
}

class _LocalPinSetUpPageState extends State<LocalPinSetUpPage> {
  late final LocalPinSetUpPageCubit localPinSetUpPageCubit = LocalPinSetUpPageCubit(
    passwordValidCallback: _handleValidPasswordEntered,
  );

  @override
  void dispose() {
    localPinSetUpPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalPinSetUpPageCubit, ALocalPinSetUpPageState>(
      bloc: localPinSetUpPageCubit,
      builder: (BuildContext context, ALocalPinSetUpPageState localPinSetUpPageState) {
        late Widget child;

        if (localPinSetUpPageState is LocalPinSetUpPageEnterState) {
          child = PinpadScaffold(
            errorBool: false,
            title: 'Setup Access PIN',
            initialPinNumbersList: localPinSetUpPageState.firstPinNumbers,
            onChanged: _handleFirstPinChange,
            actionButtonsList: <Widget>[
              if (localPinSetUpPageState.firstPinNumbers.length >= 4)
                CustomTextButton(
                  title: 'Confirm',
                  onPressed: localPinSetUpPageCubit.setupFirstPin,
                ),
            ],
            popButtonVisibleBool: false,
          );
        } else if (localPinSetUpPageState is LocalPinSetUpPageConfirmState) {
          child = PinpadScaffold(
            maxPinLength: localPinSetUpPageState.firstPinNumbers.length,
            errorBool: localPinSetUpPageState is LocalPinSetUpPageInvalidState,
            title: 'Confirm PIN',
            initialPinNumbersList: localPinSetUpPageState.confirmPinNumbers,
            onChanged: (List<int> confirmPinNumbers) => _handleConfirmPinChange(localPinSetUpPageState.firstPinNumbers, confirmPinNumbers),
            actionButtonsList: <Widget>[
              if (localPinSetUpPageState.confirmPinNumbers.isEmpty)
                CustomTextButton(
                  title: 'Return',
                  onPressed: localPinSetUpPageCubit.resetAllPins,
                ),
            ],
            popButtonVisibleBool: true,
            customPopVoidCallback: _handleBackButtonPressed,
          );
        }

        return PopScope(
          canPop: (localPinSetUpPageState is LocalPinSetUpPageConfirmState) == false,
          onPopInvokedWithResult: (bool didPop, _) {
            if (didPop) {
              return;
            }
            _handleBackButtonPressed();
          },
          child: Material(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleValidPasswordEntered(PasswordModel passwordModel) async {
    Navigator.of(context).pop();
    try {
      await widget.passwordValidCallback(passwordModel);
    } on InvalidMasterKeyException {
      if (mounted == false) {
        return;
      }
      await MasterKeyDialog.show(context);
    }
  }

  void _handleFirstPinChange(List<int> pinNumbersList) {
    localPinSetUpPageCubit.updateFirstPin(pinNumbersList);
  }

  void _handleConfirmPinChange(List<int> firstPinNumbersList, List<int> confirmPinNumbersList) {
    localPinSetUpPageCubit.updateConfirmPin(confirmPinNumbersList);
    if (firstPinNumbersList.length == confirmPinNumbersList.length) {
      localPinSetUpPageCubit.setupConfirmPin();
    }
  }

  void _handleBackButtonPressed() {
    if (localPinSetUpPageCubit.state is LocalPinSetUpPageConfirmState) {
      localPinSetUpPageCubit.resetAllPins();
    }
  }
}
