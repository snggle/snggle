import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage(name: 'NetworkCreateRoute')
class NetworkCreateWrapper extends StatelessWidget {
  const NetworkCreateWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
