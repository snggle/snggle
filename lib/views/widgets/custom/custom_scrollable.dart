import 'package:flutter/material.dart';

class CustomScrollable extends StatelessWidget {
  final List<Widget> scrollWidgets;
  const CustomScrollable({
    required this.scrollWidgets,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thickness: 5,
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: scrollWidgets),
        ),
      ),
    );
  }
}
