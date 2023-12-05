import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/splash_page/splash_page_cubit.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_enter_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_ignore_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/shared/router/router.gr.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  final SplashPageCubit _splashPageCubit = SplashPageCubit();

  SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SplashPageCubit, ASplashPageState>(
        bloc: _splashPageCubit,
        builder: _handleBlocBuilder,
        listener: _handleBlocListener,
      ),
    );
  }

  Widget _handleBlocBuilder(BuildContext context, ASplashPageState splashPageState) {
    if (splashPageState is SplashPageLoadingState) {
      _splashPageCubit.init();
    } else if (splashPageState is SplashPageErrorState) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Error: SplashPageErrorState Error'),
        ],
      );
    }
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
        ],
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
