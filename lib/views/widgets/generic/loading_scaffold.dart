import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';
import 'package:snggle/views/widgets/icons/asset_animated_icon.dart';

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: Center(
          child: AssetAnimatedIcon(AppAnimatedIcons.snggle_face, size: 92),
        ),
      ),
    );
  }
}
