import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';
import 'package:snggle/views/widgets/custom/custom_app_bar/custom_app_bar_search_box.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool expandedSearchbar;
  final bool popButtonVisible;
  final bool searchBoxVisible;
  final VoidCallback? leadingPressedCallback;
  final ValueChanged<String?>? onSearch;

  const CustomAppBar({
    required this.title,
    this.expandedSearchbar = false,
    this.popButtonVisible = false,
    this.searchBoxVisible = false,
    this.leadingPressedCallback,
    this.onSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget;
    Widget? trailingWidget;

    bool popAvailableBool = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    if (popButtonVisible || popAvailableBool) {
      leadingWidget = AspectRatio(
        aspectRatio: 1 / 1,
        child: IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          onPressed: () => leadingPressedCallback != null ? leadingPressedCallback!() : Navigator.of(context).pop(),
          icon: Icon(AppIcons.back, size: 24, color: AppColors.body1),
        ),
      );
    } else if (expandedSearchbar == false && onSearch != null) {
      leadingWidget = AspectRatio(
        aspectRatio: 1 / 1,
        child: IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          onPressed: () => onSearch?.call(''),
          icon: Center(
            child: Icon(AppIcons.search, color: AppColors.middleGrey, size: 20),
          ),
        ),
      );
    }

    if (expandedSearchbar && onSearch != null) {
      trailingWidget = AspectRatio(
        aspectRatio: 1 / 1,
        child: IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          onPressed: () => searchBoxVisible ? onSearch?.call(null) : onSearch?.call(''),
          icon: Icon(searchBoxVisible ? AppIcons.open : AppIcons.collapse, size: 24, color: AppColors.body1),
        ),
      );
    }

    Widget appBarWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 30,
          child: leadingWidget,
        ),
        Expanded(
          child: Text(
            title.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              letterSpacing: 1.2,
              color: AppColors.body1,
            ),
          ),
        ),
        SizedBox(width: 30, child: trailingWidget),
      ],
    );

    if (searchBoxVisible && expandedSearchbar) {
      appBarWidget = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          appBarWidget,
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 5),
            child: CustomAppBarSearchBox(
              onClose: () => onSearch?.call(null),
              onSearch: onSearch,
            ),
          ),
        ],
      );
    } else if (searchBoxVisible && expandedSearchbar == false) {
      appBarWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: CustomAppBarSearchBox(
          onClose: () => onSearch?.call(null),
          onSearch: onSearch,
        ),
      );
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 10, right: 16),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.topCenter,
          child: appBarWidget,
        ),
      ),
    );
  }
}
