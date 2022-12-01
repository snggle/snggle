import 'package:flutter/material.dart';
import 'package:snuggle/views/layout/action_layout/widgets/action_layout_navigation.dart';
import 'package:snuggle/views/widgets/custom/custom_scrollable.dart';

class ActionLayoutScaffold extends StatelessWidget {
  final bool enableAppBar;
  final bool resizeBottomInset;
  final String titleText;

  final List<Widget> appBarActionsWidgets;
  final List<Widget> navigationWidgets;
  final List<Widget> scrollWidgets;

  const ActionLayoutScaffold({
    required this.enableAppBar,
    required this.resizeBottomInset,
    required this.titleText,
    required this.appBarActionsWidgets,
    required this.navigationWidgets,
    required this.scrollWidgets,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeBottomInset,
      backgroundColor: Colors.white,
      appBar: enableAppBar
          ? AppBar(
              title: Text(titleText),
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: appBarActionsWidgets,
            )
          : null,
      body: CustomScrollable(
        scrollWidgets: scrollWidgets,
      ),
      bottomNavigationBar: ActionLayoutNavigation(navigationWidgets: navigationWidgets),
    );
  }
}
