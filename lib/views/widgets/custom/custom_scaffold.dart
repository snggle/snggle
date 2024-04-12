import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool closeButtonVisible;
  final bool popAvailableBool;
  final bool popButtonVisible;
  final List<Widget>? actions;
  final BoxDecoration? boxDecoration;
  final VoidCallback? customPopCallback;
  final EdgeInsets? padding;

  const CustomScaffold({
    required this.title,
    required this.body,
    this.closeButtonVisible = false,
    this.popAvailableBool = true,
    this.popButtonVisible = true,
    this.actions,
    this.boxDecoration,
    this.customPopCallback,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: popAvailableBool,
      onPopInvoked: (_) => customPopCallback?.call(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                CustomAppBar(
                  title: title,
                  actions: actions,
                  closeButtonVisible: closeButtonVisible,
                  popButtonVisible: popButtonVisible,
                  customPopCallback: customPopCallback,
                ),
                Expanded(
                  child: Container(
                    margin: padding,
                    decoration: boxDecoration,
                    child: body,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
