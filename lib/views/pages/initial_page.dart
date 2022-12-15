import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/initial_page/initial_page_cubit.dart';
import 'package:snuggle/shared/router/router.gr.dart';

class InitPage extends StatelessWidget {
  final InitialPageCubit initialPageCubit = InitialPageCubit();
  InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<InitialPageCubit>(
        create: (BuildContext context) => initialPageCubit,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<InitialPageCubit, AInitialPageState>(
            listener: _handleListener,
            builder: (BuildContext context, AInitialPageState initialPageState) {
              if (initialPageState is InitialPageInitialState) {
                context.read<InitialPageCubit>().isIntroductionSetup();
              } else if (initialPageState is InitialPageErrorState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text('Error: Initial Page Setup failed'),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, AInitialPageState? initialPageState) {
    if (initialPageState is InitialPageSetupAuthenticationState) {
      AutoRouter.of(context).push(
        const SetupPinRoute(),
      );
    } else if (initialPageState is InitialPageAuthenticateState) {
      AutoRouter.of(context).push(
        const AuthRoute(),
      );
    } else if (initialPageState is InitialPageNoAuthenticationState) {
      AutoRouter.of(context).push(
        MainRoute(),
      );
    }
  }
}
