import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_colors.dart';

class PaginatedWrapper extends StatefulWidget {
  final List<Widget> pages;
  final PageController pageController;

  const PaginatedWrapper({
    required this.pages,
    required this.pageController,
    super.key,
  });

  static _PaginatedWrapperState of(BuildContext context) {
    return context.findAncestorStateOfType<_PaginatedWrapperState>()!;
  }

  @override
  State<StatefulWidget> createState() => _PaginatedWrapperState();
}

class _PaginatedWrapperState extends State<PaginatedWrapper> {
  late ValueNotifier<int> currentPageIndexNotifier = ValueNotifier<int>(widget.pageController.initialPage);

  @override
  void dispose() {
    currentPageIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 24,
          child: ValueListenableBuilder<int>(
            valueListenable: currentPageIndexNotifier,
            builder: (BuildContext context, int currentPageIndex, _) => Text(
              '${currentPageIndex + 1}/${widget.pages.length}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
                height: 1.1,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: widget.pageController,
            children: widget.pages,
            onPageChanged: (int index) => currentPageIndexNotifier.value = currentPageIndexNotifier.value = index,
          ),
        ),
      ],
    );
  }
}
