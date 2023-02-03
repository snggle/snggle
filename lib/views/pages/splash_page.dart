import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snggle/bloc/splash_page/splash_page_cubit.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_error_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_ignore_pin_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_loading_state.dart';
import 'package:snggle/bloc/splash_page/states/splash_page_setup_pin_state.dart';
import 'package:snggle/shared/router/router.gr.dart';

class SplashPage extends StatelessWidget {
  final SplashPageCubit _splashPageCubit = SplashPageCubit();
  SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<SplashPageCubit, ASplashPageState>(
          bloc: _splashPageCubit,
          builder: _handleBuilder,
          listener: _handleListener,
        ),
      ),
    );
  }

  Widget _handleBuilder(BuildContext context, ASplashPageState splashPageState) {
    if (splashPageState is SplashPageLoadingState) {
      _splashPageCubit.init();
    } else if (splashPageState is SplashPageErrorState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Text('Error: SplashPageErrorState Error'),
        ],
      );
    }
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        CircularProgressIndicator(),
      ],
    ));
  }

  void _handleListener(BuildContext context, ASplashPageState? splashPageState) {
    if (splashPageState is SplashPageSetupPinState) {
      AutoRouter.of(context).push(const SetupPinRoute());
    } else if (splashPageState is SplashPageIgnorePinState) {
      AutoRouter.of(context).push(const EmptyRoute());
    }
  }
}
