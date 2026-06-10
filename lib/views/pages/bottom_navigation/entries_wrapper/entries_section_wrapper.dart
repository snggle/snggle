import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

@RoutePage(name: 'EntriesSectionWrapperRoute')
class EntriesSectionWrapper extends StatelessWidget {
  final bool readOnlyBool;

  const EntriesSectionWrapper({
    required this.readOnlyBool,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
