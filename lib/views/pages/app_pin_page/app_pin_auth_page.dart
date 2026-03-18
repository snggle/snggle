import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/a_app_pin_auth_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/app_pin_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_pin_auth_page/states/app_pin_auth_page_invalid_state.dart';
import 'package:snggle/bloc/widgets/pinpad/pinpad_keyboard/pinpad_keyboard_state.dart';
import 'package:snggle/shared/native/app_launch_context.dart';
import 'package:snggle/shared/native/app_launch_mode.dart';
import 'package:snggle/shared/native/native_app_launch.dart';
import 'package:snggle/shared/native/native_autofill_auth.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_banner.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

@RoutePage()
class AppPinAuthPage extends StatefulWidget {
  final AppPinType appPinType;

  const AppPinAuthPage({
    this.appPinType = AppPinType.auth,
    super.key,
  });

  @override
  State<AppPinAuthPage> createState() => _AppPinAuthPageState();
}

class _AppPinAuthPageState extends State<AppPinAuthPage> {
  final AppPinAuthPageCubit _appPinAuthPageCubit = AppPinAuthPageCubit();
  late PinpadKeyboardState _initPinpadKeyboardState = PinpadKeyboardState.initPinpadKeyboardState;

  @override
  void dispose() {
    _appPinAuthPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool appPinTypeChangeBool = widget.appPinType == AppPinType.change;
    String title = appPinTypeChangeBool ? 'Enter current PIN' : 'Enter PIN';

    return BlocBuilder<AppPinAuthPageCubit, AAppPinAuthPageState>(
      bloc: _appPinAuthPageCubit,
      builder: (BuildContext context, AAppPinAuthPageState appPinAuthPageState) {
        String? textWarning = _getTextWarning(appPinTypeChangeBool: appPinTypeChangeBool, appPinAuthPageState: appPinAuthPageState);
        return PopScope(
            canPop: true,
            onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            NativeAutofillAuth.cancel();
          }
        },
        child: PinpadScaffold(
          header: textWarning != null ? PinpadBanner(text: textWarning) : null,
          errorBool: appPinAuthPageState is AppPinAuthPageInvalidState,
          title: title,
          initialPinNumbersList: appPinAuthPageState.pinNumbers,
          onChanged: _appPinAuthPageCubit.updatePinNumbers,
          actionButtonsList: <Widget>[
            CustomTextButton(
              title: 'Confirm',
              onPressed: () => _pressConfirmButton(
                appPinTypeChangeBool: appPinTypeChangeBool,
              ),
            ),
          ],
          popButtonVisibleBool: appPinTypeChangeBool,
          customPopVoidCallback: () async {
            await _pressBackButton(appPinTypeChangeBool: appPinTypeChangeBool);
          },
          onKeyboardChanged: _handleKeyboardChanged,
          initPinpadKeyboardState: _initPinpadKeyboardState,
        ),
        );
      },
    );
  }

  String? _getTextWarning({required bool appPinTypeChangeBool, required AAppPinAuthPageState appPinAuthPageState}) {
    if (appPinTypeChangeBool) {
      return null;
    }

    int attemptsLeft = appPinAuthPageState.attemptsLeft;
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

  Future<void> _pressBackButton({required bool appPinTypeChangeBool}) async {
    if (appPinTypeChangeBool) {
      await context.router.root.maybePop();
    }
  }

  Future<void> _pressConfirmButton({required bool appPinTypeChangeBool}) async {
    AppLaunchContext launchContext = await NativeAppLaunch.getContext();

    try {
      await _appPinAuthPageCubit.authenticate(appPinType: widget.appPinType);
      if (appPinTypeChangeBool) {
        await AutoRouter.of(context).replace(AppPinSetUpRoute(appPinType: AppPinType.change, initPinpadKeyboardState: _initPinpadKeyboardState));
      } else {
        switch (launchContext.appLaunchMode) {
          case AppLaunchMode.autofillAuth:
            await AutoRouter.of(context).replaceAll(<PageRouteInfo>[const ReadOnlyEntriesSectionWrapperRoute()]);

          case AppLaunchMode.main:
            await AutoRouter.of(context).replaceAll(<PageRouteInfo>[const BottomNavigationRoute()]);
        }
      }
    } catch (e) {
      AppLogger().log(message: 'Provided invalid PIN');
      bool attemptsLeftBool = _appPinAuthPageCubit.state.attemptsLeft == 0;
      bool appPinTypeEnterBool = appPinTypeChangeBool == false;
      bool masterKeyRemovalBool = attemptsLeftBool && appPinTypeEnterBool;
      if (masterKeyRemovalBool) {
        await AutoRouter.of(context).replaceAll(<PageRouteInfo>[AppMasterKeyRemovedRoute(appLaunchMode: launchContext.appLaunchMode)]);
      }
    }
  }

  void _handleKeyboardChanged(PinpadKeyboardState pinpadKeyboardState) {
    _initPinpadKeyboardState = pinpadKeyboardState;
  }
}
