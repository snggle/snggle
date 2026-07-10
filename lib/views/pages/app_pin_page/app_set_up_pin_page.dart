import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/a_app_set_up_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/app_set_up_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_loading_state.dart';
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
class AppSetUpPinPage extends StatefulWidget {
  final AppMasterKeyType? _appMasterKeyType;
  final AppPinType _appPinType;
  final MnemonicModel? _mnemonicModel;

  const AppSetUpPinPage({
    this._appMasterKeyType,
    this._appPinType = AppPinType.setUpPin,
    this._mnemonicModel,
    super.key,
  });

  @override
  State<AppSetUpPinPage> createState() => _AppSetUpPinPageState();
}

class _AppSetUpPinPageState extends State<AppSetUpPinPage> {
  late final AppSetUpPinPageCubit _appSetUpPinPageCubit;

  @override
  void initState() {
    super.initState();
    _appSetUpPinPageCubit = AppSetUpPinPageCubit(
      appMasterKeyType: widget._appMasterKeyType,
      appPinType: widget._appPinType,
      mnemonicModel: widget._mnemonicModel,
    );
  }

  @override
  void dispose() {
    _appSetUpPinPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool appPinTypeChangeBool = widget._appPinType == AppPinType.changePin;
    Widget childWidget;

    return BlocBuilder<AppSetUpPinPageCubit, AAppSetUpPinPageState>(
      bloc: _appSetUpPinPageCubit,
      builder: (BuildContext context, AAppSetUpPinPageState appSetUpPinPageState) {
        bool canPopBool = appSetUpPinPageState is! AppSetUpPinPageConfirmPinState;
        if (appSetUpPinPageState is AppSetUpPinPageLoadingState) {
          return const LoadingScaffold();
        }
        if (appSetUpPinPageState is AppSetUpPinPageEnterPinState) {
          childWidget = PinpadScaffold(
            errorBool: false,
            title: 'Set up Access PIN',
            initialPinNumbers: appSetUpPinPageState.firstPinNumbers,
            onChanged: _handleFirstPinChange,
            actionButtons: <Widget>[
              if (appSetUpPinPageState.firstPinNumbers.length >= 4)
                CustomTextButton(
                  title: 'Confirm',
                  onPressed: _appSetUpPinPageCubit.setUpFirstPin,
                ),
            ],
            popButtonVisible: true,
          );
        } else if (appSetUpPinPageState is AppSetUpPinPageConfirmPinState) {
          childWidget = PinpadScaffold(
            maxPinLength: appSetUpPinPageState.firstPinNumbers.length,
            errorBool: appSetUpPinPageState is AppSetUpPinPageInvalidPinState,
            title: 'Confirm PIN',
            initialPinNumbers: appSetUpPinPageState.confirmPinNumbers,
            onChanged: (List<int> confirmPinNumbers) => _handleConfirmPinChange(
              appSetUpPinPageState.firstPinNumbers,
              confirmPinNumbers,
            ),
            actionButtons: <Widget>[
              if (appSetUpPinPageState.confirmPinNumbers.isEmpty)
                CustomTextButton(
                  title: 'Return',
                  onPressed: _appSetUpPinPageCubit.resetAllPins,
                ),
            ],
            popButtonVisible: true,
          );
        } else {
          childWidget = const SizedBox.shrink();
        }
        return PopScope<void>(
          canPop: canPopBool,
          onPopInvokedWithResult: (bool didPop, _) async {
            await _pressBackButton(
              appSetUpPinPageState: appSetUpPinPageState,
              appPinTypeChangeBool: appPinTypeChangeBool,
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

  void _handleFirstPinChange(List<int> pinNumbers) {
    _appSetUpPinPageCubit.updateFirstPin(pinNumbers);
  }

  void _handleConfirmPinChange(
    List<int> firstPinNumbersList,
    List<int> confirmPinNumbersList,
  ) {
    _appSetUpPinPageCubit.updateConfirmPin(confirmPinNumbersList);
    if (firstPinNumbersList.length == confirmPinNumbersList.length) {
      _trySetupPin();
    }
  }

  Future<void> _pressBackButton({
    required AAppSetUpPinPageState appSetUpPinPageState,
    required bool appPinTypeChangeBool,
    required bool didPop,
  }) async {
    if (didPop) {
      return;
    } else if (appSetUpPinPageState is AppSetUpPinPageConfirmPinState) {
      _appSetUpPinPageCubit.resetAllPins();
      return;
    } else if (appPinTypeChangeBool && appSetUpPinPageState is AppSetUpPinPageEnterPinState) {
      await context.router.replaceAll(<PageRouteInfo>[const SettingsRoute()]);
      return;
    }

    context.router.pop();
  }

  Future<void> _trySetupPin() async {
    try {
      await _appSetUpPinPageCubit.setUpConfirmPin();
      if (mounted == false) {
        return;
      }
      if (widget._appPinType == AppPinType.changePin) {
        context.router.pop();
        return;
      } else {
        bool recoverTypeBool = widget._appMasterKeyType == AppMasterKeyType.recover;
        await _showMasterKeySuccessDialog(recoverTypeBool: recoverTypeBool);
      }
    } catch (e) {
      AppLogger().log(message: 'Provided invalid confirm PIN');
    }
  }

  Future<void> _showMasterKeySuccessDialog({required bool recoverTypeBool}) async {
    StackRouter rootRouter = context.router.root;
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
              onPressed: () async {
                await rootRouter.replaceAll(
                  <PageRouteInfo>[const BottomNavigationRoute()],
                );
                if (dialogContext.mounted && ModalRoute.of(dialogContext)?.isCurrent == true) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
