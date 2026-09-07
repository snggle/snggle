import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/a_app_pin_enter_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/app_pin_enter_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_enter_page/states/app_pin_enter_page_invalid_state.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_banner.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

@RoutePage()
class AppPinEnterPage extends StatefulWidget {
  final AppPinType appPinType;

  const AppPinEnterPage({
    this.appPinType = AppPinType.enter,
    super.key,
  });

  @override
  State<AppPinEnterPage> createState() => _AppPinEnterPageState();
}

class _AppPinEnterPageState extends State<AppPinEnterPage> {
  final AppPinEnterPageCubit _appPinEnterPageCubit = AppPinEnterPageCubit();
  late PinpadKeyboardState _initPinpadKeyboardState = PinpadKeyboardState.initPinpadKeyboardState;

  @override
  void dispose() {
    _appPinEnterPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool appPinTypeChangeBool = widget.appPinType == AppPinType.change;
    String title = appPinTypeChangeBool ? 'Enter current PIN' : 'Enter PIN';

    return BlocBuilder<AppPinEnterPageCubit, AAppPinEnterPageState>(
      bloc: _appPinEnterPageCubit,
      builder: (BuildContext context, AAppPinEnterPageState appPinEnterPageState) {
        String? textWarning = _getTextWarning(appPinTypeChangeBool: appPinTypeChangeBool, appPinEnterPageState: appPinEnterPageState);
        return PinpadScaffold(
          header: textWarning != null ? PinpadBanner(text: textWarning) : null,
          errorBool: appPinEnterPageState is AppPinEnterPageInvalidState,
          title: title,
          initialPinNumbersList: appPinEnterPageState.pinNumbers,
          onChanged: _appPinEnterPageCubit.updatePinNumbers,
          actionButtonsList: <Widget>[
            CustomTextButton(
              title: 'Confirm',
              onPressed: () => _pressConfirmButton(
                appPinTypeChangeBool: appPinTypeChangeBool,
              ),
            ),
          ],
          popButtonVisibleBool: appPinTypeChangeBool,
          onKeyboardChanged: _handleKeyboardChanged,
          initPinpadKeyboardState: _initPinpadKeyboardState,
        );
      },
    );
  }

  String? _getTextWarning({required bool appPinTypeChangeBool, required AAppPinEnterPageState appPinEnterPageState}) {
    if (appPinTypeChangeBool) {
      return null;
    }

    int attemptsLeft = appPinEnterPageState.attemptsLeft;
    String warningText;

    if (attemptsLeft >= 3) {
      return null;
    } else if (attemptsLeft == 2) {
      warningText = 'Invalid PIN. Two attempts left.';
    } else {
      warningText = 'Invalid PIN. Last attempt left.';
    }

    return warningText;
  }

  Future<void> _pressConfirmButton({required bool appPinTypeChangeBool}) async {
    try {
      await _appPinEnterPageCubit.authenticate(appPinType: widget.appPinType);
      if (appPinTypeChangeBool) {
        await AutoRouter.of(context).replace(AppPinSetUpRoute(appPinType: AppPinType.change, initPinpadKeyboardState: _initPinpadKeyboardState));
      } else {
        await AutoRouter.of(context).replaceAll(<PageRouteInfo>[const BottomNavigationRoute()]);
      }
    } catch (e) {
      AppLogger().log(message: 'Provided invalid PIN');
      bool attemptsLeftBool = _appPinEnterPageCubit.state.attemptsLeft == 0;
      bool appPinTypeEnterBool = appPinTypeChangeBool == false;
      bool masterKeyRemovalBool = attemptsLeftBool && appPinTypeEnterBool;
      if (masterKeyRemovalBool) {
        await AutoRouter.of(context).replaceAll(<PageRouteInfo>[const AppMasterKeyRemovedRoute()]);
      }
    }
  }

  void _handleKeyboardChanged(PinpadKeyboardState pinpadKeyboardState) {
    _initPinpadKeyboardState = pinpadKeyboardState;
  }
}
