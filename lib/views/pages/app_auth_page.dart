import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/pages/app_auth_page/a_app_auth_page_state.dart';
import 'package:snggle/bloc/pages/app_auth_page/app_auth_page_cubit.dart';
import 'package:snggle/bloc/pages/app_auth_page/states/app_auth_page_invalid_pin_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/shared/utils/logger/app_logger.dart';
import 'package:snggle/views/widgets/button/custom_text_button.dart';
import 'package:snggle/views/widgets/pinpad/pinpad_scaffold.dart';

@RoutePage()
class AppAuthPage extends StatefulWidget {
  const AppAuthPage({
    super.key,
  });

  @override
  State<AppAuthPage> createState() => _AppAuthPageState();
}

class _AppAuthPageState extends State<AppAuthPage> {
  final AppAuthPageCubit appAuthPageCubit = AppAuthPageCubit();

  @override
  void dispose() {
    appAuthPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppAuthPageCubit, AAppAuthPageState>(
      bloc: appAuthPageCubit,
      builder: (BuildContext context, AAppAuthPageState appAuthPageState) {
        return PinpadScaffold(
          errorBool: appAuthPageState is AppAuthPageInvalidPinState,
          title: 'Sign in',
          initialPinNumbers: appAuthPageState.pinNumbers,
          onChanged: appAuthPageCubit.updatePinNumbers,
          actionButtons: <Widget>[
            CustomTextButton(
              title: 'Sign in',
              onPressed: _handleSignInButtonPressed,
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSignInButtonPressed() async {
    try {
      await appAuthPageCubit.authenticate();
      await AutoRouter.of(context).replace(const BottomNavigationRoute());
    } catch (e) {
      AppLogger().log(message: 'Provided invalid PIN');
    }
  }
}
