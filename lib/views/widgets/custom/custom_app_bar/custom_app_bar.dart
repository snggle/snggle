import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar/custom_app_bar_search_box.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool popButtonVisible;
  final VoidCallback? leadingPressedCallback;
  final ValueChanged<String>? onSearch;
  final String? initialSearchPattern;

  const CustomAppBar({
    required this.title,
    this.popButtonVisible = false,
    this.leadingPressedCallback,
    this.onSearch,
    this.initialSearchPattern,
    super.key,
  });

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size(double.infinity, 56);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? searchPattern;

  @override
  void didUpdateWidget(covariant CustomAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSearchPattern == null ) {
      searchPattern = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool searchBoxVisibleBool = searchPattern != null;

    Widget leadingWidget = Builder(
      builder: (BuildContext context) {
        bool popAvailableBool = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
        if (widget.popButtonVisible || popAvailableBool) {
          return IconButton(
            onPressed: () => widget.leadingPressedCallback != null ? widget.leadingPressedCallback!() : Navigator.of(context).pop(),
            icon: const Icon(AppIcons.back, size: 16),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () => setState(() => searchPattern = ''),
                icon: Icon(AppIcons.search, color: AppColors.middleGrey, size: 20),
              ),
            ),
          );
        }
      },
    );

    if (searchBoxVisibleBool) {
      return CustomAppBarSearchBox(
        onClose: () => setState(() => searchPattern = null),
        onSearch: widget.onSearch,
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: AppBar(
          leading: widget.onSearch != null ? leadingWidget : null,
          title: Text(
            widget.title.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: 1.2),
          ),
        ),
      );
    }
  }
}
