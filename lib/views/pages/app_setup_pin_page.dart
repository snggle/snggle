import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/a_app_setup_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/app_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/app_setup_pin_page/states/app_setup_pin_page_loading_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/generic/loading_scaffold.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

@RoutePage()
class AppSetupPinPage extends StatefulWidget {
  const AppSetupPinPage({super.key});

  @override
  State<AppSetupPinPage> createState() => _AppSetupPinPageState();
}

class _AppSetupPinPageState extends State<AppSetupPinPage> {
  final AppSetupPinPageCubit appSetupPinPageCubit = AppSetupPinPageCubit();

  @override
  void dispose() {
    appSetupPinPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSetupPinPageCubit, AAppSetupPinPageState>(
      bloc: appSetupPinPageCubit,
      builder: (BuildContext context, AAppSetupPinPageState appSetupPinPageState) {
        if (appSetupPinPageState is AppSetupPinPageLoadingState) {
          return const LoadingScaffold();
        }

        late Widget child;

        if (appSetupPinPageState is AppSetupPinPageEnterPinState) {
          child = PinpadScaffold(
            errorBool: false,
            title: 'Setup Access PIN',
            initialPinNumbers: appSetupPinPageState.firstPinNumbers,
            onChanged: _handleFirstPinChange,
            actionButtons: <Widget>[
              if (appSetupPinPageState.firstPinNumbers.isEmpty)
                CustomTextButton(
                  title: 'Setup Later',
                  onPressed: _handleSetupLaterPressed,
                ),
              if (appSetupPinPageState.firstPinNumbers.length >= 4)
                CustomTextButton(
                  title: 'Confirm',
                  onPressed: appSetupPinPageCubit.setupFirstPin,
                ),
            ],
          );
        } else if (appSetupPinPageState is AppSetupPinPageConfirmPinState) {
          child = PinpadScaffold(
            maxPinLength: appSetupPinPageState.firstPinNumbers.length,
            errorBool: appSetupPinPageState is AppSetupPinPageInvalidPinState,
            title: 'Confirm PIN',
            initialPinNumbers: appSetupPinPageState.confirmPinNumbers,
            onChanged: (List<int> confirmPinNumbers) => _handleConfirmPinChange(appSetupPinPageState.firstPinNumbers, confirmPinNumbers),
            actionButtons: <Widget>[
              if (appSetupPinPageState.confirmPinNumbers.isEmpty)
                CustomTextButton(
                  title: 'Return',
                  onPressed: appSetupPinPageCubit.resetAllPins,
                ),
            ],
          );
        }

        return PopScope(
          canPop: (appSetupPinPageState is AppSetupPinPageConfirmPinState) == false,
          onPopInvoked: _handleBackButtonPressed,
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

  void _handleFirstPinChange(List<int> pinNumbers) {
    appSetupPinPageCubit.updateFirstPin(pinNumbers);
  }

  void _handleConfirmPinChange(List<int> firstPinNumbers, List<int> confirmPinNumbers) {
    appSetupPinPageCubit.updateConfirmPin(confirmPinNumbers);
    if (firstPinNumbers.length == confirmPinNumbers.length) {
      _trySetupPin();
    }
  }

  Future<void> _trySetupPin() async {
    try {
      await appSetupPinPageCubit.setupConfirmPin();
      await AutoRouter.of(context).replace(const BottomNavigationRoute());
    } catch (e) {
      AppLogger().log(message: 'Provided invalid confirm PIN');
    }
  }

  Future<void> _handleSetupLaterPressed() async {
    await appSetupPinPageCubit.setupDefaultPin();
    await AutoRouter.of(context).replace(const BottomNavigationRoute());
  }

  void _handleBackButtonPressed(bool didPopBool) {
    if (appSetupPinPageCubit.state is AppSetupPinPageConfirmPinState) {
      appSetupPinPageCubit.resetAllPins();
    }
  }
}
