import 'package:flutter/material.dart';
import 'package:snuggle/views/widgets/custom/main_page_navigation_bar.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final ValueNotifier<int> pageNavigationTabNotifier = ValueNotifier<int>(0);
  final List<Widget> pageNavigationTabs = <Widget>[
    const Center(
      child: Text('Vaults', style: TextStyle(fontSize: 72)),
    ),
    const Center(
      child: Text('Secrets', style: TextStyle(fontSize: 72)),
    ),
    const Center(
      child: Text('', style: TextStyle(fontSize: 72)),
    ),
    const Center(
      child: Text('Apps', style: TextStyle(fontSize: 72)),
    ),
    const Center(
      child: Text('Settings', style: TextStyle(fontSize: 72)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false),
          body: ValueListenableBuilder<int>(
              valueListenable: pageNavigationTabNotifier,
              builder: (BuildContext context, int value, _) {
                return pageNavigationTabs[pageNavigationTabNotifier.value];
              }),
          bottomNavigationBar: ValueListenableBuilder<int>(
              valueListenable: pageNavigationTabNotifier,
              builder: (BuildContext context, int value, _) {
                return MainPageNavigationBar(
                  selectedIndex: pageNavigationTabNotifier.value,
                  onNavigationTabChanged: onPageNavigationTabChanged,
                );
              }),
        ));
  }

  void onPageNavigationTabChanged(int val) {
    if (val != 2) {
      pageNavigationTabNotifier.value = val;
    }
  }
}
