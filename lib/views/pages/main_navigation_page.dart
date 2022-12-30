import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/setup_pin_page/main_navigation_page/a_main_navigation_page_state.dart';
import 'package:snuggle/bloc/setup_pin_page/main_navigation_page/constants/main_page_navigation_bar_items.dart';
import 'package:snuggle/bloc/setup_pin_page/main_navigation_page/main_navigation_page_cubit.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  _AMainNavigationPageState createState() => _AMainNavigationPageState();
}

class _AMainNavigationPageState extends State<MainNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainNavigationPageCubit>(
      create: (BuildContext context) => MainNavigationPageCubit(),
      child: Scaffold(
        bottomNavigationBar: _buildBottomNavigationBar(context),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<MainNavigationPageCubit, AMainNavigationPageState>(builder: (BuildContext context, AMainNavigationPageState mainNavigationPageState) {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: mainNavigationPageState.index,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet_outlined,
            ),
            label: 'Vaults',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.square_outlined,
            ),
            label: 'Secrets',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code,
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.apps_outlined,
            ),
            label: 'Apps',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
            ),
            label: 'Settings',
          ),
        ],
        onTap: (int index) {
          if (index == 0) {
            BlocProvider.of<MainNavigationPageCubit>(context).getMainNavigationItem(MainPageNavigationBarItem.vaults);
          } else if (index == 1) {
            BlocProvider.of<MainNavigationPageCubit>(context).getMainNavigationItem(MainPageNavigationBarItem.secrets);
          } else if (index == 2) {
            //BlocProvider.of<NavigationCubit>(context).getmainPageNavigationBarItem(mainPageNavigationBarItem.qrcode);
          } else if (index == 3) {
            BlocProvider.of<MainNavigationPageCubit>(context).getMainNavigationItem(MainPageNavigationBarItem.apps);
          } else if (index == 4) {
            BlocProvider.of<MainNavigationPageCubit>(context).getMainNavigationItem(MainPageNavigationBarItem.settings);
          }
        },
      );
    });
  }
}

Widget _buildBody(BuildContext context) {
  return BlocBuilder<MainNavigationPageCubit, AMainNavigationPageState>(
    builder: (BuildContext context, AMainNavigationPageState mainNavigationPageState) {
      if (mainNavigationPageState.mainPageNavigationBarItem == MainPageNavigationBarItem.vaults) {
        // TODO(Knight): Navigating to Vaults page
        return Container();
      } else if (mainNavigationPageState.mainPageNavigationBarItem == MainPageNavigationBarItem.secrets) {
        // TODO(Knight): Navigating to Secrets page
        return Container();
      } else if (mainNavigationPageState.mainPageNavigationBarItem == MainPageNavigationBarItem.qrcode) {
        // return Container();
      } else if (mainNavigationPageState.mainPageNavigationBarItem == MainPageNavigationBarItem.apps) {
        // TODO(Knight): Navigating to Apps page
        return Container();
      } else if (mainNavigationPageState.mainPageNavigationBarItem == MainPageNavigationBarItem.settings) {
        // TODO(Knight): Navigating to Settings page
        return Container();
      }
      return Container();
    },
  );
}
