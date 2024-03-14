import 'package:flutter/material.dart';
import 'package:snggle/config/app_colors.dart';
import 'package:snggle/config/app_icons.dart';

class CustomAppBarSearchBox extends StatefulWidget {
  final VoidCallback onClose;
  final ValueChanged<String>? onSearch;

  const CustomAppBarSearchBox({
    required this.onClose,
    this.onSearch,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CustomAppBarSearchBoxState();
}

class _CustomAppBarSearchBoxState extends State<CustomAppBarSearchBox> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(_handleFocusChanged);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => _closeSearchBox(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: TextField(
            focusNode: searchFocusNode,
            controller: searchController,
            autofocus: true,
            style: textTheme.bodyMedium!.copyWith(color: AppColors.body1),
            onChanged: widget.onSearch,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: textTheme.bodyMedium!.copyWith(color: AppColors.middleGrey),
              prefixIconConstraints: const BoxConstraints(minWidth: 26, maxWidth: 26),
              suffixIconConstraints: const BoxConstraints(minWidth: 34, maxWidth: 34),
              prefixIcon: Align(
                alignment: Alignment.centerLeft,
                child: Icon(AppIcons.search, color: AppColors.middleGrey, size: 20),
              ),
              suffixIcon: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: _closeSearchBox,
                  icon: Icon(AppIcons.close_1, color: AppColors.body1, size: 16),
                ),
              ),
              border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightGrey2)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightGrey2)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.lightGrey2)),
            ),
          ),
        ),
      ),
    );
  }

  void _handleFocusChanged() {
    if(searchFocusNode.hasFocus == false && searchController.text.isEmpty) {
      _closeSearchBox();
    }
  }

  void _closeSearchBox() {
    FocusManager.instance.primaryFocus?.unfocus();

    searchController.clear();
    widget.onSearch?.call('');
    widget.onClose();
  }
}
