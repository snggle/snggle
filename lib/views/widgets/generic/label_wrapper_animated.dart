import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class LabelWrapperAnimated extends StatefulWidget {
  final String label;
  final Widget collapsedValue;
  final Widget expandedValue;
  final TextStyle labelStyle;
  final double labelGap;

  const LabelWrapperAnimated({
    required this.label,
    required this.collapsedValue,
    required this.expandedValue,
    required this.labelStyle,
    this.labelGap = 8,
    super.key,
  });

  @override
  _LabelWrapperAnimatedState createState() => _LabelWrapperAnimatedState();
}

class _LabelWrapperAnimatedState extends State<LabelWrapperAnimated> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> opacityFactor;
  late Animation<double> heightFactor;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    heightFactor = animationController.drive(CurveTween(curve: Curves.easeIn));
    opacityFactor = animationController.drive(Tween<double>(begin: 1, end: 0));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleSelection,
      child: AnimatedBuilder(
        animation: animationController.view,
        builder: (BuildContext context, _) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(widget.label, style: widget.labelStyle),
                          Expanded(
                            child: Opacity(
                              opacity: opacityFactor.value,
                              child: Align(alignment: Alignment.centerRight, child: widget.collapsedValue),
                            ),
                          ),
                        ],
                      ),
                      Opacity(
                        opacity: 1 - opacityFactor.value,
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.center,
                            heightFactor: heightFactor.value,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: widget.labelGap),
                                widget.expandedValue,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.lightGrey1,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _toggleSelection() {
    if (animationController.isCompleted) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}
