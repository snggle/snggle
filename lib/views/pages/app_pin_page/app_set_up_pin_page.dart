import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/a_app_set_up_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/app_set_up_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_confirm_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_enter_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_invalid_pin_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_set_up_pin_page/states/app_set_up_pin_page_loading_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/generic/loading_scaffold.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

@RoutePage()
class AppSetUpPinPage extends StatefulWidget {
  final AppPinType appPinType;

  const AppSetUpPinPage({
    super.key,
    this.appPinType = AppPinType.setUpPin,
  });

  @override
  State<AppSetUpPinPage> createState() => _AppSetUpPinPageState();
}

class _AppSetUpPinPageState extends State<AppSetUpPinPage> {
  late final AppSetUpPinPageCubit appSetupPinPageCubit;

  @override
  void initState() {
    super.initState();
    appSetupPinPageCubit = AppSetUpPinPageCubit(appPinType: widget.appPinType);
  }

  @override
  void dispose() {
    appSetupPinPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool appPinTypeChangeBool = widget.appPinType == AppPinType.changePin;
    Widget childWidget;

    return BlocBuilder<AppSetUpPinPageCubit, AAppSetUpPinPageState>(
      bloc: appSetupPinPageCubit,
      builder: (BuildContext context, AAppSetUpPinPageState appSetUpPinPageState) {
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
                  onPressed: appSetupPinPageCubit.setUpFirstPin,
                ),
            ],
            popButtonVisible: appPinTypeChangeBool,
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
                  onPressed: appSetupPinPageCubit.resetAllPins,
                ),
            ],
            popButtonVisible: true,
          );
        } else {
          childWidget = const SizedBox.shrink();
        }
        return PopScope(
          canPop: _isPopAllowed(
            changePinFlowBool: appPinTypeChangeBool,
            appSetUpPinPageState: appSetUpPinPageState,
          ),
          onPopInvoked: (bool didPop) async {
            appSetupPinPageCubit.resetAllPins();
            if (appPinTypeChangeBool && appSetUpPinPageState is AppSetUpPinPageEnterPinState) {
              await context.router.replaceAll(<PageRouteInfo>[const SettingsRoute()]);
              return;
            }
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
    appSetupPinPageCubit.updateFirstPin(pinNumbers);
  }

  void _handleConfirmPinChange(
    List<int> firstPinNumbers,
    List<int> confirmPinNumbers,
  ) {
    appSetupPinPageCubit.updateConfirmPin(confirmPinNumbers);
    if (firstPinNumbers.length == confirmPinNumbers.length) {
      _trySetupPin();
    }
  }

  bool _isPopAllowed({
    required bool changePinFlowBool,
    required AAppSetUpPinPageState appSetUpPinPageState,
  }) {
    if (appSetUpPinPageState is AppSetUpPinPageConfirmPinState || changePinFlowBool) {
      return false;
    }
    return true;
  }

  Future<void> _trySetupPin() async {
    try {
      await appSetupPinPageCubit.setUpConfirmPin();
      if (widget.appPinType == AppPinType.changePin) {
        await context.router.pop();
        return;
      } else {
        await context.router.replaceAll(<PageRouteInfo>[const BottomNavigationRoute()]);
      }
    } catch (e) {
      AppLogger().log(message: 'Provided invalid confirm PIN');
    }
  }
}
