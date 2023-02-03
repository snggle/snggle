import 'package:flutter/material.dart';
import 'package:snggle/views/layout/action_layout/widgets/action_layout_scaffold.dart';

class ActionLayout extends StatelessWidget {
  final bool resizeBottomInset;
  final List<Widget> navigationWidgets;
  final List<Widget> scrollWidgets;

  final bool enableAppBar;
  final String titleText;
  final List<Widget> appBarActionsWidgets;

  const ActionLayout({
    required this.resizeBottomInset,
    required this.navigationWidgets,
    required this.scrollWidgets,
    this.enableAppBar = true,
    this.titleText = '',
    this.appBarActionsWidgets = const <Widget>[],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleActionLayoutFocus(context),
      child: ActionLayoutScaffold(
        enableAppBar: enableAppBar,
        resizeBottomInset: resizeBottomInset,
        titleText: titleText,
        appBarActionsWidgets: appBarActionsWidgets,
        navigationWidgets: navigationWidgets,
        scrollWidgets: scrollWidgets,
      ),
    );
  }

  void _handleActionLayoutFocus(BuildContext context) {
    FocusScopeNode isFocused = FocusScope.of(context);
    if (!isFocused.hasPrimaryFocus) {
      isFocused.unfocus();
    }
  }
}
