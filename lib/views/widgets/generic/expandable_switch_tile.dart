import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/generic/gradient_switch.dart';

class ExpandableSwitchTile extends StatefulWidget {
  final String label;
  final Widget body;

  const ExpandableSwitchTile({
    required this.label,
    required this.body,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ExpandableSwitchTileState();
}

class _ExpandableSwitchTileState extends State<ExpandableSwitchTile> with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  late bool _expandedBool = false;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  widget.label,
                  style: theme.textTheme.labelMedium?.copyWith(color: AppColors.darkGrey),
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _handleSwitchStateChanged,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: GradientSwitch(enabledBool: _expandedBool),
              ),
            ),
          ],
        ),
        if (_expandedBool) ...<Widget>[
          SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: animation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lightGrey2),
              ),
              child: widget.body,
            ),
          ),
        ]
      ],
    );
  }

  void _handleSwitchStateChanged() {
    setState(() => _expandedBool = _expandedBool == false);
    if (_expandedBool) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }
}
