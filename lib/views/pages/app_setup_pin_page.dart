import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/app_setup_pin_page/app_setup_pin_page_cubit.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_confirm_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_invalid_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_setup_later_state.dart';
import 'package:snggle/bloc/app_setup_pin_page/states/app_setup_pin_page_success_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/pinpad/pinpad.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_controller.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_text_fields.dart';

@RoutePage()
class AppSetupPinPage extends StatefulWidget {
  const AppSetupPinPage({super.key});

  @override
  State<AppSetupPinPage> createState() => _AppSetupPinPageState();
}

class _AppSetupPinPageState extends State<AppSetupPinPage> {
  int maxPinLength = 4;
  ValueNotifier<int> pinLengthNotifier = ValueNotifier<int>(0);
  ValueNotifier<bool> isPinObscuredNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> isPinShuffledNotifier = ValueNotifier<bool>(false);

  late final PinpadController setupPinpadController;
  late final PinpadController confirmPinpadController;

  @override
  void initState() {
    super.initState();
    setupPinpadController = PinpadController(pinpadTextFieldsSize: maxPinLength);
    confirmPinpadController = PinpadController(pinpadTextFieldsSize: maxPinLength);
    setupPinpadController.requestFirstFocus();
  }

  @override
  void dispose() {
    pinLengthNotifier.dispose();
    isPinObscuredNotifier.dispose();
    isPinShuffledNotifier.dispose();
    setupPinpadController.dispose();
    confirmPinpadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppSetupPinPageCubit>(
      create: (BuildContext context) => AppSetupPinPageCubit(
        setupPinpadController: setupPinpadController,
        confirmPinpadController: confirmPinpadController,
      ),
      child: Scaffold(
        body: BlocConsumer<AppSetupPinPageCubit, AAppSetupPinPageState>(
          builder: _handleBuilder,
          listener: _handleListener,
        ),
      ),
    );
  }

  Widget _handleBuilder(BuildContext context, AAppSetupPinPageState appSetupPinPageState) {
    bool isConfirmState = appSetupPinPageState is AppSetupPinPageConfirmState;
    PinpadController currentPinpadController = isConfirmState ? confirmPinpadController : setupPinpadController;
    pinLengthNotifier = ValueNotifier<int>(0);

    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(isConfirmState ? 'Repeat Access PIN' : 'Setup Access PIN'),
                ],
              ),
              if (appSetupPinPageState is AppSetupPinPageInvalidState)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Text('Incorrect pin, try again')],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ValueListenableBuilder<bool>(
                    valueListenable: isPinObscuredNotifier,
                    builder: (BuildContext context, bool value, _) {
                      return PinpadTextFields(
                        obscureText: isPinObscuredNotifier.value,
                        pinpadController: currentPinpadController,
                      );
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: isPinObscuredNotifier,
                    builder: (BuildContext context, bool value, _) {
                      return InkWell(
                        onTap: _onToggleObscureText,
                        child: Icon(
                          isPinObscuredNotifier.value ? Icons.visibility : Icons.visibility_off,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Shuffle Keyboard'),
                  ValueListenableBuilder<bool>(
                    valueListenable: isPinShuffledNotifier,
                    builder: (BuildContext context, bool value, _) {
                      return Switch(
                        value: isPinShuffledNotifier.value,
                        onChanged: (bool value) => _onSwitchShufflePinpad(value: value),
                      );
                    },
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: Listenable.merge(
                  <ValueNotifier<dynamic>>[
                    isPinShuffledNotifier,
                    pinLengthNotifier,
                  ],
                ),
                builder: (BuildContext context, _) {
                  return AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Pinpad(
                      pinpadController: currentPinpadController,
                      pinpadShuffle: isPinShuffledNotifier.value,
                      onChanged: () => pinLengthNotifier.value = currentPinpadController.value.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () => isConfirmState ? _onCancelConfirmState(context) : _onSetupLater(context),
              child: isConfirmState ? const Text('Cancel') : const Text('Setup Later'),
            ),
            ValueListenableBuilder<int>(
              valueListenable: pinLengthNotifier,
              builder: (BuildContext context, int value, _) {
                bool isPinpadTextFieldsFilled = currentPinpadController.value.length == maxPinLength;

                return Visibility(
                  visible: isPinpadTextFieldsFilled,
                  child: TextButton(
                    onPressed: () => context.read<AppSetupPinPageCubit>().updateState(),
                    child: isConfirmState ? const Text('Confirm') : const Text('Next'),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  void _handleListener(BuildContext context, AAppSetupPinPageState? appSetupPinPageState) {
    if (appSetupPinPageState is AppSetupPinPageSuccessState) {
      AutoRouter.of(context).replace(const AppLifecycleWrapperRoute(children: <PageRouteInfo>[BottomNavigationRoute()]));
    } else if (appSetupPinPageState is AppSetupPinPageSetupLaterState) {
      AutoRouter.of(context).replace(const AppLifecycleWrapperRoute(children: <PageRouteInfo>[BottomNavigationRoute()]));
    }
  }

  void _onCancelConfirmState(BuildContext context) {
    context.read<AppSetupPinPageCubit>().cancelConfirmState();
  }

  void _onSetupLater(BuildContext context) {
    context.read<AppSetupPinPageCubit>().setupLater();
  }

  void _onSwitchShufflePinpad({required bool value}) {
    isPinShuffledNotifier.value = value;
  }

  void _onToggleObscureText() {
    isPinObscuredNotifier.value = !isPinObscuredNotifier.value;
  }
}
