import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/splash_page/splash_page_cubit.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_enter_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_master_key_removed.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_app_state.dart';
import 'package:snggle/shared/router/router.gr.dart';
import 'package:snggle/views/widgets/custom/dialog/short_privacy_policy_dialog.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashPageCubit splashPageCubit = SplashPageCubit();

  @override
  void initState() {
    splashPageCubit.init();
    super.initState();
  }

  @override
  void dispose() {
    splashPageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SplashPageCubit, ASplashPageState>(
        bloc: splashPageCubit,
        listener: _handleBlocListener,
        builder: (BuildContext context, ASplashPageState splashPageState) {
          if (splashPageState is SplashPageErrorState) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Error: SplashPageErrorState Error'),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  void _handleBlocListener(BuildContext context, ASplashPageState? splashPageState) {
    if (splashPageState is SplashPageSetupAppState) {
      _handleShortPolicyDialog();
    } else if (splashPageState is SplashPageMasterKeyRemovedState) {
      AutoRouter.of(context).replace(const AppMasterKeyRemovedRoute());
    } else if (splashPageState is SplashPageEnterPinState) {
      AutoRouter.of(context).replace(AppEnterPinRoute());
    }
  }

  void _handleShortPolicyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => const ShortPrivacyPolicyDialog(),
    );
  }
}
