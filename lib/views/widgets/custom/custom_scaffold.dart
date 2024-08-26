import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

class CustomScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final bool closeButtonVisible;
  final bool popAvailableBool;
  final bool popButtonVisible;
  final bool resizeToAvoidBottomInsetBool;
  final String? subtitle;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final BoxDecoration? boxDecoration;
  final VoidCallback? customPopCallback;
  final VoidCallback? customSystemPopCallback;
  final EdgeInsets? padding;

  const CustomScaffold({
    required this.title,
    required this.body,
    this.closeButtonVisible = false,
    this.popAvailableBool = true,
    this.popButtonVisible = true,
    this.resizeToAvoidBottomInsetBool = false,
    this.subtitle,
    this.floatingActionButton,
    this.actions,
    this.boxDecoration,
    this.customPopCallback,
    this.customSystemPopCallback,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: popAvailableBool,
      onPopInvoked: (_) => customSystemPopCallback != null ? customSystemPopCallback?.call() : customPopCallback?.call(),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInsetBool,
        floatingActionButton: floatingActionButton,
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CustomAppBar(
                    title: title,
                    subtitle: subtitle,
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
      ),
    );
  }
}
