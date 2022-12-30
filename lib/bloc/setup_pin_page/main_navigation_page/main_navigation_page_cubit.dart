import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snuggle/bloc/setup_pin_page/main_navigation_page/a_main_navigation_page_state.dart';
import 'package:snuggle/bloc/setup_pin_page/main_navigation_page/constants/main_page_navigation_bar_items.dart';

class MainNavigationPageCubit extends Cubit<AMainNavigationPageState> {
  MainNavigationPageCubit() : super(const AMainNavigationPageState(MainPageNavigationBarItem.vaults, 0));

  void getMainNavigationItem(MainPageNavigationBarItem mainPageNavigationBarItem) {
    switch (mainPageNavigationBarItem) {
      case MainPageNavigationBarItem.vaults:
        emit(const AMainNavigationPageState(MainPageNavigationBarItem.vaults, 0));
        break;
      case MainPageNavigationBarItem.secrets:
        emit(const AMainNavigationPageState(MainPageNavigationBarItem.secrets, 1));
        break;
      case MainPageNavigationBarItem.qrcode:
        emit(const AMainNavigationPageState(MainPageNavigationBarItem.qrcode, 2));
        break;
      case MainPageNavigationBarItem.apps:
        emit(const AMainNavigationPageState(MainPageNavigationBarItem.apps, 3));
        break;
      case MainPageNavigationBarItem.settings:
        emit(const AMainNavigationPageState(MainPageNavigationBarItem.settings, 4));
        break;
    }
  }
}
