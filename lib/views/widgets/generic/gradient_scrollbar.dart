import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class GradientScrollbar extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final double thickness;
  final EdgeInsets? margin;

  const GradientScrollbar({
    required this.child,
    required this.scrollController,
    this.thickness = 3.0,
    this.margin,
    super.key,
  });

  @override
  _GradientScrollbarState createState() => _GradientScrollbarState();
}

class _GradientScrollbarState extends State<GradientScrollbar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: widget.margin,
            width: widget.thickness,
            child: ListenableBuilder(
              listenable: widget.scrollController,
              builder: (BuildContext context, _) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    ScrollPosition scrollPosition = widget.scrollController.positions.first;
                    if (scrollPosition.maxScrollExtent == 0.0) {
                      return const SizedBox();
                    }

                    double viewportDimension = scrollPosition.viewportDimension;
                    double maxScrollExtent = scrollPosition.maxScrollExtent;

                    double thumbHeight = viewportDimension * (viewportDimension / (maxScrollExtent + viewportDimension)) / 1.2;
                    double thumbOffset = (scrollPosition.pixels * (constraints.maxHeight - thumbHeight) / maxScrollExtent).abs();

                    return Container(
                      height: double.infinity,
                      width: widget.thickness,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey1,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: thumbOffset),
                          height: thumbHeight,
                          width: widget.thickness,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: <Color>[Color(0xFF42D2FF), Color(0xFF939393)],
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
