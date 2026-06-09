import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/a_app_enter_pin_page_state.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/app_enter_pin_page_cubit.dart';
import 'package:snggle/bloc/pages/app_pin_page/app_enter_pin_page/states/app_enter_invalid_pin_page_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/pages/app_pin_page/app_pin_type.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_banner.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

@RoutePage()
class AppEnterPinPage extends StatefulWidget {
  final AppPinType appPinType;

  const AppEnterPinPage({
    this.appPinType = AppPinType.enterPin,
    super.key,
  });

  @override
  State<AppEnterPinPage> createState() => _AppEnterPinPageState();
}

class _AppEnterPinPageState extends State<AppEnterPinPage> {
  final AppEnterPinPageCubit _appEnterPinPageCubit = AppEnterPinPageCubit();

  @override
  void dispose() {
    _appEnterPinPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool appPinTypeChangeBool = widget.appPinType == AppPinType.changePin;
    String title = appPinTypeChangeBool ? 'Enter current PIN' : 'Enter PIN';

    return BlocBuilder<AppEnterPinPageCubit, AAppEnterPinPageState>(
      bloc: _appEnterPinPageCubit,
      builder: (BuildContext context, AAppEnterPinPageState appEnterPinPageState) {
        String? textWarning = _getTextWarning(appPinTypeChangeBool: appPinTypeChangeBool, appEnterPinPageState: appEnterPinPageState);
        return PinpadScaffold(
          header: textWarning != null ? PinpadBanner(text: textWarning) : null,
          errorBool: appEnterPinPageState is AppEnterInvalidPinPageState,
          title: title,
          initialPinNumbers: appEnterPinPageState.pinNumbers,
          onChanged: _appEnterPinPageCubit.updatePinNumbers,
          actionButtons: <Widget>[
            CustomTextButton(
              title: 'Confirm',
              onPressed: () => _pressConfirmButton(
                appPinTypeChangeBool: appPinTypeChangeBool,
              ),
            ),
          ],
          popButtonVisible: appPinTypeChangeBool,
        );
      },
    );
  }

  String? _getTextWarning({required bool appPinTypeChangeBool, required AAppEnterPinPageState appEnterPinPageState}) {
    if (appPinTypeChangeBool) {
      return null;
    }

    int attemptsLeft = appEnterPinPageState.attemptsLeft;
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
      await _appEnterPinPageCubit.authenticate(appPinType: widget.appPinType);
      if (appPinTypeChangeBool) {
        await AutoRouter.of(context).replace(AppSetUpPinRoute(appPinType: AppPinType.changePin));
      } else {
        await AutoRouter.of(context).replaceAll(<PageRouteInfo>[const BottomNavigationRoute()]);
      }
    } catch (e) {
      AppLogger().log(message: 'Provided invalid PIN');
      bool attemptsLeftBool = _appEnterPinPageCubit.state.attemptsLeft == 0;
      bool appPinTypeEnterBool = appPinTypeChangeBool == false;
      bool masterKeyRemovalBool = attemptsLeftBool && appPinTypeEnterBool;
      if (masterKeyRemovalBool) {
        await AutoRouter.of(context).replaceAll(<PageRouteInfo>[const AppMasterKeyRemovedRoute()]);
      }
    }
  }
}
