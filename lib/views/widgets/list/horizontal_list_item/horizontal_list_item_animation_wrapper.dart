import 'package:flutter/cupertino.dart';

typedef ChildBuilder = Widget Function(AnimationController fadeAnimationController, AnimationController slideAnimationController);

class HorizontalListItemAnimationWrapper extends StatefulWidget {
  final ChildBuilder childBuilder;

  const HorizontalListItemAnimationWrapper({
    required this.childBuilder,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HorizontalListItemAnimationWrapperState();
}

class _HorizontalListItemAnimationWrapperState extends State<HorizontalListItemAnimationWrapper> with TickerProviderStateMixin {
  late final AnimationController fadeAnimationController;
  late final AnimationController slideAnimationController;

  @override
  void initState() {
    fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..forward();

    super.initState();
  }

  @override
  void dispose() {
    fadeAnimationController.dispose();
    slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(fadeAnimationController, slideAnimationController);
  }
}
