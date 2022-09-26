import 'package:flutter/material.dart';
import 'package:snuggle/shared/router/router.gr.dart';

void main() {
  runApp(const AppCore());
}

class AppCore extends StatefulWidget {
  const AppCore({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppCoreState();
}

class _AppCoreState extends State<AppCore> {
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: appRouter.defaultRouteParser(),
      routerDelegate: appRouter.delegate(),
      debugShowCheckedModeBanner: false,
      builder: (_, Widget? routerWidget) {
        return routerWidget as Widget;
      },
    );
  }
}
