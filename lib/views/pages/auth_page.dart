import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/auth_page/auth_page_cubit.dart';
import 'package:snuggle/shared/router/router.gr.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_controller.dart';
import 'package:snuggle/views/widgets/pinpad/pinpad_text_fields.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    super.key,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final PinpadController authenticatePinpadController;
  final AuthPageCubit authPageCubit = AuthPageCubit();
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
      child: BlocProvider<AuthPageCubit>(
        create: (BuildContext context) => authPageCubit,
        child: BlocConsumer<AuthPageCubit, AAuthPageState>(
          listener: _handleListener,
          builder: (BuildContext context, AAuthPageState authPageCubitState) {
            if (authPageCubitState is AuthPageErrorState) {
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
                          if (authPageCubitState is AuthPageInvalidAuthenticationState)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[Text('Incorrect pin, try again')],
                            ),
                          if (authPageCubitState is AuthPageLoadingAuthenticationState) const CircularProgressIndicator(),
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

  void _handleListener(BuildContext context, AAuthPageState authPageCubitState) {
    if (authPageCubitState is AuthPageSuccessAuthenticationState) {
      context.router.replace(MainRoute());
    }
  }

  Future<void> _onPinpadChanged() async {
    if (authenticatePinpadController.value.length == authenticatePinpadController.pinpadTextFieldsSize) {
      await authPageCubit.verifyAuthentication(pin: authenticatePinpadController.value);
      authenticatePinpadController.clear();
    }
  }

  void _onSwitchShufflePinpad({required bool value}) {
    isPinShuffledNotifier.value = value;
  }
}
