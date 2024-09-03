import 'package:flutter/material.dart';
import 'package:snggle/config/app_icons/app_animated_icons.dart';
import 'package:snggle/views/widgets/icons/asset_animated_icon.dart';

class GifButton extends StatelessWidget {
  final String label;
  final AssetAnimatedIconData assetAnimatedIconData;
  final VoidCallback onPressed;

  const GifButton({
    required this.label,
    required this.assetAnimatedIconData,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onPressed,
        child: Column(
          children: <Widget>[
            AssetAnimatedIcon(assetAnimatedIconData, size: 124),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
