import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/auth_page/auth_page_cubit.dart';
import 'package:snuggle/shared/router/router.gr.dart';

class InitPage extends StatelessWidget {
  final AuthPageCubit authPageCubit = AuthPageCubit();
  InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: BlocProvider<AuthPageCubit>(
          create: (BuildContext context) => authPageCubit,
          child: Scaffold(
              backgroundColor: Colors.white,
              body: BlocConsumer<AuthPageCubit, AAuthPageState>(
                listener: _handleListener,
                builder: _handleBuilder,
              )),
        ));
  }

  Widget _handleBuilder(BuildContext context, AAuthPageState? authPageState) {
    if (authPageState is AuthPageInitialState) {
      context.read<AuthPageCubit>().isAuthenticationSetup();
    } else if (authPageState is AuthPageErrorAuthenticationState) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const <Widget>[
          Text('Error: isAuthenticationSetup failed'),
          CircularProgressIndicator(),
        ]),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  void _handleListener(BuildContext context, AAuthPageState? authPageState) {
    if (authPageState is AuthPageSetupAuthenticationState) {
      AutoRouter.of(context).push(const SetupPinRoute());
    } else if (authPageState is AuthPageAuthenticateState) {
      AutoRouter.of(context).push(AuthRoute(authPageCubit: authPageCubit));
    } else if (authPageState is AuthPageNoAuthenticationState) {
      AutoRouter.of(context).push(MainRoute());
    }
  }
}
