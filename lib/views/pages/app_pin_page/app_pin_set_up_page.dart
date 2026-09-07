import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/a_app_pin_set_up_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/app_pin_set_up_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_confirm_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_enter_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_page_loading_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_set_up_page/states/app_pin_set_up_pin_page_invalid_state.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart';
import 'package:snggle/shared/models/mnemonic_model.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/app_master_key/app_master_key_type.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog.dart';
import 'package:snggle/views/widgets/custom/dialog/custom_dialog_option.dart';
import 'package:snggle/views/widgets/generic/loading_scaffold.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

@RoutePage()
class AppPinSetUpPage extends StatefulWidget {
  final AppMasterKeyType? _appMasterKeyType;
  final AppPinType _appPinType;
  final MnemonicModel? _mnemonicModel;
  final PinpadKeyboardState _initPinpadKeyboardState;

  const AppPinSetUpPage({
    this._appMasterKeyType,
    this._appPinType = AppPinType.setUp,
    this._mnemonicModel,
    this._initPinpadKeyboardState = PinpadKeyboardState.initPinpadKeyboardState,
    super.key,
  });

  @override
  State<AppPinSetUpPage> createState() => _AppPinSetUpPageState();
}

class _AppPinSetUpPageState extends State<AppPinSetUpPage> {
  late AppPinSetUpPageCubit _appPinSetUpPageCubit;
  late PinpadKeyboardState _pinpadKeyboardState;

  @override
  void initState() {
    super.initState();
    _pinpadKeyboardState = widget._initPinpadKeyboardState;
    _appPinSetUpPageCubit = AppPinSetUpPageCubit(
      appMasterKeyType: widget._appMasterKeyType,
      appPinType: widget._appPinType,
      mnemonicModel: widget._mnemonicModel,
    );
  }

  @override
  void dispose() {
    _appPinSetUpPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool appPinTypeChangeBool = widget._appPinType == AppPinType.change;
    Widget childWidget;

    return BlocBuilder<AppPinSetUpPageCubit, AAppPinSetUpPageState>(
      bloc: _appPinSetUpPageCubit,
      builder: (BuildContext context, AAppPinSetUpPageState appPinSetUpPageState) {
        bool canPopBool = appPinSetUpPageState is! AppPinSetUpPageConfirmState && appPinTypeChangeBool == false;
        if (appPinSetUpPageState is AppPinSetUpPageLoadingState) {
          return const LoadingScaffold();
        }
        if (appPinSetUpPageState is AppPinSetUpPageEnterState) {
          childWidget = PinpadScaffold(
            initPinpadKeyboardState: _pinpadKeyboardState,
            onKeyboardChanged: _handleKeyboardChanged,
            errorBool: false,
            title: 'Set up Access PIN',
            initialPinNumbersList: appPinSetUpPageState.firstPinNumbers,
            onChanged: _handleFirstPinChanged,
            actionButtonsList: <Widget>[
              if (appPinSetUpPageState.firstPinNumbers.length >= 4)
                CustomTextButton(
                  title: 'Confirm',
                  onPressed: _appPinSetUpPageCubit.setUpFirstPin,
                ),
            ],
            popButtonVisibleBool: true,
          );
        } else if (appPinSetUpPageState is AppPinSetUpPageConfirmState) {
          childWidget = PinpadScaffold(
            initPinpadKeyboardState: _pinpadKeyboardState,
            onKeyboardChanged: _handleKeyboardChanged,
            maxPinLength: appPinSetUpPageState.firstPinNumbers.length,
            errorBool: appPinSetUpPageState is AppPinSetUpPageInvalidState,
            title: 'Confirm PIN',
            initialPinNumbersList: appPinSetUpPageState.confirmPinNumbers,
            onChanged: (List<int> confirmPinNumbers) => _handleConfirmPinChange(
              appPinSetUpPageState.firstPinNumbers,
              confirmPinNumbers,
            ),
            actionButtonsList: <Widget>[
              if (appPinSetUpPageState.confirmPinNumbers.isEmpty)
                CustomTextButton(
                  title: 'Return',
                  onPressed: _appPinSetUpPageCubit.resetAllPins,
                ),
            ],
            popButtonVisibleBool: true,
            customPopVoidCallback: () async {
              await _pressBackButton(
                appPinSetUpPageState: appPinSetUpPageState,
                didPop: false,
              );
            },
          );
        } else {
          childWidget = const SizedBox.shrink();
        }
        return PopScope<void>(
          canPop: canPopBool,
          onPopInvokedWithResult: (bool didPop, _) async {
            await _pressBackButton(
              appPinSetUpPageState: appPinSetUpPageState,
              didPop: didPop,
            );
          },
          child: Material(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: childWidget,
            ),
          ),
        );
      },
    );
  }

  void _handleFirstPinChanged(List<int> pinNumbersList) {
    _appPinSetUpPageCubit.updateFirstPin(pinNumbersList);
  }

  void _handleKeyboardChanged(PinpadKeyboardState pinpadKeyboardState) {
    _pinpadKeyboardState = pinpadKeyboardState;
  }

  void _handleConfirmPinChange(List<int> firstPinNumbersList, List<int> confirmPinNumbersList) {
    _appPinSetUpPageCubit.updateConfirmPin(confirmPinNumbersList);
    if (firstPinNumbersList.length == confirmPinNumbersList.length) {
      _tryPinSetUp();
    }
  }

  Future<void> _pressBackButton({required AAppPinSetUpPageState appPinSetUpPageState, required bool didPop}) async {
    if (didPop) {
      return;
    }

    bool appPinTypeChangeBool = widget._appPinType == AppPinType.change;

    if (appPinSetUpPageState is AppPinSetUpPageConfirmState) {
      _appPinSetUpPageCubit.resetAllPins();
      return;
    }
    if (appPinTypeChangeBool && appPinSetUpPageState is AppPinSetUpPageEnterState) {
      await context.router.root.replaceAll(
        <PageRouteInfo>[
          const BottomNavigationRoute(
            children: <PageRouteInfo>[
              SettingsSectionWrapperRoute(children: <PageRouteInfo>[SettingsRoute()]),
            ],
          ),
        ],
      );
      return;
    }

    context.router.pop();
  }

  Future<void> _tryPinSetUp() async {
    try {
      await _appPinSetUpPageCubit.setUpConfirmPin();
      if (mounted == false) {
        return;
      }
      if (widget._appPinType == AppPinType.change) {
        context.router.pop();
        return;
      } else {
        bool recoverTypeBool = widget._appMasterKeyType == AppMasterKeyType.recover;
        await _showMasterKeySuccessDialog(recoverTypeBool: recoverTypeBool);

        await context.router.replaceAll(<PageRouteInfo>[const BottomNavigationRoute()]);
      }
    } catch (e) {
      AppLogger().log(message: 'Provided invalid confirm PIN');
    }
  }

  Future<void> _showMasterKeySuccessDialog({required bool recoverTypeBool}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return CustomDialog(
          title: 'Success',
          content: Text(
            textAlign: TextAlign.center,
            recoverTypeBool ? 'Your Master Key has been successfully recovered.' : 'Your new Master Key has been successfully created.',
          ),
          backgroundColor: Colors.white,
          options: <CustomDialogOption>[
            CustomDialogOption(
              label: 'Continue',
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
          ],
        );
      },
    );
  }
}
