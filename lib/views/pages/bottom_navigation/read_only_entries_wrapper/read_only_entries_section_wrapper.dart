import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'ReadOnlyEntriesSectionWrapperRoute')
class ReadOnlyEntriesSectionWrapper extends StatelessWidget {
  const ReadOnlyEntriesSectionWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
