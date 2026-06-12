import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/shared/utils/android_utils.dart';
import 'package:snggle/shared/utils/custom_clipboard.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_background.dart';
import 'package:snggle/views/widgets/tooltip/context_tooltip/context_tooltip_wrapper.dart';

typedef CopyWrapperBuilder = Widget Function(BuildContext context);
typedef CopyCallbackBuilder = Widget Function(BuildContext context, VoidCallback copyCallback);

class CopyWrapper extends StatefulWidget {
  final String value;
  final CopyWrapperBuilder? copyWrapperBuilder;
  final CopyCallbackBuilder? copyCallbackBuilder;
  final bool obscureContentBool;

  const CopyWrapper({
    required this.value,
    required CopyWrapperBuilder this.copyWrapperBuilder,
    this.obscureContentBool = false,
    super.key,
  }) : copyCallbackBuilder = null;

  const CopyWrapper.withCopyAction({
    required this.value,
    required CopyCallbackBuilder this.copyCallbackBuilder,
    this.obscureContentBool = false,
    super.key,
  }) : copyWrapperBuilder = null;

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
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _copy,
        child: widget.copyCallbackBuilder?.call(context, _copy) ?? widget.copyWrapperBuilder!.call(context),
      ),
    );
  }

  Future<void> _copy() async {
    if (widget.obscureContentBool) {
      await CustomClipboard.setDataObscuringPreview(text: widget.value);
    } else {
      await Clipboard.setData(ClipboardData(text: widget.value));
    }

    if (mounted == false) {
      return;
    }

    // TODO(Kamil): Remove this workaround once Android versions below API level 33 are deprecated, newer versions handle copy confirmation natively.
    bool androidPopupDisplayedBool = await _isAndroidDisplayingPopup();
    if (androidPopupDisplayedBool) {
      return;
    }

    customPopupMenuController.showMenu();
    await Future<void>.delayed(const Duration(seconds: 2)).then((_) {
      if (mounted) {
        customPopupMenuController.hideMenu();
      }
    });
  }

  Future<bool> _isAndroidDisplayingPopup() async {
    /// Android API level 33 and higher displays its own copy confirmation popup.
    /// So our popup should not be displayed there to avoid duplicate notification.
    /// https://developer.android.com/develop/ui/views/touch-and-input/copy-paste?hl=pl#duplicate-notifications
    if (kIsWeb == false && defaultTargetPlatform == TargetPlatform.android) {
      int? apiLevel = await AndroidUtils.getApiLevel();
      if (apiLevel != null && apiLevel > 32) {
        return true;
      }
    }
    return false;
  }
}
