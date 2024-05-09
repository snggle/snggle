import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/splash_page/splash_page_cubit.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_enter_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_ignore_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/shared/router/router.gr.dart';

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
    if (splashPageState is SplashPageSetupPinState) {
      AutoRouter.of(context).replace(const AppSetupPinRoute());
    } else if (splashPageState is SplashPageEnterPinState) {
      AutoRouter.of(context).replace(const AppAuthRoute());
    } else if (splashPageState is SplashPageIgnorePinState) {
      AutoRouter.of(context).replace(const BottomNavigationRoute());
    }
  }
}
