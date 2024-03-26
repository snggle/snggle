import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final bool popAvailableBool;
  final Widget body;
  final PreferredSizeWidget appBar;
  final PopInvokedCallback? customPopCallback;

  const CustomScaffold({
    required this.popAvailableBool,
    required this.body,
    required this.appBar,
    this.customPopCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: popAvailableBool == false,
      onPopInvoked: customPopCallback,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          appBar: appBar,
          body: body,
        ),
      ),
    );
  }
}
