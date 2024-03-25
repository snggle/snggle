import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/a_secrets_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/secrets_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/bottom_navigation/secrets_setup_pin_page/states/secrets_setup_pin_page_loading_state.dart';
import 'package:snggle/shared/models/a_container_model.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/generic/loading_scaffold.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

class SecretsSetupPinPage extends StatefulWidget {
  final List<AContainerModel> containerModels;

  const SecretsSetupPinPage({
    required this.containerModels,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SecretsSetupPinPageState();
}

class _SecretsSetupPinPageState extends State<SecretsSetupPinPage> {
  late final SecretsSetupPinPageCubit secretsSetupPinPageCubit = SecretsSetupPinPageCubit(containerModels: widget.containerModels);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecretsSetupPinPageCubit, ASecretsSetupPinPageState>(
      bloc: secretsSetupPinPageCubit,
      builder: (BuildContext context, ASecretsSetupPinPageState secretsSetupPinPageState) {
        if (secretsSetupPinPageState is SecretsSetupPinPageLoadingState) {
          return const LoadingScaffold();
        }

        late Widget child;

        if (secretsSetupPinPageState is SecretsSetupPinPageEnterPinState) {
          child = PinpadScaffold(
            errorBool: false,
            title: 'Setup Access PIN',
            initialPinNumbers: secretsSetupPinPageState.basePinNumbers,
            onChanged: _handleBasePinChange,
            actionButtons: <Widget>[
              if (secretsSetupPinPageState.basePinNumbers.length >= 4)
                CustomTextButton(
                  title: 'Confirm',
                  onPressed: secretsSetupPinPageCubit.setupBasePin,
                ),
            ],
          );
        } else if (secretsSetupPinPageState is SecretsSetupPinPageConfirmPinState) {
          child = PinpadScaffold(
            maxPinLength: secretsSetupPinPageState.basePinNumbers.length,
            errorBool: secretsSetupPinPageState is SecretsSetupPinPageInvalidPinState,
            title: 'Confirm PIN',
            initialPinNumbers: secretsSetupPinPageState.confirmPinNumbers,
            onChanged: (List<int> confirmPinNumbers) => _handleConfirmPinChange(secretsSetupPinPageState.basePinNumbers, confirmPinNumbers),
            actionButtons: <Widget>[
              if (secretsSetupPinPageState.confirmPinNumbers.isEmpty)
                CustomTextButton(
                  title: 'Return',
                  onPressed: secretsSetupPinPageCubit.resetToBasePin,
                ),
            ],
          );
        }

        return Material(child: child);
      },
    );
  }

  void _handleBasePinChange(List<int> pinNumbers) {
    secretsSetupPinPageCubit.updateBasePin(pinNumbers);
  }

  void _handleConfirmPinChange(List<int> basePinNumbers, List<int> confirmPinNumbers) {
    secretsSetupPinPageCubit.updateConfirmPin(confirmPinNumbers);
    if (basePinNumbers.length == confirmPinNumbers.length) {
      _trySetupPin();
    }
  }

  Future<void> _trySetupPin() async {
    try {
      await secretsSetupPinPageCubit.setupConfirmPin();
      Navigator.of(context).pop(true);
    } catch (e) {
      AppLogger().log(message: 'Provided invalid confirm PIN: $e');
    }
  }
}
