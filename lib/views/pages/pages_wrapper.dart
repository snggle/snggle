import 'package:flutter/material.dart';
import 'package:snuggle/views/layout/action_layout/action_layout.dart';

class PagesWrapper extends StatelessWidget {
  const PagesWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ActionLayout(
      resizeBottomInset: false,
      enableAppBar: true,
      scrollWidgets: <Widget>[],
      navigationWidgets: <Widget>[],
    );
  }
}
