import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar_search_box.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool popButtonVisible;
  final bool searchBoxVisible;
  final VoidCallback? leadingPressedCallback;
  final ValueChanged<String?>? onSearch;

  const CustomAppBar({
    required this.title,
    this.popButtonVisible = false,
    this.searchBoxVisible = false,
    this.leadingPressedCallback,
    this.onSearch,
    super.key,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 56);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;

    bool popAvailableBool = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    if (widget.popButtonVisible || popAvailableBool) {
      leadingWidget = IconButton(
        onPressed: () => widget.leadingPressedCallback != null ? widget.leadingPressedCallback!() : Navigator.of(context).pop(),
        icon: const Icon(AppIcons.back, size: 24),
      );
    } else if (widget.onSearch != null) {
      leadingWidget = Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => widget.onSearch?.call(''),
            icon: Icon(AppIcons.search, color: AppColors.middleGrey, size: 20),
          ),
        ),
      );
    }

    if (widget.searchBoxVisible) {
      return CustomAppBarSearchBox(
        onClose: () => widget.onSearch?.call(null),
        onSearch: widget.onSearch,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AppBar(
          leading: leadingWidget,
          automaticallyImplyLeading: false,
          title: Text(
            widget.title.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 1.2),
          ),
        ),
      );
    }
  }
}
