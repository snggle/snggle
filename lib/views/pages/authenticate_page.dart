import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/authenticate_page/authenticate_page_cubit.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_error_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_invalid_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_load_state.dart';
import 'package:snuggle/bloc/authenticate_page/states/authenticate_page_success_state.dart';
import 'package:snuggle/shared/router/router.gr.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_controller.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_text_fields.dart';

class AuthenticatePage extends StatefulWidget {
  const AuthenticatePage({
    super.key,
  });

  @override
  State<AuthenticatePage> createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {
  late final PinpadController authenticatePinpadController;
  final AuthenticatePageCubit authenticatePageCubit = AuthenticatePageCubit();
  ValueNotifier<bool> isPinShuffledNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    authenticatePinpadController = PinpadController(pinpadTextFieldsSize: 4);
    authenticatePinpadController.requestFirstFocus();
  }

  @override
  void dispose() {
    authenticatePinpadController.dispose();
    isPinShuffledNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<AuthenticatePageCubit>(
        create: (BuildContext context) => authenticatePageCubit,
        child: BlocConsumer<AuthenticatePageCubit, AAuthenticatePageState>(
          listener: _handleListener,
          builder: (BuildContext context, AAuthenticatePageState authenticatePageCubitState) {
            if (authenticatePageCubitState is AuthenticatePageErrorState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text('Error: Initial Page Setup failed'),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            } else {
              return Scaffold(
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text('Authenticate'),
                            ],
                          ),
                          if (authenticatePageCubitState is AuthenticatePageInvalidState)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[Text('Incorrect pin, try again')],
                            ),
                          if (authenticatePageCubitState is AuthenticatePageLoadState) const CircularProgressIndicator(),
                          PinpadTextFields(
                            pinpadController: authenticatePinpadController,
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
                          ValueListenableBuilder<bool>(
                            valueListenable: isPinShuffledNotifier,
                            builder: (BuildContext context, bool value, _) {
                              return AspectRatio(
                                aspectRatio: 1 / 1,
                                child: Pinpad(
                                  pinpadController: authenticatePinpadController,
                                  pinpadShuffle: isPinShuffledNotifier.value,
                                  onChanged: _onPinpadChanged,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, AAuthenticatePageState authenticatePageCubitState) {
    if (authenticatePageCubitState is AuthenticatePageSuccessState) {
      context.router.replace(const EmptyRoute());
    }
  }

  Future<void> _onPinpadChanged() async {
    if (authenticatePinpadController.value.length == authenticatePinpadController.pinpadTextFieldsSize) {
      await authenticatePageCubit.verifyAuthentication(pin: authenticatePinpadController.value);
      authenticatePinpadController.clear();
    }
  }

  void _onSwitchShufflePinpad({required bool value}) {
    isPinShuffledNotifier.value = value;
  }
}
