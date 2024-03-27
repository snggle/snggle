import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar/custom_app_bar.dart';

class CustomScaffold extends StatelessWidget {
  final bool popAvailableBool;
  final bool popButtonVisible;
  final bool scrollDisabledBool;
  final String title;
  final List<Widget> slivers;
  final bool searchBoxVisible;
  final bool expandedSearchbar;
  final VoidCallback? customPopCallback;
  final EdgeInsets? padding;
  final BoxDecoration? boxDecoration;
  final ValueChanged<String?>? onSearch;

  const CustomScaffold({
    required this.popAvailableBool,
    required this.popButtonVisible,
    required this.scrollDisabledBool,
    required this.title,
    required this.slivers,
    this.searchBoxVisible = false,
    this.expandedSearchbar = false,
    this.customPopCallback,
    this.padding,
    this.boxDecoration,
    this.onSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: popAvailableBool == false,
      onPopInvoked: (_) => customPopCallback?.call(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              CustomAppBar(
                title: title,
                popButtonVisible: popButtonVisible,
                leadingPressedCallback: customPopCallback,
                expandedSearchbar: expandedSearchbar,
                searchBoxVisible: searchBoxVisible,
                onSearch: onSearch,
              ),
              Expanded(
                child: Container(
                  margin: padding,
                  decoration: boxDecoration,
                  child: CustomScrollView(
                    shrinkWrap: scrollDisabledBool,
                    physics: scrollDisabledBool ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                    slivers: slivers,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
