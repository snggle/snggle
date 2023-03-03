import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/app_auth_page/app_auth_page_cubit.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_error_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_invalid_password_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_load_state.dart';
import 'package:snggle/bloc/app_auth_page/states/app_auth_page_success_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/pinpad/pinpad.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_controller.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_text_fields.dart';

class AppAuthPage extends StatefulWidget {
  const AppAuthPage({
    super.key,
  });

  @override
  State<AppAuthPage> createState() => _AppAuthPageState();
}

class _AppAuthPageState extends State<AppAuthPage> {
  final AppAuthPageCubit appAuthPageCubit = AppAuthPageCubit();
  final ValueNotifier<bool> isPinObscuredNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isShufflingEnabledNotifier = ValueNotifier<bool>(false);

  late final PinpadController authPinpadController;

  @override
  void initState() {
    super.initState();
    authPinpadController = PinpadController(pinpadTextFieldsSize: 4);
    authPinpadController.requestFirstFocus();
  }

  @override
  void dispose() {
    authPinpadController.dispose();
    isShufflingEnabledNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocProvider<AppAuthPageCubit>(
          create: (BuildContext context) => appAuthPageCubit,
          child: BlocConsumer<AppAuthPageCubit, AAppAuthPageState>(
            builder: _handleBlocBuilder,
            listener: _handleBlocListener,
          ),
        ),
      ),
    );
  }

  Widget _handleBlocBuilder(BuildContext context, AAppAuthPageState appAuthPageState) {
    if (appAuthPageState is AppAuthPageErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text('Error: [AppAuthPage] Initial Page Setup failed'),
            CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text('Sign in'),
                  ],
                ),
                if (appAuthPageState is AppAuthPageInvalidPasswordState)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[Text('Incorrect pin, try again')],
                  ),
                if (appAuthPageState is AppAuthPageLoadState) const CircularProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ValueListenableBuilder<bool>(
                      valueListenable: isPinObscuredNotifier,
                      builder: (BuildContext context, bool value, _) {
                        return PinpadTextFields(
                          obscureText: isPinObscuredNotifier.value,
                          pinpadController: authPinpadController,
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
                      valueListenable: isShufflingEnabledNotifier,
                      builder: (BuildContext context, bool value, _) {
                        return Switch(
                          value: isShufflingEnabledNotifier.value,
                          onChanged: (bool value) => _enablePinpadShuffling(value: value),
                        );
                      },
                    ),
                  ],
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: isShufflingEnabledNotifier,
                  builder: (BuildContext context, bool value, _) {
                    return AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Pinpad(
                        pinpadController: authPinpadController,
                        pinpadShuffle: isShufflingEnabledNotifier.value,
                        onChanged: _verifyPin,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  void _handleBlocListener(BuildContext context, AAppAuthPageState appAuthPageState) {
    if (appAuthPageState is AppAuthPageSuccessState) {
      context.router.replace(const BottomNavigationRoute());
    }
  }

  void _enablePinpadShuffling({required bool value}) {
    isShufflingEnabledNotifier.value = value;
  }

  void _onToggleObscureText() {
    isPinObscuredNotifier.value = !isPinObscuredNotifier.value;
  }

  Future<void> _verifyPin() async {
    bool isPinLengthFull = authPinpadController.value.length == authPinpadController.pinpadTextFieldsSize;
    if (isPinLengthFull) {
      await appAuthPageCubit.authenticate(password: authPinpadController.value);
    }
  }
}
