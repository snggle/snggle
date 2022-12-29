import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/initial_page/initial_page_cubit.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_authentication_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_error_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_initial_setup_visible_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_initial_state.dart';
import 'package:snuggle/bloc/initial_page/states/initial_page_skip_authentication_state.dart';
import 'package:snuggle/shared/router/router.gr.dart';

class InitialPage extends StatelessWidget {
  final InitialPageCubit _initialPageCubit = InitialPageCubit();
  InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocProvider<InitialPageCubit>(
        create: (BuildContext context) => _initialPageCubit,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocConsumer<InitialPageCubit, AInitialPageState>(
            listener: _handleListener,
            builder: _handleBuilder,
          ),
        ),
      ),
    );
  }

  Widget _handleBuilder(BuildContext context, AInitialPageState initialPageState) {
    if (initialPageState is InitialPageInitialState) {
      context.read<InitialPageCubit>().checkInitialSetupVisibleState();
    } else if (initialPageState is InitialPageErrorState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Text('Error: InitialPageErrorState Error'),
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

  void _handleListener(BuildContext context, AInitialPageState? initialPageState) {
    if (initialPageState is InitialPageInitialSetupVisibleState) {
      AutoRouter.of(context).push(const SetupPinRoute());
    } else if (initialPageState is InitialPageAuthenticationState) {
      // TODO(Knight): Add push route for authentication
    } else if (initialPageState is InitialPageSkipAuthenticationState) {
      AutoRouter.of(context).push(const EmptyRoute());
    }
  }
}
