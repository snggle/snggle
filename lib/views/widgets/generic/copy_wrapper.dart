import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_background.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_wrapper.dart';

class CopyWrapper extends StatefulWidget {
  final String value;
  final Widget child;
  final VoidCallback? onTap;

  const CopyWrapper({
    required this.value,
    required this.child,
    this.onTap,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CopyWrapperState();
}

class _CopyWrapperState extends State<CopyWrapper> {
  final CustomPopupMenuController customPopupMenuController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return ContextTooltipWrapper(
      controller: customPopupMenuController,
      pressType: PressType.longPress,
      verticalMargin: 0,
      content: ContextTooltipBackground(
        borderRadius: 10,
        borderWeight: 0.6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          child: Text('Copied', style: textTheme.labelMedium?.copyWith(color: AppColors.body3)),
        ),
      ),
      child: Container(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: widget.onTap,
          onLongPress: _copy,
          child: widget.child,
        ),
      ),
    );
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.value));
    customPopupMenuController.showMenu();
    Future<void>.delayed(const Duration(seconds: 2)).then((_) {
      if (mounted) {
        customPopupMenuController.hideMenu();
      }
    });
  }
}
