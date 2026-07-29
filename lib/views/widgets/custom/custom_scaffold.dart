import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar.dart';

class CustomScaffold extends StatelessWidget {
  final String _title;
  final Widget _body;
  final bool _closeButtonVisible;
  final bool _popAvailableBool;
  final bool _popButtonVisible;
  final bool _resizeToAvoidBottomInsetBool;
  final String? _subtitle;
  final Widget? _floatingActionButton;
  final List<Widget>? _actions;
  final BoxDecoration? _boxDecoration;
  final VoidCallback? _customPopCallback;
  final VoidCallback? _customSystemPopCallback;
  final EdgeInsets? _padding;
  final Color? _backgroundColor;
  final Color? _foregroundColor;

  const CustomScaffold({
    required this._title,
    required this._body,
    this._closeButtonVisible = false,
    this._popAvailableBool = true,
    this._popButtonVisible = true,
    this._resizeToAvoidBottomInsetBool = false,
    this._subtitle,
    this._floatingActionButton,
    this._actions,
    this._boxDecoration,
    this._customPopCallback,
    this._customSystemPopCallback,
    this._padding,
    this._backgroundColor,
    this._foregroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _popAvailableBool,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }

        VoidCallback? callback = _customSystemPopCallback ?? _customPopCallback;
        callback?.call();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: _resizeToAvoidBottomInsetBool,
        backgroundColor: _backgroundColor,
        floatingActionButton: _floatingActionButton,
        body: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CustomAppBar(
                    title: _title,
                    subtitle: _subtitle,
                    actions: _actions,
                    closeButtonVisible: _closeButtonVisible,
                    popButtonVisible: _popButtonVisible,
                    customPopCallback: _customPopCallback,
                    foregroundColor: _foregroundColor,
                  ),
                  Expanded(
                    child: Container(
                      margin: _padding,
                      decoration: _boxDecoration,
                      child: _body,
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
