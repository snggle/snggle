import 'package:flutter/cupertino.dart';
import 'package:snggle/views/widgets/generic/gradient_scrollbar.dart';

class MnemonicFormLayout extends StatelessWidget {
  final Widget child;
  final ScrollController scrollController;
  final bool bottomMarginVisibleBool;

  const MnemonicFormLayout({
    required this.child,
    required this.scrollController,
    this.bottomMarginVisibleBool = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10),
      child: GradientScrollbar(
        scrollController: scrollController,
        margin: EdgeInsets.only(bottom: bottomMarginVisibleBool ? 80 : 10),
        child: Padding(
          padding: const EdgeInsets.only(right: 6),
          child: SingleChildScrollView(
            controller: scrollController,
            child: child,
          ),
        ),
      ),
    );
  }
}
