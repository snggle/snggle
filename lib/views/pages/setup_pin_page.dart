import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/setup_pin_page/setup_pin_page_cubit.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_confirm_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_fail_state.dart';
import 'package:snuggle/bloc/setup_pin_page/states/setup_pin_page_success_state.dart';
import 'package:snuggle/shared/router/router.gr.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_controller.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_text_fields.dart';

class SetupPinPage extends StatefulWidget {
  const SetupPinPage({super.key});

  @override
  State<SetupPinPage> createState() => _SetupPinPageState();
}

class _SetupPinPageState extends State<SetupPinPage> {
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
    return BlocProvider<SetupPinPageCubit>(
      create: (BuildContext context) => SetupPinPageCubit(
        setupPinpadController: setupPinpadController,
        confirmPinpadController: confirmPinpadController,
      ),
      child: Scaffold(
        body: BlocConsumer<SetupPinPageCubit, ASetupPinPageState>(
          listener: _onPinpadSuccessState,
          builder: (BuildContext context, ASetupPinPageState setupPinPageState) {
            bool isConfirmState = setupPinPageState is SetupPinPageConfirmState || setupPinPageState is SetupPinPageFailState;
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
                      if (setupPinPageState is SetupPinPageFailState)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[Text('Incorrect pin, try again')],
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
                                key: const Key('shuffle_switch'),
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
                      onPressed: () => isConfirmState ? _onCancelConfirmState(context) : _onSetupLater(),
                      child: isConfirmState ? const Text('Cancel') : const Text('Setup Later'),
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: pinLengthNotifier,
                      builder: (BuildContext context, int value, _) {
                        bool isPinpadTextFieldsFilled = currentPinpadController.value.length == maxPinLength;

                        return Visibility(
                          visible: isPinpadTextFieldsFilled,
                          child: TextButton(
                            onPressed: () => context.read<SetupPinPageCubit>().updateState(),
                            child: isConfirmState ? const Text('Confirm') : const Text('Next'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onCancelConfirmState(BuildContext context) {
    context.read<SetupPinPageCubit>().cancelConfirmState();
  }

  void _onPinpadSuccessState(BuildContext context, ASetupPinPageState? setupPinPageState) {
    if (setupPinPageState is SetupPinPageSuccessState) {
      AutoRouter.of(context).replace(const EmptyRoute());
    }
  }

  void _onSetupLater() {
    AutoRouter.of(context).replace(const EmptyRoute());
  }

  void _onSwitchShufflePinpad({required bool value}) {
    isPinShuffledNotifier.value = value;
  }

  void _onToggleObscureText() {
    isPinObscuredNotifier.value = !isPinObscuredNotifier.value;
  }
}
