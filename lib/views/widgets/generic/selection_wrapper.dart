import 'package:flutter/material.dart';
import 'package:snggle/views/widgets/custom/custom_checkbox.dart';

class SelectionWrapper extends StatelessWidget {
  final bool selectedBool;
  final Widget child;
  final ValueChanged<bool> onSelectValueChanged;
  final EdgeInsets padding;

  const SelectionWrapper({
    required this.selectedBool,
    required this.child,
    required this.onSelectValueChanged,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelectValueChanged(selectedBool == false),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: <Widget>[
            Positioned.fill(child: child),
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: padding,
                child: CustomCheckbox(selectedBool: selectedBool, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
