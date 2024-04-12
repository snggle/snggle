import 'package:flutter/cupertino.dart';
import 'package:snggle/config/app_colors.dart';

class PaginatedForm extends StatefulWidget {
  final List<Widget> pages;
  final PageController pageController;

  const PaginatedForm({
    required this.pages,
    required this.pageController,
    super.key,
  });

  static _PaginatedFormState of(BuildContext context) {
    return context.findAncestorStateOfType<_PaginatedFormState>()!;
  }

  @override
  State<StatefulWidget> createState() => _PaginatedFormState();
}

class _PaginatedFormState extends State<PaginatedForm> {
  late int currentPageIndex = widget.pageController.initialPage;
  bool customPopAvailableBool = true;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentPageIndex == 0,
      onPopInvoked: (bool didPop) {
        if (customPopAvailableBool && didPop == false) {
          FocusManager.instance.primaryFocus?.unfocus();
          widget.pageController.previousPage(duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
        }
      },
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 24,
            child: Text(
              '${currentPageIndex + 1}/${widget.pages.length}',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: widget.pageController,
              children: widget.pages,
              onPageChanged: (int index) => setState(() => currentPageIndex = index),
            ),
          ),
        ],
      ),
    );
  }

  void disablePop() {
    customPopAvailableBool = false;
  }

  void enablePop() {
    customPopAvailableBool = true;
  }
}
