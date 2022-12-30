import 'package:equatable/equatable.dart';
import 'package:snuggle/bloc/setup_pin_page/main_navigation_page/constants/main_page_navigation_bar_items.dart';

class AMainNavigationPageState extends Equatable {
  final int index;
  final MainPageNavigationBarItem mainPageNavigationBarItem;

  const AMainNavigationPageState(this.mainPageNavigationBarItem, this.index);

  @override
  List<Object> get props => <Object>[mainPageNavigationBarItem, index];
}
