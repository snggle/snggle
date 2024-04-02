import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';

class FolderNavigationAnimation extends StatefulWidget {
  final VoidCallback onEnd;
  final Offset startOffset;
  final Offset endOffset;
  final Size startSize;
  final Size endSize;

  const FolderNavigationAnimation({
    required this.onEnd,
    required this.startOffset,
    required this.endOffset,
    required this.startSize,
    required this.endSize,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _FolderNavigationAnimation();
}

class _FolderNavigationAnimation extends State<FolderNavigationAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Size> _sizeAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _positionAnimation = Tween<Offset>(begin: widget.startOffset, end: widget.endOffset).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _sizeAnimation = Tween<Size>(begin: widget.startSize, end: widget.endSize).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _controller.forward().whenComplete(widget.onEnd);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _positionAnimation,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: _positionAnimation.value.dy,
              left: _positionAnimation.value.dx,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: AnimatedBuilder(
                  animation: _sizeAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      width: _sizeAnimation.value.width,
                      height: _sizeAnimation.value.height,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.middleGrey, width: 1),
                        borderRadius: BorderRadius.circular(38),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
